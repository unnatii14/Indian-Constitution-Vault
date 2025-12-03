"""FastAPI application exposing the Constitution dataset."""
from __future__ import annotations

from typing import List, Optional
import os

from fastapi import Depends, FastAPI, HTTPException, Query, Request, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import APIKeyHeader

from .data_loader import ActRegistry, REGISTRY, SectionRecord
from .models import (
    ActDetail,
    ActSummary,
    ChatRequest,
    ChatResponse,
    ExplainRequest,
    ExplainResponse,
    PaginatedSections,
    SearchHit,
    SearchResponse,
    SectionDetail,
    SectionSummary,
)
from .ai_service import legal_ai

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

# API Key Authentication
API_KEY_NAME = "X-API-Key"
api_key_header = APIKeyHeader(name=API_KEY_NAME, auto_error=False)

# Load API key from environment variable
VALID_API_KEY = os.getenv("APP_API_KEY", "constitution-vault-secret-key-2025")


async def verify_api_key(api_key: str = Depends(api_key_header)):
    """Verify the API key for protected endpoints."""
    if api_key != VALID_API_KEY:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or missing API key"
        )
    return api_key


def get_registry() -> ActRegistry:
    return REGISTRY


@app.get("/health")
def healthcheck() -> dict[str, str]:
    return {"status": "ok"}


@app.get("/acts", response_model=List[ActSummary])
def list_acts(registry: ActRegistry = Depends(get_registry)) -> List[ActSummary]:
    payload: List[ActSummary] = []
    for act in registry.list_acts():
        # Skip acts with no sections (like CONST-1950, CRPC-1973, IPC-1860 which have 0 sections)
        if len(act.sections) == 0:
            continue
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
def get_act(act_id: str, registry: ActRegistry = Depends(get_registry)) -> ActDetail:
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
    registry: ActRegistry = Depends(get_registry),
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
    registry: ActRegistry = Depends(get_registry),
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
    registry: ActRegistry = Depends(get_registry),
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


@app.post("/api/explain", response_model=ExplainResponse)
def explain_section(request: ExplainRequest, api_key: str = Depends(verify_api_key)) -> ExplainResponse:
    """Convert complex legal text to simple language using AI."""
    result = legal_ai.explain_section(
        section_text=request.section_text,
        language=request.language,
        include_examples=request.include_examples
    )
    return ExplainResponse(
        simple_explanation=result.get("simple_explanation", ""),
        examples=result.get("examples")
    )


@app.post("/api/chat", response_model=ChatResponse)
def chat_query(request: ChatRequest, api_key: str = Depends(verify_api_key)) -> ChatResponse:
    """Answer user's legal questions using AI."""
    answer = legal_ai.chat_query(
        user_question=request.question,
        language=request.language,
        context=request.context
    )
    
    disclaimer = (
        "यह केवल शैक्षिक जानकारी है, कानूनी सलाह नहीं। गंभीर मामलों में वकील से परामर्श करें।"
        if request.language == "hi"
        else "This is educational information only, not legal advice. Consult a lawyer for serious matters."
    )
    
    return ChatResponse(answer=answer, disclaimer=disclaimer)


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
        content=record.text_en,
        content_hi=record.text_hi,
    )
