"""Simple PDF→text extraction utility using PyPDF2."""
from __future__ import annotations

import argparse
from pathlib import Path

from PyPDF2 import PdfReader


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("input", type=Path, help="Path to the source PDF file.")
    parser.add_argument(
        "output",
        type=Path,
        nargs="?",
        help="Destination text file. Defaults to the PDF name with .txt extension under data/processed/pdf.",
    )
    return parser.parse_args()


def extract_pdf_text(pdf_path: Path) -> str:
    reader = PdfReader(str(pdf_path))
    parts: list[str] = []
    for page in reader.pages:
        text = page.extract_text() or ""
        parts.append(text.strip() + "\n")
    return "".join(parts)


def main() -> None:
    args = parse_args()
    output = args.output
    if output is None:
        default_dir = Path("data/processed/pdf")
        default_dir.mkdir(parents=True, exist_ok=True)
        output = default_dir / (args.input.stem + "_pypdf.txt")
    text = extract_pdf_text(args.input)
    output.write_text(text, encoding="utf-8")
    print(f"Wrote {output} ({len(text)} characters).")


if __name__ == "__main__":
    main()
