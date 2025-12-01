"""Pydantic schemas for the Constitution data API."""
from __future__ import annotations

from typing import List, Optional

from pydantic import BaseModel, Field


class SectionSummary(BaseModel):
    section_number: str = Field(..., description="Canonical section identifier")
    heading: str = Field(..., description="English heading for the section")
    preview: Optional[str] = Field(
        None,
        description="Short excerpt from the English text to help clients preview the content.",
    )


class SectionDetail(BaseModel):
    act_id: str
    section_number: str
    heading: str
    content: str = Field(..., description="English content")
    content_hi: Optional[str] = Field(None, description="Hindi content")


class ActSummary(BaseModel):
    act_id: str
    title: str
    section_count: int
    languages: List[str] = Field(default_factory=lambda: ["en"])


class ActDetail(ActSummary):
    sample_sections: List[SectionSummary] = Field(default_factory=list)


class PaginatedSections(BaseModel):
    act_id: str
    total: int
    offset: int
    limit: int
    items: List[SectionSummary]


class SearchHit(BaseModel):
    act_id: str
    section_number: str
    heading: str
    snippet: str


class SearchResponse(BaseModel):
    query: str
    total: int
    items: List[SearchHit]


class ExplainRequest(BaseModel):
    section_text: str = Field(..., description="Legal text to explain")
    language: str = Field("en", description="Language: 'en' or 'hi'")
    include_examples: bool = Field(True, description="Include real-world examples")


class ExplainResponse(BaseModel):
    simple_explanation: str
    examples: Optional[str] = None


class ChatRequest(BaseModel):
    question: str = Field(..., description="User's legal question")
    language: str = Field("en", description="Language: 'en' or 'hi'")
    context: Optional[str] = Field(None, description="Previous conversation context")


class ChatResponse(BaseModel):
    answer: str
    disclaimer: str
