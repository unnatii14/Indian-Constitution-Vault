"""Extract text from PDFs or HTML sources into data/processed."""
from __future__ import annotations

import argparse
import logging
from pathlib import Path
from typing import Iterable

from bs4 import BeautifulSoup
from pdfminer.high_level import extract_text

RAW_DIR = Path("data/raw")
PROCESSED_DIR = Path("data/processed")


def list_sources(pattern: str | None = None) -> Iterable[Path]:
    base = RAW_DIR
    if pattern:
        yield from base.glob(pattern)
    else:
        yield from base.rglob("*")


def extract_pdf(pdf_path: Path, out_path: Path) -> None:
    logging.info("Extracting PDF %s", pdf_path)
    text = extract_text(str(pdf_path))
    out_path.write_text(text, encoding="utf-8")


def extract_html(html_path: Path, out_path: Path) -> None:
    logging.info("Extracting HTML %s", html_path)
    soup = BeautifulSoup(html_path.read_text(encoding="utf-8", errors="ignore"), "html.parser")
    text = soup.get_text("\n")
    out_path.write_text(text, encoding="utf-8")


def process(pattern: str) -> None:
    PROCESSED_DIR.mkdir(parents=True, exist_ok=True)
    for source in list_sources(pattern):
        if source.is_dir():
            continue
        rel = source.relative_to(RAW_DIR)
        out_path = PROCESSED_DIR / rel.with_suffix(".txt")
        out_path.parent.mkdir(parents=True, exist_ok=True)
        if source.suffix.lower() == ".pdf":
            extract_pdf(source, out_path)
        elif source.suffix.lower() in {".html", ".htm"}:
            extract_html(source, out_path)
        else:
            logging.info("Skipping unsupported file %s", source)


def main() -> None:
    parser = argparse.ArgumentParser(description="Extract text from raw sources")
    parser.add_argument("pattern", help="Glob relative to data/raw, e.g. 'pdf/constitution_of_india.pdf'")
    args = parser.parse_args()
    logging.basicConfig(level=logging.INFO, format="%(message)s")
    process(args.pattern)


if __name__ == "__main__":
    main()
