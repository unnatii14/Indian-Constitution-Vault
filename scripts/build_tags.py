"""Generate taxonomy tags from extracted article references."""
from __future__ import annotations

import argparse
import json
from collections import defaultdict
from datetime import datetime, timezone
from pathlib import Path

import yaml

REPO_ROOT = Path(__file__).resolve().parents[1]
STRUCTURED_DIR = REPO_ROOT / "data" / "structured"
CATALOG_PATH = REPO_ROOT / "data" / "catalog" / "tags.yaml"


def collect_files(act_filter: str | None) -> list[Path]:
    files = sorted(STRUCTURED_DIR.glob("*.json"))
    if act_filter:
        needle = act_filter.lower()
        files = [path for path in files if needle in path.stem.lower()]
    return files


def group_references(references: list[dict]) -> dict[str, list[str]]:
    grouped: dict[str, set[str]] = defaultdict(set)
    for ref in references or []:
        ref_type = ref.get("type")
        target = ref.get("target")
        if not ref_type or not target:
            continue
        grouped[ref_type].add(str(target))
    return {ref_type: sorted(values) for ref_type, values in grouped.items()}


def build_catalog(files: list[Path]) -> tuple[dict, int, int]:
    articles_block: list[dict] = []
    target_index: dict[str, dict[str, set[str]]] = defaultdict(lambda: defaultdict(set))
    files_used: list[str] = []

    for path in files:
        data = json.loads(path.read_text(encoding="utf-8"))
        files_used.append(str(path.relative_to(REPO_ROOT)))
        for article in data.get("articles", []):
            article_number = str(article.get("article_number")) if article.get("article_number") else None
            if not article_number:
                continue
            references = article.get("references") or []
            grouped = group_references(references)
            if not grouped:
                continue
            articles_block.append({
                "article_number": article_number,
                "references": grouped,
            })
            for ref_type, targets in grouped.items():
                for target in targets:
                    target_index[ref_type][target].add(article_number)

    normalized_targets: dict[str, dict[str, list[str]]] = {}
    for ref_type, bucket in target_index.items():
        normalized_targets[ref_type] = {
            target: sorted(article_numbers)
            for target, article_numbers in bucket.items()
        }

    payload = {
        "generated_at": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        "sources": files_used,
        "articles": sorted(articles_block, key=lambda entry: int(entry["article_number"].rstrip("ABCDEFGHIJKLMNOPQRSTUVWXYZ") or 0)),
        "targets": normalized_targets,
    }

    return payload, len(articles_block), sum(len(bucket) for bucket in normalized_targets.values())


def write_catalog(payload: dict) -> None:
    CATALOG_PATH.parent.mkdir(parents=True, exist_ok=True)
    with CATALOG_PATH.open("w", encoding="utf-8") as handle:
        yaml.safe_dump(payload, handle, sort_keys=False, allow_unicode=False)


def main() -> None:
    parser = argparse.ArgumentParser(description="Compile data/catalog/tags.yaml from structured references.")
    parser.add_argument("--act", help="Optional substring filter for structured files.")
    parser.add_argument("--dry-run", action="store_true", help="Show stats without writing the YAML file.")
    args = parser.parse_args()

    files = collect_files(args.act)
    if not files:
        raise SystemExit("No structured files matched the provided filters.")

    payload, articles_with_tags, target_groups = build_catalog(files)
    if not args.dry_run:
        write_catalog(payload)

    print(
        "Tag catalog ready." + (" (dry run)" if args.dry_run else ""),
        f"Articles with references: {articles_with_tags}; target groups: {target_groups}.",
    )


if __name__ == "__main__":
    main()
