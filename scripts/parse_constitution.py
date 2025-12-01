"""Parse Constitution text into a basic structured JSON (articles + parts)."""
from __future__ import annotations

import json
import re
from pathlib import Path

# Clause parsing patterns ordered from most specific to most general
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

EXPECTED_PART_ORDER = [
    "I",
    "II",
    "III",
    "IV",
    "IVA",
    "V",
    "VI",
    "VII",
    "VIII",
    "IX",
    "IXA",
    "X",
    "XI",
    "XII",
    "XIII",
    "XIV",
    "XIVA",
    "XV",
    "XVI",
    "XVII",
    "XVIII",
    "XIX",
    "XX",
    "XXI",
    "XXII",
]
PART_ORDER_INDEX = {code: idx for idx, code in enumerate(EXPECTED_PART_ORDER)}
MIN_EXPECTED_ARTICLES = 350
MAX_EXPECTED_ARTICLES = 500
MAX_CLAUSE_DEPTH = 4

SOURCE = Path("data/processed/pdf/constitution_of_india.txt")
TARGET = Path("data/structured/constitution_en.json")

ARTICLE_RE = re.compile(r"^([0-9]+[A-Z]?)\.\s*(.*)")
PART_RE = re.compile(r"^PART\s+([IVXLC]+A?)", re.IGNORECASE)
SCHEDULE_RE = re.compile(r"^(FIRST|SECOND|THIRD|FOURTH|FIFTH|SIXTH|SEVENTH|EIGHTH|NINTH|TENTH|ELEVENTH|TWELFTH)\s+SCHEDULE", re.IGNORECASE)

FOOTNOTE_PREFIX_KINDS = {
    "subs": "substitution",
    "ins": "insertion",
    "added": "addition",
    "omitted": "omission",
    "the": "note",
    "art": "note",
    "article": "note",
    "clause": "note",
    "clauses": "note",
    "proviso": "note",
    "provisos": "note",
    "now": "note",
    "this": "note",
    "these": "note",
    "paragraph": "note",
    "section": "note",
    "words": "note",
    "explanation": "note",
}
FOOTNOTE_INDICATORS = ("amendment", "act", "w.e.f.", "ibid", "vide", "gazette")


def normalize_whitespace(text: str) -> str:
    return re.sub(r"\s+", " ", text).strip()


def parse_text(text: str, *, validate: bool = True) -> dict:
    articles: list[dict] = []
    current_article: dict | None = None
    current_part: dict | None = None
    current_schedule: str | None = None
    part_title_pending: bool = False
    document_notes: list[dict] = []
    active_footnote: dict | None = None

    for raw_line in text.splitlines():
        line = raw_line.strip()
        if not line:
            if active_footnote:
                active_footnote["text_parts"].append("")
                _finalize_footnote(active_footnote, current_article, document_notes)
                active_footnote = None
            continue

        if active_footnote:
            if _is_footnote_start(line):
                _finalize_footnote(active_footnote, current_article, document_notes)
                active_footnote = None
            elif _line_starts_new_section(line):
                _finalize_footnote(active_footnote, current_article, document_notes)
                active_footnote = None
            else:
                active_footnote["text_parts"].append(line)
                continue

        if _is_footnote_start(line):
            active_footnote = _start_footnote(line)
            continue

        line = _clean_bracket_artifacts(line)
        if not line:
            continue

        schedule_match = SCHEDULE_RE.match(line)
        if schedule_match:
            current_schedule = normalize_whitespace(line)
            current_part = None
            part_title_pending = False
            continue

        part_match = PART_RE.match(line)
        if part_match:
                remainder = line[part_match.end():].strip(" .—-–")
                if remainder:
                    # not a standalone part heading
                    pass
                else:
                    current_part = {
                        "part_code": part_match.group(1).upper(),
                        "title": "",
                    }
                    part_title_pending = True
                    continue

        if part_title_pending and current_part:
            current_part["title"] = normalize_whitespace(line)
            part_title_pending = False
            continue

        art_match = ARTICLE_RE.match(line)
        if art_match:
            if current_article:
                current_article["text"] = "\n".join(current_article["lines"]).strip()
                del current_article["lines"]
                _finalize_article(current_article)
                articles.append(current_article)
            heading = normalize_whitespace(art_match.group(2))
            current_article = {
                "article_number": art_match.group(1),
                "heading": heading,
                "part": current_part if current_part else None,
                "schedule": current_schedule,
                "lines": [],
                "amendments": [],
            }
            continue

        if current_article:
            current_article["lines"].append(line)

    if current_article:
        current_article["text"] = "\n".join(current_article["lines"]).strip()
        del current_article["lines"]
        _finalize_article(current_article)
        articles.append(current_article)

    if active_footnote:
        _finalize_footnote(active_footnote, current_article, document_notes)

    result = {
        "act_id": "CONST-1950",
        "language": "en",
        "articles": articles,
    }
    if document_notes:
        result["document_notes"] = document_notes
    if validate:
        _validate_parsed_result(result)
    return result


def _line_starts_new_section(line: str) -> bool:
    return bool(PART_RE.match(line) or SCHEDULE_RE.match(line) or ARTICLE_RE.match(line))


