"""
Caching service for AI explanations to reduce API costs.
Caches explanations in SQLite database to serve 80% of requests without API calls.
"""

import sqlite3
import hashlib
import json
from pathlib import Path
from typing import Optional, Dict

# Cache database path
CACHE_DB = Path(__file__).parent.parent / "data" / "ai_cache.db"


class ExplanationCache:
    """Cache for AI explanations to reduce Gemini API costs."""

    def __init__(self, db_path: Path = CACHE_DB):
        self.db_path = db_path
        self._init_db()

    def _init_db(self):
        """Initialize cache database with schema."""
        self.db_path.parent.mkdir(parents=True, exist_ok=True)
        
        with sqlite3.connect(self.db_path) as conn:
            conn.execute("""
                CREATE TABLE IF NOT EXISTS ai_explanations (
                    cache_key TEXT PRIMARY KEY,
                    section_text_hash TEXT NOT NULL,
                    language TEXT NOT NULL,
                    include_examples BOOLEAN NOT NULL,
                    simple_explanation TEXT NOT NULL,
                    examples TEXT,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    hit_count INTEGER DEFAULT 0
                )
            """)
            
            conn.execute("""
                CREATE INDEX IF NOT EXISTS idx_hash 
                ON ai_explanations(section_text_hash)
            """)
            
            conn.execute("""
                CREATE TABLE IF NOT EXISTS ai_chat_cache (
                    cache_key TEXT PRIMARY KEY,
                    question_hash TEXT NOT NULL,
                    language TEXT NOT NULL,
                    answer TEXT NOT NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    hit_count INTEGER DEFAULT 0
                )
            """)
            
            conn.execute("""
                CREATE INDEX IF NOT EXISTS idx_question 
                ON ai_chat_cache(question_hash)
            """)
            
            conn.commit()

    def _generate_key(self, text: str, language: str, include_examples: bool = False) -> str:
        """Generate cache key from section text and parameters."""
        text_hash = hashlib.md5(text.encode()).hexdigest()
        return f"{text_hash}:{language}:{int(include_examples)}"

    def get_explanation(
        self,
        section_text: str,
        language: str,
        include_examples: bool
    ) -> Optional[Dict[str, str]]:
        """
        Get cached explanation if available.
        
        Returns:
            Cached explanation dict or None if not found
        """
        cache_key = self._generate_key(section_text, language, include_examples)
        
        with sqlite3.connect(self.db_path) as conn:
            cursor = conn.execute(
                """
                SELECT simple_explanation, examples 
                FROM ai_explanations 
                WHERE cache_key = ?
                """,
                (cache_key,)
            )
            row = cursor.fetchone()
            
            if row:
                # Increment hit counter
                conn.execute(
                    "UPDATE ai_explanations SET hit_count = hit_count + 1 WHERE cache_key = ?",
                    (cache_key,)
                )
                conn.commit()
                
                return {
                    "simple_explanation": row[0],
                    "examples": row[1] or ""
                }
        
        return None

    def set_explanation(
        self,
        section_text: str,
        language: str,
        include_examples: bool,
        explanation: Dict[str, str]
    ) -> None:
        """Cache an explanation for future use."""
        cache_key = self._generate_key(section_text, language, include_examples)
        text_hash = hashlib.md5(section_text.encode()).hexdigest()
        
        with sqlite3.connect(self.db_path) as conn:
            conn.execute(
                """
                INSERT OR REPLACE INTO ai_explanations 
                (cache_key, section_text_hash, language, include_examples, 
                 simple_explanation, examples, hit_count)
                VALUES (?, ?, ?, ?, ?, ?, 
                    COALESCE((SELECT hit_count FROM ai_explanations WHERE cache_key = ?), 0))
                """,
                (
                    cache_key,
                    text_hash,
                    language,
                    include_examples,
                    explanation["simple_explanation"],
                    explanation.get("examples", ""),
                    cache_key
                )
            )
            conn.commit()

    def get_chat_answer(self, question: str, language: str) -> Optional[str]:
        """Get cached chat answer if available."""
        question_hash = hashlib.md5(question.lower().encode()).hexdigest()
        cache_key = f"{question_hash}:{language}"
        
        with sqlite3.connect(self.db_path) as conn:
            cursor = conn.execute(
                "SELECT answer FROM ai_chat_cache WHERE cache_key = ?",
                (cache_key,)
            )
            row = cursor.fetchone()
            
            if row:
                # Increment hit counter
                conn.execute(
                    "UPDATE ai_chat_cache SET hit_count = hit_count + 1 WHERE cache_key = ?",
                    (cache_key,)
                )
                conn.commit()
                return row[0]
        
        return None

    def set_chat_answer(self, question: str, language: str, answer: str) -> None:
        """Cache a chat answer for future use."""
        question_hash = hashlib.md5(question.lower().encode()).hexdigest()
        cache_key = f"{question_hash}:{language}"
        
        with sqlite3.connect(self.db_path) as conn:
            conn.execute(
                """
                INSERT OR REPLACE INTO ai_chat_cache 
                (cache_key, question_hash, language, answer, hit_count)
                VALUES (?, ?, ?, ?,
                    COALESCE((SELECT hit_count FROM ai_chat_cache WHERE cache_key = ?), 0))
                """,
                (cache_key, question_hash, language, answer, cache_key)
            )
            conn.commit()

    def get_stats(self) -> Dict[str, int]:
        """Get cache statistics."""
        with sqlite3.connect(self.db_path) as conn:
            cursor = conn.execute(
                """
                SELECT 
                    COUNT(*) as total_explanations,
                    SUM(hit_count) as total_hits,
                    (SELECT COUNT(*) FROM ai_chat_cache) as total_chat_cache,
                    (SELECT SUM(hit_count) FROM ai_chat_cache) as total_chat_hits
                FROM ai_explanations
                """
            )
            row = cursor.fetchone()
            
            return {
                "cached_explanations": row[0],
                "explanation_hits": row[1] or 0,
                "cached_chats": row[2] or 0,
                "chat_hits": row[3] or 0,
                "total_api_calls_saved": (row[1] or 0) + (row[3] or 0)
            }


# Global cache instance
explanation_cache = ExplanationCache()
