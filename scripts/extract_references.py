"""Detect cross-references (Articles/Parts/Schedules) inside structured acts."""
from __future__ import annotations

import argparse
import csv
import json
import re
from pathlib import Path
from typing import Iterable

REPO_ROOT = Path(__file__).resolve().parents[1]
STRUCTURED_DIR = REPO_ROOT / "data" / "structured"
LOG_PATH = REPO_ROOT / "data" / "logs" / "reference_log.csv"
QA_FLAGS_PATH = REPO_ROOT / "data" / "qa" / "reference_flags.csv"

ARTICLE_RE = re.compile(r"\b(?:art(?:icle)?\.?\s+)(\d+[A-Z]?)", re.IGNORECASE)
PART_RE = re.compile(r"\bpart\s+([IVXLC]+A?)", re.IGNORECASE)
SCHEDULE_AFTER_RE = re.compile(
    r"\b(?:schedule|sch\.)\s+(first|second|third|fourth|fifth|sixth|seventh|eighth|ninth|tenth|eleventh|twelfth)",
    re.IGNORECASE,
)
SCHEDULE_BEFORE_RE = re.compile(
    r"\b(first|second|third|fourth|fifth|sixth|seventh|eighth|ninth|tenth|eleventh|twelfth)\s+(?:schedule|sch\.)",
    re.IGNORECASE,
)
SCHEDULE_SECTION_RE = re.compile(
    r"(Part\s+[A-Z](?:\s*(?:,|and|or)\s+Part\s+[A-Z])*)\s+of\s+the\s+(first|second|third|fourth|fifth|sixth|seventh|eighth|ninth|tenth|eleventh|twelfth)\s+(?:schedule|sch\.)",
    re.IGNORECASE,
)
PART_LETTER_IN_SECTION_RE = re.compile(r"Part\s+([A-Z])", re.IGNORECASE)
PART_AMBIG_RE = re.compile(r"\bPart\b(?!\s+[IVXLC]+A?)")
SCHEDULE_AMBIG_RE = re.compile(
    r"\bschedule\b(?!\s+(?:first|second|third|fourth|fifth|sixth|seventh|eighth|ninth|tenth|eleventh|twelfth))",
    re.IGNORECASE,
)
ARTICLE_AMBIG_RE = re.compile(r"\barticle\b(?!\s+\d)", re.IGNORECASE)
THIS_PART_RE = re.compile(r"\b[Tt]his\s+Part\b")
THIS_ARTICLE_RE = re.compile(r"\b[Tt]his\s+article\b", re.IGNORECASE)
ORDINAL_MAP = {
    "first": "FIRST",
    "second": "SECOND",
    "third": "THIRD",
    "fourth": "FOURTH",
    "fifth": "FIFTH",
    "sixth": "SIXTH",
    "seventh": "SEVENTH",
    "eighth": "EIGHTH",
    "ninth": "NINTH",
    "tenth": "TENTH",
    "eleventh": "ELEVENTH",
    "twelfth": "TWELFTH",
}


def extract_references_from_segment(
    text: str,
    field: str,
    *,
    article_number: str | None = None,
    part_code: str | None = None,
) -> tuple[list[dict], list[dict]]:
    """Return references + ambiguity flags detected in a text segment."""
    if not text or not text.strip():
        return [], []

    references: list[dict] = []
    flags: list[dict] = []
    reference_spans: list[tuple[int, int]] = []

    def _add_ref(ref_type: str, target: str, match: re.Match[str]) -> None:
        snippet = _build_snippet(text, match.start(), match.end())
        references.append({
            "type": ref_type,
            "target": target,
            "snippet": snippet,
            "field": field,
        })
        reference_spans.append((match.start(), match.end()))

    for match in ARTICLE_RE.finditer(text):
        _add_ref("article", match.group(1).upper(), match)
    for match in PART_RE.finditer(text):
        _add_ref("part", match.group(1).upper(), match)
    for match in SCHEDULE_AFTER_RE.finditer(text):
        word = match.group(1).lower()
        _add_ref("schedule", ORDINAL_MAP[word], match)
    for match in SCHEDULE_BEFORE_RE.finditer(text):
        word = match.group(1).lower()
        _add_ref("schedule", ORDINAL_MAP[word], match)

    for match in SCHEDULE_SECTION_RE.finditer(text):
        span_start, span_end = match.span()
        reference_spans.append((span_start, span_end))
        letters_block = match.group(1)
        schedule_word = match.group(2).lower()
        schedule_target = ORDINAL_MAP[schedule_word]
        snippet = _build_snippet(text, span_start, span_end)
        for letter in PART_LETTER_IN_SECTION_RE.findall(letters_block):
            references.append({
                "type": "schedule",
                "target": f"{schedule_target}_PART_{letter.upper()}",
                "snippet": snippet,
                "field": field,
            })

    if part_code:
        for match in THIS_PART_RE.finditer(text):
            _add_ref("part", part_code.upper(), match)

    if article_number:
        for match in THIS_ARTICLE_RE.finditer(text):
            _add_ref("article", article_number.upper(), match)

    def _flag(regex: re.Pattern[str], issue: str) -> None:
        for match in regex.finditer(text):
            if _is_span_covered(reference_spans, match.start(), match.end()):
                continue
            snippet = _build_snippet(text, match.start(), match.end())
            flags.append({
                "issue": issue,
                "context": snippet,
                "field": field,
            })

    _flag(ARTICLE_AMBIG_RE, "article_mention_without_number")
    _flag(PART_AMBIG_RE, "part_mention_without_code")
    _flag(SCHEDULE_AMBIG_RE, "schedule_mention_without_name")

    return references, flags


