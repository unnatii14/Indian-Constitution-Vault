"""Validate parsed articles against the official arrangement list."""
from __future__ import annotations

import argparse
import csv
from pathlib import Path
from typing import Iterable, Sequence

REPO_ROOT = Path(__file__).resolve().parents[1]
STRUCTURED_PATH = REPO_ROOT / "data" / "structured" / "constitution_en.json"
OFFICIAL_PATH = REPO_ROOT / "data" / "catalog" / "arrangement_official.txt"
SNAPSHOT_PATH = REPO_ROOT / "data" / "catalog" / "arrangement_snapshot.txt"
LOG_PATH = REPO_ROOT / "data" / "logs" / "arrangement_validation.csv"


def load_official_list(path: Path) -> list[str]:
    if not path.exists():
        raise FileNotFoundError(f"Official arrangement list not found: {path}")
    entries: list[str] = []
    for raw in path.read_text(encoding="utf-8").splitlines():
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        entries.append(line)
    if not entries:
        raise ValueError(f"Official arrangement list is empty: {path}")
    return entries


def load_parsed_articles(path: Path) -> list[str]:
    import json

    data = json.loads(path.read_text(encoding="utf-8"))
    articles: list[str] = []
    for article in data.get("articles", []):
        number = article.get("article_number")
        if number:
            articles.append(str(number))
    if not articles:
        raise ValueError(f"No articles found in structured file: {path}")
    return articles


def compare_arrangements(official: Sequence[str], parsed: Sequence[str]) -> dict:
    official_set = set(official)
    parsed_set = set(parsed)

    missing = [art for art in official if art not in parsed_set]
    extra = [art for art in parsed if art not in official_set]

    common_official = [art for art in official if art in parsed_set]
    common_parsed = [art for art in parsed if art in official_set]

    order_mismatches: list[dict] = []
    for idx, (expected, found) in enumerate(zip(common_official, common_parsed)):
        if expected != found:
            order_mismatches.append({
                "position": idx,
                "expected": expected,
                "found": found,
            })

    if len(common_official) != len(common_parsed):
        order_mismatches.append({
            "position": min(len(common_official), len(common_parsed)),
            "expected": common_official[min(len(common_official) - 1, len(common_parsed) - 1)]
            if common_official and common_parsed else "",
            "found": "<length mismatch>",
        })

    return {
        "missing": missing,
        "extra": extra,
        "order_mismatches": order_mismatches,
    }


def write_snapshot(parsed: Iterable[str], path: Path = SNAPSHOT_PATH) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(parsed), encoding="utf-8")


def ensure_log_header() -> None:
    if LOG_PATH.exists():
        return
    LOG_PATH.parent.mkdir(parents=True, exist_ok=True)
    LOG_PATH.write_text(
        "structured_file,official_total,parsed_total,missing,extra,order_mismatches\n",
        encoding="utf-8",
    )


def append_log(structured: Path, official_count: int, parsed_count: int, results: dict) -> None:
    ensure_log_header()
    with LOG_PATH.open("a", newline="", encoding="utf-8") as handle:
        writer = csv.writer(handle)
        writer.writerow([
            structured.relative_to(REPO_ROOT),
            official_count,
            parsed_count,
            len(results["missing"]),
            len(results["extra"]),
            len(results["order_mismatches"]),
        ])


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Validate article arrangement against the official ordering list."
    )
    parser.add_argument(
        "--structured",
        default=str(STRUCTURED_PATH),
        help="Path to the structured constitution JSON file.",
    )
    parser.add_argument(
        "--official",
        default=str(OFFICIAL_PATH),
        help="Path to the curated arrangement list (one article number per line).",
    )
    parser.add_argument(
        "--snapshot",
        default=str(SNAPSHOT_PATH),
        help="Path to write the latest parsed arrangement snapshot.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Compute differences without writing snapshot or logs.",
    )
    args = parser.parse_args()

    structured_path = Path(args.structured)
    official_path = Path(args.official)
    snapshot_path = Path(args.snapshot)

    official_list = load_official_list(official_path)
    parsed_list = load_parsed_articles(structured_path)
    results = compare_arrangements(official_list, parsed_list)

    missing_count = len(results["missing"])
    extra_count = len(results["extra"])
    order_count = len(results["order_mismatches"])

    print("Arrangement check summary:")
    print(f"  Official entries : {len(official_list)}")
    print(f"  Parsed entries   : {len(parsed_list)}")
    print(f"  Missing          : {missing_count}")
    print(f"  Extra            : {extra_count}")
    print(f"  Order mismatches : {order_count}")

    def _preview(items: list[str], label: str) -> None:
        if items:
            snippet = ", ".join(items[:5])
            more = " ..." if len(items) > 5 else ""
            print(f"    {label}: {snippet}{more}")

    _preview(results["missing"], "Missing")
    _preview(results["extra"], "Extra")
    if results["order_mismatches"]:
        mismatch = results["order_mismatches"][0]
        print(
            "    Order mismatch sample: "
            f"expected {mismatch['expected']} but found {mismatch['found']} at position {mismatch['position']}"
        )

    if not args.dry_run:
        write_snapshot(parsed_list, snapshot_path)
        append_log(structured_path, len(official_list), len(parsed_list), results)

    if missing_count or extra_count or order_count:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