def _is_footnote_start(line: str) -> bool:
    if not line or not line[0].isdigit():
        return False
    idx = 0
    while idx < len(line) and line[idx].isdigit():
        idx += 1
    if idx >= len(line):
        return False
    next_char = line[idx]
    if next_char in ".[":
        return False
    rest = line[idx:].strip()
    if not rest:
        return False
    prefix = rest.split(maxsplit=1)[0].lower().rstrip(".")
    if prefix not in FOOTNOTE_PREFIX_KINDS:
        return False
    lowered = rest.lower()
    if not any(ind in lowered for ind in FOOTNOTE_INDICATORS):
        return False
    return True


def _start_footnote(line: str) -> dict:
    idx = 0
    while idx < len(line) and line[idx].isdigit():
        idx += 1
    marker = line[:idx]
    rest = line[idx:].strip()
    prefix = rest.split(maxsplit=1)[0].lower().rstrip(".") if rest else "note"
    kind = FOOTNOTE_PREFIX_KINDS.get(prefix, "note")
    return {"marker": marker, "kind": kind, "text_parts": [rest] if rest else []}


def _finalize_footnote(footnote: dict, current_article: dict | None, document_notes: list[dict]) -> None:
    text = normalize_whitespace(" ".join(filter(None, footnote["text_parts"])))
    entry = {"marker": footnote["marker"], "kind": footnote["kind"], "note": text}
    if current_article is not None:
        current_article.setdefault("amendments", []).append(entry)
    else:
        document_notes.append(entry)


def _finalize_article(article: dict) -> None:
    intro_text, clauses = _extract_clause_tree(article["text"])
    if intro_text:
        article["intro"] = intro_text
    if clauses:
        article["clauses"] = clauses
    if not article.get("amendments"):
        article.pop("amendments", None)


def _extract_clause_tree(text: str) -> tuple[str, list[dict]]:
    intro_parts: list[str] = []
    clauses: list[dict] = []
    stack: list[dict] = []

    for raw_line in text.splitlines():
        stripped = raw_line.strip()
        if not stripped:
            _append_line(stack, intro_parts, "")
            continue

        prepared = _strip_inline_amendment_marker(stripped)
        prepared = _clean_bracket_artifacts(prepared)
        clause_match = _match_clause(prepared)
        if clause_match:
            clause_type, label, remainder = clause_match
            level = CLAUSE_LEVELS.get(clause_type, 1)
            if not stack and level > 1:
                level = 1
            elif stack:
                top_level = stack[-1]["level"]
                top_type = stack[-1]["node"]["type"]
                if top_type == clause_type and top_level < level:
                    level = top_level

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

        _append_line(stack, intro_parts, prepared)

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


def _strip_inline_amendment_marker(line: str) -> str:
    match = re.match(r"^\d+\[(.*)", line)
    if match:
        remainder = match.group(1).strip()
        if remainder.endswith("]"):
            remainder = remainder[:-1].rstrip()
        return remainder
    return line


def _clean_bracket_artifacts(line: str) -> str:
    if not line:
        return line
    stripped = line.strip()
    if stripped == "]" or stripped == "[":
        return ""
    # remove leading closing brackets
    while line.startswith("]"):
        line = line[1:].lstrip()
    while line.startswith("[") and "]" not in line:
        line = line[1:].lstrip()
    if line.endswith("]") and "[" not in line:
        line = line[:-1].rstrip()
    if line.startswith("[") and line.endswith("]"):
        line = line[1:-1].strip()
    return line


def _collapse_text(parts: list[str]) -> str:
    if not parts:
        return ""
    # Preserve intentional blank lines while trimming outer whitespace.
    joined = "\n".join(parts)
    return joined.strip()


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


def _validate_parsed_result(data: dict) -> None:
    articles = data.get("articles", [])
    count = len(articles)
    if count < MIN_EXPECTED_ARTICLES or count > MAX_EXPECTED_ARTICLES:
        raise ValueError(f"Unexpected article count: {count}")

    last_part_index = -1
    for art in articles:
        part = art.get("part")
        part_code = part.get("part_code") if part else None
        if part_code:
            idx = PART_ORDER_INDEX.get(part_code)
            if idx is None:
                raise ValueError(f"Unknown part code '{part_code}' in article {art['article_number']}")
            if idx < last_part_index:
                raise ValueError(
                    f"Part order regression: article {art['article_number']} returned to {part_code}"
                )
            last_part_index = idx

        clauses = art.get("clauses")
        if clauses:
            depth = _max_clause_depth(clauses)
            if depth > MAX_CLAUSE_DEPTH:
                raise ValueError(
                    f"Clause depth {depth} exceeds max {MAX_CLAUSE_DEPTH} in article {art['article_number']}"
                )


def _max_clause_depth(clauses: list[dict], level: int = 1) -> int:
    depth = level
    for clause in clauses:
        children = clause.get("children") or []
        if children:
            depth = max(depth, _max_clause_depth(children, level + 1))
    return depth


def main() -> None:
    text = SOURCE.read_text(encoding="utf-8")
    data = parse_text(text)
    TARGET.parent.mkdir(parents=True, exist_ok=True)
    TARGET.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")


if __name__ == "__main__":
    main()
