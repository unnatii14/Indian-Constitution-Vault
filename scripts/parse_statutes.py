"""Parse non-Constitution statutes (BNS/BNSS/BSA) into structured JSON."""
from __future__ import annotations

import argparse
import json
import re
from collections import OrderedDict
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable

CLAUSE_PATTERNS = [
    ("numeric", re.compile(r"^\((\d+[A-Z]?)\)\s*(.*)")),
    ("roman", re.compile(r"^\(([ivxl]+)\)\s*(.*)", re.IGNORECASE)),
    ("alpha_lower", re.compile(r"^\(([a-z])\)\s*(.*)")),
    ("alpha_upper", re.compile(r"^\(([A-Z])\)\s*(.*)")),
]
CLAUSE_LEVELS = {
    "numeric": 1,
    "alpha_upper": 2,
    "alpha_lower": 2,
    "roman": 3,
}

SECTION_RE = re.compile(r"^(\d+[A-Z]?)\.\s*(.*)")
CHAPTER_RE = re.compile(r"^CHAPTER\s+([IVXLC]+)(?:\s+(.*))?", re.IGNORECASE)
TOPIC_RE = re.compile(r"^(of\b.+|[A-Z][A-Z ',-/&()]+)$", re.IGNORECASE)
START_TRIGGER_RE = re.compile(r"^BE\s+it\s+enacted", re.IGNORECASE)
HEADING_SPLIT_RE = re.compile(r"\s*[-–—]{2,}\s*")


@dataclass
class ActConfig:
    act_id: str
    language: str
    source: Path
    target: Path
    expected_min_sections: int
    expected_max_sections: int | None = None
    start_pattern: re.Pattern[str] | None = START_TRIGGER_RE
    skip_start_trigger: bool = False


ACTS: list[ActConfig] = [
    ActConfig(
        act_id="BNS-2023",
        language="en",
        source=Path("data/processed/pdf/bns_2023_en.txt"),
        target=Path("data/structured/bns_en.json"),
        expected_min_sections=350,
        expected_max_sections=400,
    ),
    ActConfig(
        act_id="BNSS-2023",
        language="en",
        source=Path("data/processed/pdf/bnss_2023_en.txt"),
        target=Path("data/structured/bnss_en.json"),
        expected_min_sections=300,
        expected_max_sections=700,
    ),
    ActConfig(
        act_id="BSA-2023",
        language="en",
        source=Path("data/processed/pdf/bsa_2023_en.txt"),
        target=Path("data/structured/bsa_en.json"),
        expected_min_sections=150,
        expected_max_sections=250,
    ),
    ActConfig(
        act_id="IPC-1860",
        language="en",
        source=Path("data/processed/pdf/ipc_1860_en.txt"),
        target=Path("data/structured/ipc_en.json"),
        expected_min_sections=400,
        expected_max_sections=600,
        skip_start_trigger=True,
    ),
    ActConfig(
        act_id="CRPC-1973",
        language="en",
        source=Path("data/processed/pdf/crpc_1973_en.txt"),
        target=Path("data/structured/crpc_en.json"),
        expected_min_sections=400,
        expected_max_sections=700,
        skip_start_trigger=True,
    ),
    ActConfig(
        act_id="EA-1872",
        language="en",
        source=Path("data/processed/html/evidence_act_1872.txt"),
        target=Path("data/structured/evidence_en.json"),
        expected_min_sections=120,
        expected_max_sections=220,
        skip_start_trigger=True,
    ),
]


