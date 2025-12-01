# Indian Law App — Master Plan

## Vision & Success Criteria
- **North Star:** Deliver a trustworthy bilingual legal companion (Constitution + 2023 criminal codes) with offline-first Flutter UI, powerful search, and AI-assisted explanations that remain informational-only.
- **Definition of Done:** Verified structured datasets, public API + documentation, Flutter app on Play Store/TestFlight, and automated refresh pipeline with GitHub CI badges.
- **Success Metrics:** <1% parsing drift vs official texts, 100% section coverage with Hindi + English, p95 search latency <300 ms, and zero unresolved P1 QA issues before release.

## Guiding Principles
- **Official Sources First:** Every artifact traces back to a cited PDF/HTML with checksum + provenance metadata.
- **Single Source of Truth:** Structured JSON lives in `data/structured/`; backend and mobile layers consume generated bundles, never ad-hoc copies.
- **Ethical Guardrails:** Prominent “Not legal advice” disclaimers, transparent AI usage notes, and manual review checkpoints for summaries.
- **Automation & Backups:** Any manual step must be scripted and committed; GitHub is the canonical remote with protected `main` branch and release tags.

## Core Workstreams
1. **Data Foundation** — Collect PDFs, extract clean text, parse into canonical JSON, align Hindi/English, and maintain QA trackers.
2. **Knowledge Services** — FastAPI backend with `ActRegistry`, search endpoints, analytics hooks, and auth-ready architecture.
3. **Experience Layer** — Flutter app (Riverpod + GoRouter) covering search, bookmarks, FIR helpers, glossary, and AI simplifier workflows.
4. **AI Assistance** — Curated prompts, summary cache, explanation snippets, hallucination detection, and opt-in telemetry for improvement.
5. **Quality & Compliance** — Automated tests, schema validators, content moderation, accessibility, and legal disclaimers baked into every surface.

## Phase Plan & Milestones
| Phase | Focus | Key Deliverables | Exit Criteria |
| --- | --- | --- | --- |
| **0. Repo Hardening (Week 1)** | Cleanup, dependency lock, GitHub workflows | Root `README`, `LICENSE`, `.gitignore`, lint + unit test GitHub Actions, environment setup docs | `main` passes CI; repo mirrors remote backup |
| **1. Data Corpus (Weeks 2–4)** | Extraction + parsing | Automated download/extract scripts, structured JSON for Constitution + BNS/BNSS/BSA, QA diff reports, bilingual JSONL files | 100% section count parity, QA sign-off |
| **2. Backend API (Weeks 5–6)** | Service + search | `backend/app` with loaders, `/acts`, `/sections`, `/search`, rate limiting hook, OpenAPI docs, containerized deployment | Deployed staging endpoint + smoke tests |
| **3. Flutter App (Weeks 7–9)** | UX + offline cache | Modular feature folders, state management, offline bundles, theming, analytics toggles, release pipeline | Beta build shared internally + crash-free sessions |
| **4. Launch & Automation (Weeks 10–11)** | Distribution + ops | Play Store assets, release tags, refresh cron (GitHub Actions), monitoring dashboards, incident SOP | Public release + post-launch checklist complete |

## Dependencies & Risks
- **Data Quality:** OCR variability or missing Hindi sources → mitigate with manual QA queue and fallback sourcing agreements.
- **Model Costs:** AI summaries must stay within monthly budget; add caching + tiered prompts.
- **Compliance:** Keep watchlist of legal updates (Gazette notifications) to trigger rapid dataset refresh.
- **Resourcing:** If Flutter bandwidth is limited, ship API + data portal first and stagger mobile release by one phase.

## Immediate Next Actions (Dec 2025)
1. Finalize repo cleanup (delete legacy tests, obsolete docs) ✅.
2. Add root `README` + GitHub readiness checklist (CI, branch model, release tags).
3. Finish `ActRegistry` test data load and expose `/acts` endpoints.
4. Lock sprint backlog for Phase 0 tasks and create GitHub Projects board.

## Tracking
- Use GitHub Projects (Kanban) with swimlanes per workstream.
- Tag issues with `phase:X` and `area:data|backend|flutter|ai|qa`.
- Weekly review: update burndown, highlight blockers, and adjust scope.