def _build_snippet(text: str, start: int, end: int, window: int = 60) -> str:
    snippet = text[max(0, start - window): min(len(text), end + window)]
    snippet = re.sub(r"\s+", " ", snippet).strip()
    return snippet


def _is_span_covered(spans: list[tuple[int, int]], start: int, end: int) -> bool:
    return any(not (end <= s or start >= e) for s, e in spans)


def iterate_article_segments(article: dict) -> Iterable[tuple[str, str]]:
    for key in ("heading", "intro", "text"):
        value = article.get(key)
        if isinstance(value, str) and value.strip():
            yield (key, value)

    def _walk_clauses(clauses: list[dict], prefix: str) -> Iterable[tuple[str, str]]:
        for idx, clause in enumerate(clauses):
            field = f"{prefix}clauses[{idx}]"
            text = clause.get("text")
            if isinstance(text, str) and text.strip():
                yield (field, text)
            if clause.get("children"):
                yield from _walk_clauses(clause["children"], field + ".")

    clauses = article.get("clauses")
    if isinstance(clauses, list):
        yield from _walk_clauses(clauses, "")


def ensure_csv(path: Path, header: list[str]) -> None:
    if path.exists():
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.writer(handle)
        writer.writerow(header)


def collect_files(act_filter: str | None) -> list[Path]:
    files = sorted(STRUCTURED_DIR.glob("*.json"))
    if act_filter:
        needle = act_filter.lower()
        files = [path for path in files if needle in path.stem.lower()]
    return files


def collect_article_references(article: dict) -> tuple[list[dict], list[dict]]:
    seen: set[tuple[str, str]] = set()
    references: list[dict] = []
    flags: list[dict] = []

    article_number = article.get("article_number")
    part_info = article.get("part")
    part_code = None
    if isinstance(part_info, dict):
        code = part_info.get("part_code")
        if isinstance(code, str) and code.strip():
            part_code = code.strip()

    for field, text in iterate_article_segments(article):
        seg_refs, seg_flags = extract_references_from_segment(
            text,
            field,
            article_number=article_number,
            part_code=part_code,
        )
        for ref in seg_refs:
            key = (ref["type"], ref["target"])
            if key in seen:
                continue
            seen.add(key)
            references.append(ref)
        flags.extend(seg_flags)

    return references, flags


def write_json(path: Path, data: dict) -> None:
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")


def append_log(file_path: Path, references_detected: int, qa_flags: int) -> None:
    ensure_csv(LOG_PATH, ["file", "references_detected", "qa_flags"])
    with LOG_PATH.open("a", newline="", encoding="utf-8") as handle:
        writer = csv.writer(handle)
        writer.writerow([file_path.relative_to(REPO_ROOT), references_detected, qa_flags])


def append_qa_rows(rows: list[dict]) -> None:
    if not rows:
        return
    ensure_csv(QA_FLAGS_PATH, ["article_number", "field", "issue", "context"])
    with QA_FLAGS_PATH.open("a", newline="", encoding="utf-8") as handle:
        writer = csv.writer(handle)
        for row in rows:
            writer.writerow([row["article_number"], row["field"], row["issue"], row["context"]])


def process_file(path: Path, *, dry_run: bool) -> tuple[int, int]:
    data = json.loads(path.read_text(encoding="utf-8"))
    references_detected = 0
    qa_rows: list[dict] = []
    changed = False

    for article in data.get("articles", []):
        refs, flags = collect_article_references(article)
        if refs:
            if article.get("references") != refs:
                article["references"] = refs
                changed = True
        elif article.get("references"):
            article.pop("references")
            changed = True

        references_detected += len(refs)
        for flag in flags:
            qa_rows.append({
                "article_number": article.get("article_number", ""),
                "field": flag["field"],
                "issue": flag["issue"],
                "context": flag["context"],
            })

    if changed and not dry_run:
        write_json(path, data)

    if not dry_run:
        append_log(path, references_detected, len(qa_rows))
        append_qa_rows(qa_rows)

    return references_detected, len(qa_rows)


def main() -> None:
    parser = argparse.ArgumentParser(description="Extract clause cross-references from structured acts.")
    parser.add_argument("--act", help="Optional substring filter for structured JSON filenames.")
    parser.add_argument("--dry-run", action="store_true", help="Report changes without writing files/logs.")
    args = parser.parse_args()

    files = collect_files(args.act)
    total_refs = 0
    total_flags = 0

    for path in files:
        refs, flags = process_file(path, dry_run=args.dry_run)
        total_refs += refs
        total_flags += flags

    print(
        "Reference extraction complete."
        f" References recorded: {total_refs}; QA flags: {total_flags}."
        + (" (dry run)" if args.dry_run else "")
    )


if __name__ == "__main__":
    main()
