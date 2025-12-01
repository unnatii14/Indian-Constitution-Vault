# Data Pipeline Overview

## Week 0 Deliverables
- Minimal repository skeleton (`data/`, `scripts/`, `docs/`, `requirements.txt`).
- `data/raw/pdf/` now holds the three uploaded PDFs so downstream scripts read from a single canonical location.
- `data/catalog/source_urls.csv` trimmed to only the sources represented by those PDFs (constitution main copy, pocket diglot, unknown 202503… file).

## Directory Map
```
Constitution_app/
├── data/
│   ├── catalog/
│   │   └── source_urls.csv
│   ├── logs/
│   ├── processed/
│   ├── qa/
│   ├── raw/
│   │   ├── html/
│   │   └── pdf/
│   ├── structured/
│   └── translations/
├── docs/
│   └── DATA_README.md
├── requirements.txt
└── scripts/
```

## Execution Status & Immediate Plan
| Track | Status | Notes |
| --- | --- | --- |
| Source catalog sanity (Week 0–1) | ✅ Done | PDFs classified, `data/catalog/source_urls.csv` trimmed to the verified copies. |
| Downloader & extraction prototypes (Week 1–2) | ⚙️ In progress | `scripts/download_sample.py` + `scripts/extract_text.py` live in the backlog; extraction still relies on ad-hoc notebooks. |
| Structural parsing (Week 3) | ✅ Done | `scripts/parse_constitution.py` handles the Constitution; `scripts/parse_statutes.py` now emits `data/structured/bns_en.json`, `bnss_en.json`, and `bsa_en.json`. |
| Week 4 normalization | ✅ Done | `scripts/normalize_text.py` cleans whitespace, merged lines, page headers, and logs impact. |
| Cross-references + taxonomy (Week 4) | ✅ Done | `scripts/extract_references.py` populates `references`; `scripts/build_tags.py` emits `data/catalog/tags.yaml`. |
| Arrangement validation | ✅ Done | `scripts/validate_arrangement.py` compares parsed order vs `data/catalog/arrangement_official.txt` and logs drifts. |

**Near-term to-dos**
1. Finalize downloader/extractor automation so that future refreshes run end-to-end without manual steps.
2. Review `data/qa/reference_flags.csv`, resolve ambiguous hits, and backfill any missing structured fixes before the next publish.
3. Integrate the arrangement validator into CI (fail the build if `scripts/validate_arrangement.py` reports drifts) and add email/Slack notifications when the log records differences.

## Week 4 Tooling Snapshot
- `scripts/normalize_text.py` walks every JSON artifact in `data/structured/`, merges hyphenated breaks, collapses wrapped lines into paragraphs, trims noisy page headers, and writes the cleaned text back.
- Pass `--dry-run` to see how many articles/document notes would change without touching files; use `--act <slug>` to limit execution to specific datasets.
- Every real run appends a CSV line to `data/logs/normalize_log.csv` in the format `file,articles_changed,doc_notes_changed` so downstream QA notebooks can trace which passages were touched.
- Tests live under `tests/test_normalize_text.py`; run `python -m unittest discover -s tests -t .` before committing normalization tweaks.

- `scripts/extract_references.py` scans headings/intros/clause text for patterns like `Article 32`, `Part IV`, and `Seventh Schedule`, deduplicates matches per article, and stores normalized entries in each article’s `references` array (`type`, `target`, `snippet`, `field`).
- The extractor now treats phrases such as “this Part” (when the article metadata carries a `part.part_code`) and “this article” as explicit references so they no longer flood QA; ambiguous part flags only trigger for capitalized `Part` mentions without a following numeral.
- “Part A/B of the First Schedule” style phrases now generate schedule references (`FIRST_PART_A`, etc.) so those historic footnotes stop appearing as false positives in QA.
- Any remaining ambiguous mentions (for example, generic “that article” phrases) are recorded in `data/qa/reference_flags.csv` so reviewers can triage edge cases before publishing data.
- Usage: `python scripts/extract_references.py --dry-run` (preview counts only) or run without `--dry-run` to rewrite JSON + append to `data/logs/reference_log.csv`.

## Statute Parsing (BNS / BNSS / BSA)
- `scripts/parse_statutes.py` reads the processed PDF text for each 2023 criminal law and emits structured JSON under `data/structured/` (`bns_en.json`, `bnss_en.json`, `bsa_en.json`).
- The parser records chapter metadata, optional subheadings (“Of offences…”) and splits each section into intro text plus structured clauses so downstream tooling can reuse the same schema as the Constitution articles.
- Run `python scripts/parse_statutes.py --dry-run` to check counts or without flags to refresh all outputs; pass `--act <slug>` to regenerate a single act.

## Tag Catalog Generation
- `scripts/build_tags.py` consumes the enriched JSON, buckets per-article references by type, and writes a YAML catalog to `data/catalog/tags.yaml` containing: generation metadata, each article’s `references` map (e.g., `part: ["III"]`), and a reverse index (`targets`) listing which articles cite a given Article/Part/Schedule.
- Requires `PyYAML` (now listed in `requirements.txt`); run `python scripts/build_tags.py --dry-run` to inspect counts or omit `--dry-run` to update the YAML.
- Current catalog stats: 251 articles carry at least one reference tag; 192 unique targets exist across Article/Part/Schedule buckets.

## Arrangement Validation Workflow
- `data/catalog/arrangement_official.txt` holds the curated “Arrangement of Articles” list (one article per line). Update it manually when the official ordering changes.
- `scripts/validate_arrangement.py` compares the structured JSON to the curated list, writes the latest parsed order to `data/catalog/arrangement_snapshot.txt`, and appends run metrics to `data/logs/arrangement_validation.csv`.
- Usage: `python scripts/validate_arrangement.py --dry-run` to preview differences; omit `--dry-run` to fail the process on any missing/extra/order issues while refreshing the snapshot/log.
- Add the command to CI so any divergence between parser output and the official arrangement blocks releases.
