from __future__ import annotations
from pathlib import Path
from bs4 import BeautifulSoup

def list_pdfs(slug: str) -> None:
    path = Path(f"data/raw/html/{slug}.html")
    if not path.exists():
        print(f"missing {path}")
        return
    soup = BeautifulSoup(path.read_text(encoding="utf-8", errors="ignore"), "html.parser")
    links = []
    for tag in soup.find_all("a"):
        href = tag.get("href")
        if not href:
            continue
        if href.lower().endswith(".pdf"):
            links.append(href)
    print(slug, len(links))
    for link in links:
        print(" ", link)


def main() -> None:
    for slug in ["bns_2023", "bnss_2023", "bsa_2023"]:
        list_pdfs(slug)


if __name__ == "__main__":
    main()
