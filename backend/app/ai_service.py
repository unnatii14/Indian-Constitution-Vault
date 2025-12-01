"""
AI-powered legal explanation service using Google Gemini.
Converts complex legal language to simple Hindi and English.
"""

import os
from dotenv import load_dotenv
import google.generativeai as genai
from typing import Dict, Optional

# Load environment variables from .env file
load_dotenv()

# Configure Gemini API
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY", "AIzaSyCAIVglJb8NOYh77OrE-euTlrGQE4W513U")
if GEMINI_API_KEY:
    genai.configure(api_key=GEMINI_API_KEY)


class LegalExplainerAI:
    """AI service for explaining legal sections in simple language."""

    def __init__(self):
        self.model = None
        if GEMINI_API_KEY:
            self.model = genai.GenerativeModel('gemini-2.5-flash')

    def explain_section(
        self,
        section_text: str,
        language: str = "en",
        include_examples: bool = True
    ) -> Dict[str, str]:
        """
        Explain a legal section in simple language.

        Args:
            section_text: The legal text to explain
            language: 'en' for English, 'hi' for Hindi
            include_examples: Whether to include real-world examples

        Returns:
            Dictionary with 'simple_explanation' and optionally 'examples'
        """
        if not self.model:
            return self._fallback_explanation(language)

        prompt = self._create_prompt(section_text, language, include_examples)

        try:
            response = self.model.generate_content(prompt)
            return self._parse_response(response.text, include_examples)
        except Exception as e:
            print(f"AI explanation error: {e}")
            return self._fallback_explanation(language)

    def _create_prompt(
        self,
        section_text: str,
        language: str,
        include_examples: bool
    ) -> str:
        """Create prompt for AI based on language and requirements."""

        if language == "hi":
            base_prompt = f"""
आप एक कानूनी सहायक हैं जो आम लोगों को भारतीय कानून समझाते हैं।

नीचे दिए गए कानूनी धारा को बहुत सरल हिंदी में समझाइए:

धारा: {section_text}

कृपया इसे इस तरह समझाएं कि एक आम व्यक्ति जो कानूनी भाषा नहीं जानता, वह आसानी से समझ सके।
कठिन शब्दों का प्रयोग न करें। रोज़मर्रा की भाषा का उपयोग करें।
"""
            if include_examples:
                base_prompt += "\n\nकृपया 2-3 वास्तविक उदाहरण भी दें कि यह कानून कब लागू होता है।"

        else:  # English
            base_prompt = f"""
You are a legal assistant helping common people understand Indian law.

Explain the following legal section in very simple English:

Section: {section_text}

Please explain it in a way that a common person without legal knowledge can easily understand.
Avoid complex legal terminology. Use everyday language.
"""
            if include_examples:
                base_prompt += "\n\nPlease also provide 2-3 real-world examples of when this law applies."

        base_prompt += "\n\nFormat your response as:\nEXPLANATION: [simple explanation]\nEXAMPLES: [examples if requested]"

        return base_prompt

    def _parse_response(
        self,
        response_text: str,
        include_examples: bool
    ) -> Dict[str, str]:
        """Parse AI response into structured format."""

        result = {}

        # Split by sections
        parts = response_text.split("EXAMPLES:")

        if "EXPLANATION:" in parts[0]:
            result["simple_explanation"] = parts[0].split("EXPLANATION:")[1].strip()
        else:
            result["simple_explanation"] = parts[0].strip()

        if include_examples and len(parts) > 1:
            result["examples"] = parts[1].strip()

        return result

    def _fallback_explanation(self, language: str) -> Dict[str, str]:
        """Fallback explanation when AI is not available."""

        if language == "hi":
            return {
                "simple_explanation": "AI सेवा उपलब्ध नहीं है। कृपया बाद में पुनः प्रयास करें।",
                "examples": ""
            }
        else:
            return {
                "simple_explanation": "AI service is not available. Please try again later.",
                "examples": ""
            }

    def chat_query(
        self,
        user_question: str,
        language: str = "en",
        context: Optional[str] = None
    ) -> str:
        """
        Answer a user's legal question in natural language.

        Args:
            user_question: The question asked by user
            language: 'en' or 'hi'
            context: Optional context (e.g., previous conversation)

        Returns:
            AI-generated answer
        """
        if not self.model:
            return "AI service unavailable" if language == "en" else "AI सेवा उपलब्ध नहीं"

        if language == "hi":
            system_prompt = """
आप एक कानूनी सहायक हैं जो भारतीय कानून के बारे में सवालों का जवाब देते हैं।
बहुत सरल हिंदी में जवाब दें। जटिल कानूनी शब्दों से बचें।
हमेशा संबंधित धाराओं का उल्लेख करें।

महत्वपूर्ण: यह केवल शैक्षिक जानकारी है, कानूनी सलाह नहीं। गंभीर मामलों में वकील से परामर्श करें।
"""
        else:
            system_prompt = """
You are a legal assistant answering questions about Indian law.
Answer in very simple English. Avoid complex legal terminology.
Always mention relevant sections.

Important: This is educational information only, not legal advice. Consult a lawyer for serious matters.
"""

        full_prompt = f"{system_prompt}\n\n"
        if context:
            full_prompt += f"Previous context: {context}\n\n"
        full_prompt += f"Question: {user_question}\n\nAnswer:"

        try:
            response = self.model.generate_content(full_prompt)
            return response.text
        except Exception as e:
            print(f"Chat query error: {e}")
            return "Error generating response" if language == "en" else "जवाब बनाने में त्रुटि"


# Global instance
legal_ai = LegalExplainerAI()