def parse_statute_text(
    text: str,
    *,
    act_id: str,
    language: str,
    expected_min_sections: int | None = None,
    expected_max_sections: int | None = None,
    start_pattern: re.Pattern[str] | None = START_TRIGGER_RE,
    skip_start_trigger: bool = False,
) -> dict:
    text = _ensure_section_newlines(text)
    sections: list[dict] = []
    chapter_order: list[str] = []
    chapters: "OrderedDict[str, dict]" = OrderedDict()
    current_chapter: dict | None = None
    current_topic: str | None = None
    chapter_title_pending = False
    current_section: dict | None = None
    started = skip_start_trigger or start_pattern is None
    last_section_value = 0.0

    for raw_line in text.splitlines():
        line = raw_line.replace("\x0c", " ").strip()
        if not line:
            continue
        if not started:
            if start_pattern and start_pattern.match(line):
                started = True
            continue
        if line.isdigit():
            continue
        if chapter_title_pending and current_chapter:
            current_chapter["title"] = normalize_whitespace(line)
            chapter_title_pending = False
            continue
        chapter_match = CHAPTER_RE.match(line)
        if chapter_match:
            current_section = _finalize_section(current_section, sections)
            code = chapter_match.group(1).upper()
            title_inline = chapter_match.group(2)
            if code not in chapters:
                chapters[code] = {"code": code, "title": ""}
                chapter_order.append(code)
            current_chapter = chapters[code]
            if title_inline:
                current_chapter["title"] = normalize_whitespace(title_inline)
                chapter_title_pending = False
            else:
                chapter_title_pending = True
            current_topic = None
            continue
        if current_section is None and _looks_like_topic(line):
            current_topic = normalize_whitespace(line)
            continue
        section_match = SECTION_RE.match(line)
        if section_match:
            number = section_match.group(1)
            value = _section_sort_value(number)
            if sections and value + 0.5 < last_section_value:
                if current_section:
                    current_section["lines"].append(line)
                continue
            last_section_value = max(last_section_value, value)
            current_section = _finalize_section(current_section, sections)
            heading_raw = section_match.group(2).strip()
            heading, first_line = _split_heading_and_inline_text(heading_raw)
            section_entry = {
                "section_number": number,
                "heading": heading,
                "chapter": dict(current_chapter) if current_chapter else None,
                "subheading": current_topic,
                "lines": [],
            }
            if first_line:
                section_entry["lines"].append(first_line)
            current_section = section_entry
            continue
        if current_section:
            current_section["lines"].append(line)

    _finalize_section(current_section, sections)

    data = {
        "act_id": act_id,
        "language": language,
        "sections": sections,
    }
    if chapters:
        ordered = [chapters[code] for code in chapter_order]
        data["chapters"] = ordered

    if expected_min_sections is not None and len(sections) < expected_min_sections:
        raise ValueError(
            f"Parsed only {len(sections)} sections for {act_id}; expected at least {expected_min_sections}."
        )
    if expected_max_sections is not None and len(sections) > expected_max_sections:
        raise ValueError(
            f"Parsed {len(sections)} sections for {act_id}; expected at most {expected_max_sections}."
        )
    return data


def _finalize_section(section: dict | None, sections: list[dict]) -> dict | None:
    if not section:
        return None
    text = "\n".join(section.get("lines", [])).strip()
    section.pop("lines", None)
    if text:
        section["text"] = text
        intro, clauses = _extract_clause_tree(text)
        if intro:
            section["intro"] = intro
        if clauses:
            section["clauses"] = clauses
    if not section.get("subheading"):
        section.pop("subheading", None)
    if not section.get("chapter"):
        section.pop("chapter", None)
    sections.append(section)
    return None


def _split_heading_and_inline_text(raw: str) -> tuple[str, str | None]:
    if not raw:
        return "", None
    parts = HEADING_SPLIT_RE.split(raw, maxsplit=1)
    if len(parts) == 2:
        heading, remainder = parts
        return normalize_whitespace(heading), remainder.strip()
    return normalize_whitespace(raw), None


def _looks_like_topic(line: str) -> bool:
    if len(line) > 120:
        return False
    if TOPIC_RE.match(line) and not line.endswith('.'):
        return True
    if line.lower().startswith("of "):
        return True
    return False


def normalize_whitespace(text: str) -> str:
    return re.sub(r"\s+", " ", text).strip()


def _ensure_section_newlines(text: str) -> str:
    pattern = re.compile(r"(?<=\.)\s+(?=(\d+[A-Z]?\.)\s)")
    return pattern.sub("\n", text)


