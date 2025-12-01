# Week 5 — Hindi/English Alignment Kickoff

## Objectives
- Pair every English section/Article ID with the official Hindi wording.
- Track alignment coverage and blockers on a per-act basis.
- Produce machine-readable bilingual payloads for downstream QA and packaging.

## Data Sources
- Text extractions stored under `data/processed/pdf`. Hindi PDFs already available for BNS/BNSS/BSA; Constitution diglot and other legacy Hindi sources still pending.
- Structured English JSON under `data/structured/*.json` provides canonical IDs, headings, and clause hierarchy.
- Alignment tracker: `data/qa/language_alignment_status.csv` (new).

## Pipeline Sketch
1. **Segment Hindi text** using the same section numbering found in the English structured JSON (regex on `धारा` / numerals, or chapter headings).
2. **Normalize text pairs** (trim whitespace, convert Devanagari digits to ASCII, preserve lists).
3. **Emit bilingual JSON/JSONL** per section: `{ "act_id", "section", "lang": "en"|"hi", "text": ... }`.
4. **QA hooks**: diff heading tokens, length ratios, and flag missing/misaligned sections.

## Immediate Next Actions
- Replace the corrupted BNS Hindi extraction (section markers disappear after s.72); try Poppler `pdftotext` or OCR as needed.
- Re-run `scripts/segment_bns_hindi_pilot.py` (now general) to refresh `data/structured/bns_bilingual.jsonl` once full Hindi spans exist, then fan out to BNSS/BSA.
- Backfill Constitution Hindi text via the existing diglot PDF (needs clean extraction step before parsing).
- Document blockers (e.g., Evidence Act PDF redirect, Hindi OCR) in the tracker until resolved.
