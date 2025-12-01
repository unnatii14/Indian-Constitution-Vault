"""FastAPI application exposing the Constitution dataset."""
from __future__ import annotations

from typing import List, Optional

from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware

from .data_loader import ActRegistry, REGISTRY, SectionRecord
from .models import (
    ActDetail,
    ActSummary,
    PaginatedSections,
    SearchHit,
    SearchResponse,
    SectionDetail,
    SectionSummary,
)

app = FastAPI(
    title="Constitution Acts API",
    version="0.1.0",
    description="REST API to browse BNS, BNSS, and BSA structured datasets.",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/health")
def healthcheck() -> dict[str, str]:
    return {"status": "ok"}


@app.get("/acts", response_model=List[ActSummary])
def list_acts(registry: ActRegistry = REGISTRY) -> List[ActSummary]:
    payload: List[ActSummary] = []
    for act in registry.list_acts():
        payload.append(
            ActSummary(
                act_id=act.act_id,
                title=act.title,
                section_count=len(act.sections),
                languages=sorted(act.languages),
            )
        )
    return payload


@app.get("/acts/{act_id}", response_model=ActDetail)
def get_act(act_id: str, registry: ActRegistry = REGISTRY) -> ActDetail:
    act = registry.get_act(act_id)
    if not act:
        raise HTTPException(status_code=404, detail="Act not found")
    samples = [
        _to_section_summary(act.act_id, registry.get_section(act.act_id, number))
        for number in act.order[:3]
    ]
    samples = [s for s in samples if s is not None]
    return ActDetail(
        act_id=act.act_id,
        title=act.title,
        section_count=len(act.sections),
        languages=sorted(act.languages),
        sample_sections=samples,
    )


@app.get("/acts/{act_id}/sections", response_model=PaginatedSections)
def list_sections(
    act_id: str,
    offset: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=200),
    registry: ActRegistry = REGISTRY,
) -> PaginatedSections:
    act = registry.get_act(act_id)
    if not act:
        raise HTTPException(status_code=404, detail="Act not found")
    slice_numbers = act.order[offset : offset + limit]
    items = [_to_section_summary(act.act_id, act.sections[num]) for num in slice_numbers]
    return PaginatedSections(
        act_id=act.act_id,
        total=len(act.sections),
        offset=offset,
        limit=limit,
        items=[item for item in items if item is not None],
    )


@app.get("/acts/{act_id}/sections/{section_number}", response_model=SectionDetail)
def get_section(
    act_id: str,
    section_number: str,
    registry: ActRegistry = REGISTRY,
) -> SectionDetail:
    section = registry.get_section(act_id, section_number)
    if not section:
        raise HTTPException(status_code=404, detail="Section not found")
    return _to_section_detail(act_id, section)


@app.get("/search", response_model=SearchResponse)
def search_sections(
    q: str = Query(..., min_length=2, description="Full-text query string"),
    act_id: Optional[str] = Query(None, description="Limit search to a specific act"),
    limit: int = Query(20, ge=1, le=100),
    registry: ActRegistry = REGISTRY,
) -> SearchResponse:
    results = registry.search(q, act_id=act_id, limit=limit)
    hits: List[SearchHit] = []
    for act, record in results:
        snippet = record.preview(200)
        hits.append(
            SearchHit(
                act_id=act.act_id,
                section_number=record.number,
                heading=record.heading,
                snippet=snippet,
            )
        )
    return SearchResponse(query=q, total=len(results), items=hits)


# ---------------------------------------------------------------------------

def _to_section_summary(act_id: str, record: Optional[SectionRecord]) -> Optional[SectionSummary]:
    if not record:
        return None
    return SectionSummary(
        section_number=record.number,
        heading=record.heading,
        preview=record.preview(),
    )


def _to_section_detail(act_id: str, record: SectionRecord) -> SectionDetail:
    return SectionDetail(
        act_id=act_id,
        section_number=record.number,
        heading=record.heading,
        text_en=record.text_en,
        text_hi=record.text_hi,
    )