def _section_sort_value(label: str) -> float:
    match = re.match(r"(\d+)([A-Z]?)", label)
    if not match:
        return 0.0
    base = int(match.group(1))
    letter = match.group(2)
    if not letter:
        return float(base)
    offset = (ord(letter.upper()) - ord("A") + 1) / 100.0
    return base + offset


def _extract_clause_tree(text: str) -> tuple[str, list[dict]]:
    intro_parts: list[str] = []
    clauses: list[dict] = []
    stack: list[dict] = []

    for raw_line in text.splitlines():
        stripped = raw_line.strip()
        if not stripped:
            _append_line(stack, intro_parts, "")
            continue
        clause_match = _match_clause(stripped)
        if clause_match:
            clause_type, label, remainder = clause_match
            level = CLAUSE_LEVELS.get(clause_type, 1)
            if not stack and level > 1:
                level = 1
            while stack and stack[-1]["level"] >= level:
                stack.pop()
            node = {
                "type": clause_type,
                "label": label,
                "text_parts": [remainder] if remainder else [],
                "children": [],
            }
            if stack:
                stack[-1]["node"].setdefault("children", []).append(node)
            else:
                clauses.append(node)
            stack.append({"level": level, "node": node})
            continue
        _append_line(stack, intro_parts, stripped)

    intro_text = _collapse_text(intro_parts)
    for node in clauses:
        _finalize_clause_node(node)
    return intro_text, clauses


def _append_line(stack: list[dict], intro_parts: list[str], line: str) -> None:
    target = stack[-1]["node"].setdefault("text_parts", []) if stack else intro_parts
    target.append(line)


def _match_clause(line: str) -> tuple[str, str, str] | None:
    for clause_type, pattern in CLAUSE_PATTERNS:
        match = pattern.match(line)
        if not match:
            continue
        label = match.group(1)
        remainder = match.group(2).strip()
        if clause_type == "roman":
            label = label.lower()
        return clause_type, label, remainder
    return None


def _collapse_text(parts: list[str]) -> str:
    if not parts:
        return ""
    return "\n".join(parts).strip()


def _finalize_clause_node(node: dict) -> None:
    text = _collapse_text(node.get("text_parts", []))
    if text:
        node["text"] = text
    node.pop("text_parts", None)
    children = node.get("children", [])
    for child in children:
        _finalize_clause_node(child)
    if not children:
        node.pop("children", None)


def process_act(config: ActConfig, *, dry_run: bool) -> None:
    if not config.source.exists():
        raise FileNotFoundError(f"Source file not found: {config.source}")
    text = config.source.read_text(encoding="utf-8")
    data = parse_statute_text(
        text,
        act_id=config.act_id,
        language=config.language,
        expected_min_sections=config.expected_min_sections,
        expected_max_sections=config.expected_max_sections,
        start_pattern=config.start_pattern,
        skip_start_trigger=config.skip_start_trigger,
    )
    if dry_run:
        print(f"Parsed {len(data['sections'])} sections for {config.act_id} (dry run)")
        return
    config.target.parent.mkdir(parents=True, exist_ok=True)
    config.target.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"Wrote {config.target} ({len(data['sections'])} sections)")


def collect_configs(filter_term: str | None) -> list[ActConfig]:
    if not filter_term:
        return ACTS
    needle = filter_term.lower()
    return [cfg for cfg in ACTS if needle in cfg.act_id.lower() or needle in cfg.source.name.lower()]


def main() -> None:
    parser = argparse.ArgumentParser(description="Parse statute text files into structured JSON")
    parser.add_argument("--act", help="Substring filter for act_id or filename")
    parser.add_argument("--dry-run", action="store_true", help="Report stats without writing JSON")
    args = parser.parse_args()

    configs = collect_configs(args.act)
    if not configs:
        raise SystemExit("No acts matched the provided filter.")
    for cfg in configs:
        process_act(cfg, dry_run=args.dry_run)


if __name__ == "__main__":
    main()
