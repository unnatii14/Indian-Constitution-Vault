# Backend API Plan

## Goals
- Provide a lightweight HTTP service that exposes the structured legal corpus we have already parsed.
- Keep dependencies minimal and reuse existing JSON/JSONL assets without introducing a database yet.
- Offer a consistent contract that the upcoming Flutter client can consume.

## Technology Choices
- **Framework:** FastAPI (already listed in `requirements.txt`).
- **Server:** Uvicorn for local/dev execution.
- **Serialization:** Pydantic models to guarantee stable schemas.
- **Data Source:** `data/structured/*` JSON + bilingual JSONL files loaded into memory on startup.

## Endpoint Surface
1. `GET /health`
   - Returns `{ "status": "ok", "acts": <count> }` to power simple readiness checks.

2. `GET /acts`
   - Lists all available acts with `act_id`, `title`, `languages` (derived from files), and `section_count`.

3. `GET /acts/{act_id}`
   - Provides metadata plus the first N section headers (to help the client prefetch summaries without pulling the entire act).

4. `GET /acts/{act_id}/sections`
   - Query params: `offset`, `limit`, optional `q` for naive substring search.
   - Response: paged list of sections containing number, heading, and preview text.

5. `GET /acts/{act_id}/sections/{section_number}`
   - Returns the full English text plus Hindi text if we have a bilingual entry.

6. *(Optional, stretch)* `GET /search?q=...`
   - Aggregates across acts. We will stub this endpoint but can implement a simple case-insensitive match over headings/text until we wire up full-text search.

## Data Loading Strategy
- On startup, scan `data/structured`:
  - `*_en.json` → canonical section order + metadata.
  - `*_bilingual.jsonl` → enrich each section with Hindi text.
- Cache results in memory (`ActRegistry`). Provide helper methods for lookups and search.
- Watcher/notifier is out of scope for now; restart service after data refreshes.

## Next Steps
1. Scaffold `backend/app` package with config, models, data loader, and FastAPI app.
2. Implement `ActRegistry` singleton that loads assets at import time (or via dependency injection inside `startup` event).
3. Expose the endpoints listed above with proper response models.
4. Add `uvicorn` run instructions to `README` once endpoints are stable.
