"""Normalize structured legal texts (whitespace, hyphenation, artifacts)."""
from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Iterable

REPO_ROOT = Path(__file__).resolve().parents[1]
STRUCTURED_DIR = REPO_ROOT / "data" / "structured"
LOG_PATH = REPO_ROOT / "data" / "logs" / "normalize_log.csv"

HYPHENATED_BREAK_RE = re.compile(r"(?<=\w)-\n(?=[a-z])")
INLINE_SPACE_RE = re.compile(r"[ \t\u00A0]+")
SPACE_BEFORE_PUNCT_RE = re.compile(r" (?=[,.;:!?])")
PAGE_NUMBER_RE = re.compile(r"^\d{1,3}$")


def normalize_text_block(text: str) -> str:
    """Apply whitespace + hyphen normalization while respecting paragraphs."""
    if not text:
        return text

    normalized = text.replace("\r\n", "\n").replace("\r", "\n")
    normalized = HYPHENATED_BREAK_RE.sub("", normalized)

    lines = [
        _normalize_line(line)
        for line in normalized.split("\n")
    ]

    paragraphs: list[str] = []
    buffer: list[str] = []
    for line in lines:
        if PAGE_NUMBER_RE.fullmatch(line):
            line = ""
        if not line:
            if buffer:
                paragraphs.append(" ".join(buffer))
                buffer = []
            continue
        buffer.append(line)
    if buffer:
        paragraphs.append(" ".join(buffer))

    result = "\n\n".join(paragraphs).strip()
    return result or ""


def _normalize_line(line: str) -> str:
    line = INLINE_SPACE_RE.sub(" ", line)
    line = SPACE_BEFORE_PUNCT_RE.sub("", line)
    line = line.replace(" ,", ",").replace(" .", ".").replace(" ;", ";").replace(" :", ":")
    return line.strip()


def normalize_article(article: dict) -> int:
    changed_fields = 0

    for field in ("heading", "text", "intro"):
        changed_fields += _normalize_field(article, field)

    if part := article.get("part"):
        changed_fields += _normalize_field(part, "title")

    if clauses := article.get("clauses"):
        for clause in clauses:
            changed_fields += _normalize_clause(clause)

    if amendments := article.get("amendments"):
        for amendment in amendments:
            changed_fields += _normalize_field(amendment, "note")

    return changed_fields


def _normalize_clause(clause: dict) -> int:
    changed = _normalize_field(clause, "text")
    for child in clause.get("children", []) or []:
        changed += _normalize_clause(child)
    return changed


def _normalize_field(container: dict, key: str) -> int:
    value = container.get(key)
    if not isinstance(value, str) or not value.strip():
        return 0
    normalized = normalize_text_block(value)
    if normalized == value:
        return 0
    container[key] = normalized
    return 1


def normalize_document_notes(notes: Iterable[dict]) -> int:
    return sum(_normalize_field(note, "note") for note in notes)


def normalize_file(path: Path, *, dry_run: bool) -> tuple[int, int, bool]:
    data = json.loads(path.read_text(encoding="utf-8"))
    article_changes = 0
    for article in data.get("articles", []):
        if normalize_article(article):
            article_changes += 1

    doc_note_changes = normalize_document_notes(data.get("document_notes", []))
    changed = (article_changes > 0) or (doc_note_changes > 0)

    if changed and not dry_run:
        path.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")

    return article_changes, doc_note_changes, changed


def ensure_log_header() -> None:
    if LOG_PATH.exists():
        return
    LOG_PATH.parent.mkdir(parents=True, exist_ok=True)
    LOG_PATH.write_text("file,articles_changed,doc_notes_changed\n", encoding="utf-8")


def append_log(file_path: Path, articles_changed: int, doc_notes_changed: int) -> None:
    ensure_log_header()
    with LOG_PATH.open("a", encoding="utf-8") as handle:
        handle.write(
            f"{file_path.relative_to(REPO_ROOT)},{articles_changed},{doc_notes_changed}\n"
        )


def collect_files(act_filter: str | None) -> list[Path]:
    files = sorted(STRUCTURED_DIR.glob("*.json"))
    if act_filter:
        needle = act_filter.lower()
        files = [path for path in files if needle in path.stem.lower()]
    return files


def main() -> None:
    parser = argparse.ArgumentParser(description="Normalize structured legal text files.")
    parser.add_argument("--act", help="Optional act identifier (substring filter).")
    parser.add_argument("--dry-run", action="store_true", help="Report changes without writing files.")
    args = parser.parse_args()

    files = collect_files(args.act)
    total_articles = 0
    total_doc_notes = 0

    for path in files:
        articles_changed, doc_notes_changed, mutated = normalize_file(path, dry_run=args.dry_run)
        if mutated:
            total_articles += articles_changed
            total_doc_notes += doc_notes_changed
            if not args.dry_run:
                append_log(path, articles_changed, doc_notes_changed)

    print(
        "Normalization complete."
        f" Articles touched: {total_articles}; document notes touched: {total_doc_notes}."
        + (" (dry run)" if args.dry_run else "")
    )


if __name__ == "__main__":
    main()
