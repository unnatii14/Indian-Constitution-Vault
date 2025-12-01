"""Inspect PDFs in data/raw/pdf and print metadata + first-page snippet."""
from __future__ import annotations
import json
from pathlib import Path

from PyPDF2 import PdfReader


def inspect_pdfs(base: Path) -> dict:
    report = {}
    for path in sorted(base.glob("*.pdf")):
        reader = PdfReader(str(path))
        info = reader.metadata
        first_page = reader.pages[0].extract_text() if reader.pages else ""
        report[path.name] = {
            "pages": len(reader.pages),
            "title": getattr(info, "title", None),
            "producer": getattr(info, "producer", None),
            "creator": getattr(info, "creator", None),
            "snippet": (first_page or "").replace("\n", " ")[:500],
        }
    return report


def main() -> None:
    base = Path("data/raw/pdf")
    report = inspect_pdfs(base)
    print(json.dumps(report, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
