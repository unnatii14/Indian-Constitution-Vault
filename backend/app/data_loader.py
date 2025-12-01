"""Utility helpers to load structured act data into memory."""
from __future__ import annotations

import json
import re
from dataclasses import dataclass, field
from pathlib import Path
from typing import Dict, Iterable, List, Optional

ROOT = Path(__file__).resolve().parents[2]
STRUCTURED_DIR = ROOT / "data" / "structured"

# Friendly titles for known act IDs. Falls back to the ID itself.
ACT_TITLES = {
    "BNS-2023": "Bharatiya Nyaya Sanhita, 2023",
    "BNSS-2023": "Bharatiya Nagarik Suraksha Sanhita, 2023",
    "BSA-2023": "Bharatiya Sakshya Adhiniyam, 2023",
}


@dataclass
class SectionRecord:
    number: str
    heading: str
    text_en: str
    text_hi: Optional[str] = None

    def preview(self, max_chars: int = 240) -> str:
        text = self.text_en.replace("\n", " ").strip()
        if len(text) <= max_chars:
            return text
        return text[: max_chars - 1].rstrip() + "…"


@dataclass
class ActRecord:
    act_id: str
    title: str
    sections: Dict[str, SectionRecord] = field(default_factory=dict)
    order: List[str] = field(default_factory=list)
    languages: List[str] = field(default_factory=lambda: ["en"])

    def iter_sections(self, section_numbers: Optional[Iterable[str]] = None) -> Iterable[SectionRecord]:
        if section_numbers is None:
            for number in self.order:
                yield self.sections[number]
        else:
            for number in section_numbers:
                if number in self.sections:
                    yield self.sections[number]


class ActRegistry:
    """Loads act data from the structured JSON files and serves queries."""

    def __init__(self, data_dir: Path = STRUCTURED_DIR) -> None:
        self.data_dir = data_dir
        self.acts: Dict[str, ActRecord] = {}
        self._load()

    # ------------------------------------------------------------------
    def _load(self) -> None:
        for en_path in sorted(self.data_dir.glob("*_en.json")):
            with en_path.open("r", encoding="utf-8") as handle:
                payload = json.load(handle)
            act_id = (payload.get("act_id") or en_path.stem.split("_", 1)[0]).upper()
            title = ACT_TITLES.get(act_id, act_id)
            act = ActRecord(act_id=act_id, title=title)

            for raw in payload.get("sections", []):
                number = _normalize_section_number(raw.get("section_number"))
                if not number or number in act.sections:
                    continue
                heading = (raw.get("heading") or "").strip()
                text_en = (raw.get("text") or "").strip()
                act.sections[number] = SectionRecord(number=number, heading=heading, text_en=text_en)
                act.order.append(number)

            self._merge_bilingual_text(act, en_path)
            self.acts[act_id] = act

    def _merge_bilingual_text(self, act: ActRecord, en_path: Path) -> None:
        bilingual_name = en_path.stem.replace("_en", "_bilingual") + ".jsonl"
        bilingual_path = en_path.with_name(bilingual_name)
        if not bilingual_path.exists():
            return
        if "hi" not in act.languages:
            act.languages.append("hi")
        with bilingual_path.open("r", encoding="utf-8") as handle:
            for line in handle:
                line = line.strip()
                if not line:
                    continue
                data = json.loads(line)
                number = _normalize_section_number(data.get("section_number"))
                if not number:
                    continue
                record = act.sections.get(number)
                if record:
                    text_hi = (data.get("text_hi") or "").strip()
                    if text_hi:
                        record.text_hi = text_hi

    # ------------------------------------------------------------------
    def list_acts(self) -> List[ActRecord]:
        return list(self.acts.values())

    def get_act(self, act_id: str) -> Optional[ActRecord]:
        if not act_id:
            return None
        return self.acts.get(act_id.upper())

    def get_section(self, act_id: str, section_number: str) -> Optional[SectionRecord]:
        act = self.get_act(act_id)
        if not act:
            return None
        number = _normalize_section_number(section_number)
        if not number:
            return None
        return act.sections.get(number)

    def search(self, query: str, act_id: Optional[str] = None, limit: int = 20) -> List[tuple[ActRecord, SectionRecord]]:
        if not query:
            return []
        query_lc = query.lower()
        matches: List[tuple[ActRecord, SectionRecord]] = []
        acts = [self.get_act(act_id)] if act_id else self.acts.values()
        for act in acts:
            if not act:
                continue
            for number in act.order:
                record = act.sections[number]
                haystack = f"{record.heading}\n{record.text_en}".lower()
                if query_lc in haystack:
                    matches.append((act, record))
                    if len(matches) >= limit:
                        return matches
        return matches


def _normalize_section_number(value: Optional[str]) -> Optional[str]:
    if not value:
        return None
    text = str(value).strip()
    match = re.match(r"([0-9]+[A-Za-z0-9]*)", text)
    if match:
        return match.group(1)
    return text or None


REGISTRY = ActRegistry()
