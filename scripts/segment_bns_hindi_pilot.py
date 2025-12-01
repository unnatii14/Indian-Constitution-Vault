"""Align Hindi BNS sections with their English counterparts."""
from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Iterable

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_HI_TEXT = ROOT / "data/processed/pdf/bns_2023_hi.txt"
DEFAULT_EN_JSON = ROOT / "data/structured/bns_en.json"
DEFAULT_OUT = ROOT / "data/structured/bns_bilingual.jsonl"
# Match section numerals even if stray whitespace/newlines split the marker.
SECTION_PATTERN = re.compile(
    "(?m)^\\s*(\\d+)\\s*(?:[\\.\\)]\\s*|(?=\\n\\s*(?:[\\(\\),;:\\-\\]]|[\\u0900-\\u097F\\u0964])))"
)
SECTION_PATTERN_PARENS = re.compile("(?m)^\\s*(\\d{2,3})\\s*(?=\\(1\\))")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Generate Hindi↔English section alignments for the BNS."  # noqa: RUF100
    )
    parser.add_argument(
        "--hi-text",
        type=Path,
        default=DEFAULT_HI_TEXT,
        help="Path to the extracted Hindi text file.",
    )
    parser.add_argument(
        "--en-json",
        type=Path,
        default=DEFAULT_EN_JSON,
        help="Path to the structured English JSON file.",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=DEFAULT_OUT,
        help="Destination JSONL file for bilingual alignments.",
    )
    parser.add_argument(
        "--max-section",
        type=int,
        default=None,
        help="Optional upper bound on section numbers to include.",
    )
    parser.add_argument(
        "--act-id",
        default="BNS-2023",
        help="Identifier written to the output records.",
    )
    parser.add_argument(
        "--use-detected-numbers",
        action="store_true",
        help="Use the numeric label in the Hindi text instead of sequential numbering.",
    )
    return parser.parse_args()


def _extract_leading_digits(value: str) -> str | None:
    if not value:
        return None
    match = re.match(r"^(\d+)", value.strip())
    return match.group(1) if match else None


def load_english_sections(en_json: Path, max_section: int | None) -> dict[str, dict]:
    data = json.loads(en_json.read_text(encoding="utf-8"))
    ordered: dict[str, dict] = {}
    for section in data.get("sections", []):
        section_number = _extract_leading_digits(section.get("section_number", ""))
        if not section_number:
            continue
        if max_section is not None and int(section_number) > max_section:
            continue
        if section_number in ordered:
            continue  # Skip duplicates introduced by footnotes or marginal notes.
        ordered[section_number] = section
    return ordered


def split_hindi_sections(
    hi_text: Path,
    max_section: int | None,
    use_detected_numbers: bool,
) -> dict[str, str]:
    text = hi_text.read_text(encoding="utf-8")
    matches = list(SECTION_PATTERN.finditer(text))
    if use_detected_numbers:
        merged = {match.start(): match for match in matches}
        for extra in SECTION_PATTERN_PARENS.finditer(text):
            merged.setdefault(extra.start(), extra)
        matches = [merged[index] for index in sorted(merged)]
    sections: dict[str, str] = {}
    seq_number = 1
    for idx, match in enumerate(matches):
        start = match.start()
        end = matches[idx + 1].start() if idx + 1 < len(matches) else len(text)
        if use_detected_numbers:
            key_int = int(match.group(1))
            if max_section is not None and key_int > max_section:
                continue
            key = str(key_int)
            if key in sections:
                continue
        else:
            if max_section is not None and seq_number > max_section:
                break
            key = str(seq_number)
            seq_number += 1
        sections[key] = text[start:end].strip()
    return sections


def _format_entries(
    english_sections: dict[str, dict],
    hindi_sections: dict[str, str],
    act_id: str,
    hi_source: Path,
) -> tuple[list[str], list[str]]:
    missing: list[str] = []
    lines: list[str] = []
    for number in _as_ints(english_sections.keys()):
        key = str(number)
        hindi_text = hindi_sections.get(key)
        if not hindi_text:
            missing.append(key)
            continue
        section = english_sections[key]
        entry = {
            "act_id": act_id,
            "section_number": key,
            "heading_en": section.get("heading", ""),
            "text_en": section.get("text", ""),
            "text_hi": hindi_text,
            "source_hi": str(hi_source),
        }
        lines.append(json.dumps(entry, ensure_ascii=False))
    return lines, missing


def _as_ints(values: Iterable[str]) -> list[int]:
    return sorted(int(value) for value in values)


def write_bilingual(args: argparse.Namespace) -> None:
    english = load_english_sections(args.en_json, args.max_section)
    hindi = split_hindi_sections(args.hi_text, args.max_section, args.use_detected_numbers)
    lines, missing = _format_entries(english, hindi, args.act_id, args.hi_text)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(
        f"Wrote {len(lines)} aligned sections to {args.output}.",
        f"Missing Hindi sections: {', '.join(missing) if missing else 'None.'}",
    )


def main() -> None:
    args = parse_args()
    write_bilingual(args)


if __name__ == "__main__":
    main()