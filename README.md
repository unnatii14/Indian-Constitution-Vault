# Indian Law App

A bilingual legal companion for India that delivers the Constitution and the 2023 criminal codes (BNS, BNSS, BSA) with structured data, search-ready APIs, and a Flutter client.

## Repository Layout
- `backend/` — FastAPI service, loaders, and API code.
- `data/` — Source PDFs, processed text, structured JSON/JSONL, QA artifacts.
- `docs/` — Project plan, research notes, architecture sketches.
- `scripts/` — CLI utilities for downloading, parsing, normalizing, and QA.
- `tesseract-data/` — OCR language packs kept under version control for reproducibility.

## Getting Started
1. **Install system deps:** Python 3.11+, Tesseract, Poppler/`pdftotext`.
2. **Create a virtual environment:** `python -m venv .venv` then `.\.venv\Scripts\Activate.ps1` (Windows) or `source .venv/bin/activate` (Unix).
3. **Install Python packages:** `pip install -r requirements.txt`.
4. **Run the backend locally:** `uvicorn backend.app.main:app --reload` (loads data from `data/structured`).
5. **Access docs:** `http://127.0.0.1:8000/docs` for the auto-generated OpenAPI UI.

## GitHub Readiness Checklist
- [ ] Configure the `origin` remote: `git remote add origin <your_repo_url>` (skip if already set).
- [ ] Create a `.venv/` entry in `.gitignore` (already provided) and keep large binaries out of Git.
- [ ] Before committing, run lint/test hooks (coming CI will guard `main`).
- [ ] Use feature branches named `feature/<scope>` and open PRs into `main`; require at least one review.
- [ ] Push regularly: `git add .`, `git commit -m "feat: <message>"`, `git push origin feature/<scope>` to keep GitHub as the canonical backup.
- [ ] Tag releases: `git tag v0.1.0 && git push origin v0.1.0` once milestones land.
- [ ] Use GitHub Issues/Projects to track tasks and link commits/PRs for traceability.

## Next Up
- Expand automated tests for `ActRegistry` and endpoint responses.
- Publish containerized backend image + deployment instructions.
- Bootstrap Flutter workspace and connect it to the REST API.
