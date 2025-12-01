"""Normalize malformed section numerals in the OCR Hindi text."""
from __future__ import annotations

import argparse
import re
from pathlib import Path

DEVANAGARI_DIGITS = str.maketrans({
    "०": "0",
    "१": "1",
    "२": "2",
    "३": "3",
    "४": "4",
    "५": "5",
    "६": "6",
    "७": "7",
    "८": "8",
    "९": "9",
})

INSERTED_PREFIXES = (".", ")", ",", ":", "-", "—")

EMBEDDED_HEADING = re.compile(r"^(?P<title>[\w\s\u0900-\u097F।]+?)\s+(?P<number>\d{2,3})\.\s+(?P<rest>.+)")
SPILLED_SECTION = re.compile(r"(?m)^(?P<number>\d{1,3})\s*\n\s*(?=\()")
ALT_DELIMITERS = re.compile(r"^(?P<number>\d{1,3})\s*[:：\-\–]\s*")


def normalize_line(line: str) -> str:
    """Return a version of *line* whose section marker (if any) is normalized."""
    # Preserve leading whitespace so the paragraph formatting stays intact.
    stripped = line.lstrip()
    if not stripped:
        return line

    indent = line[: len(line) - len(stripped)]
    content = stripped.translate(DEVANAGARI_DIGITS)

    alt = ALT_DELIMITERS.match(content)
    if alt:
        remainder = content[alt.end():].lstrip()
        content = f"{alt.group('number')}. {remainder}".rstrip()

    # Handle lines that start with variants such as ". ()".
    content = re.sub(r"^\.\s*\(\s*\)", "1. ", content)
    content = re.sub(r"^\.\s+(?=\S)", "11. ", content)

    # Convert embedded headings like "मिथ्या दस्तावेज 335." → "335. मिथ्या दस्तावेज".
    embedded = EMBEDDED_HEADING.match(content)
    if embedded and not content[0].isdigit():
        number = embedded.group("number")
        merged_title = embedded.group("title").strip(" ।")
        rest = embedded.group("rest").strip()
        content = f"{number}. {merged_title} {rest}".strip()

    # Convert "]05" → "105." and similar patterns.
    bracket_match = re.match(r"^\]\s*(\d{1,3})(.*)$", content)
    if bracket_match:
        digits, rest = bracket_match.groups()
        number = f"1{digits}"
        rest = rest.lstrip()
        if rest and not rest.startswith(INSERTED_PREFIXES):
            rest = " " + rest
        content = f"{number}.{rest}".rstrip()

    zero_match = re.match(r"^0([0-9]*)(.*)$", content)
    if zero_match and zero_match.group(2).startswith("."):
        tail_digits, remainder = zero_match.groups()
        token = "0" + tail_digits
        number = "1" + token
        remainder = remainder[1:].lstrip()
        content = f"{number}. {remainder}".rstrip()

    return indent + content


def normalize_text(text: str) -> str:
    had_trailing_newline = text.endswith("\n")
    text = SPILLED_SECTION.sub(lambda match: f"{match.group('number')}. ", text)
    lines = text.splitlines()
    normalized = [normalize_line(line) for line in lines]
    return "\n".join(normalized) + ("\n" if had_trailing_newline else "")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "input",
        type=Path,
        default=Path("data/processed/pdf/bns_2023_hi_ocr.txt"),
        nargs="?",
        help="Path to the OCR-derived Hindi text file.",
    )
    args = parser.parse_args()
    original = args.input.read_text(encoding="utf-8")
    updated = normalize_text(original)
    if updated == original:
        print("No changes made; file is already normalized.")
        return
    args.input.write_text(updated, encoding="utf-8")
    print(f"Normalized section markers in {args.input}.")


if __name__ == "__main__":
    main()
