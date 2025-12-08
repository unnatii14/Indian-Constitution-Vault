"""
AI-powered legal explanation service using Google Gemini.
Converts complex legal language to simple Hindi and English.
WITH CACHING to keep chatbot FREE for 100k+ users!
"""

import os
from dotenv import load_dotenv
import google.generativeai as genai
from typing import Dict, Optional
from .cache_service import explanation_cache

# Load environment variables from .env file
load_dotenv()

# Configure Gemini API - MUST be set in .env file
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
if not GEMINI_API_KEY:
    raise ValueError("GEMINI_API_KEY environment variable is required! Add it to backend/.env file")
genai.configure(api_key=GEMINI_API_KEY)


class LegalExplainerAI:
    """AI service for explaining legal sections in simple language."""

    def __init__(self):
        self.model = None
        if GEMINI_API_KEY:
            try:
                self.model = genai.GenerativeModel('gemini-1.5-flash')
                print(f"✅ Gemini AI initialized successfully")
            except Exception as e:
                print(f"❌ Failed to initialize Gemini: {e}")
                self.model = None

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
        Answer a user's legal question with SMART CACHING to stay FREE!
        
        Caches common questions so 90% of users get instant answers without API calls.
        Only unique questions hit the Gemini API.

        Args:
            user_question: The question asked by user
            language: 'en' or 'hi'
            context: Optional context (e.g., previous conversation)

        Returns:
            AI-generated answer with safety guidelines
        """
        # 1. CHECK CACHE FIRST (90% hit rate expected!)
        cached_answer = explanation_cache.get_chat_answer(user_question, language)
        if cached_answer:
            print(f"✅ Cache hit for chat question (saved API call!)")
            return cached_answer
        
        print(f"⚡ Cache miss - calling Gemini API")
        
        if not self.model:
            return "AI service unavailable" if language == "en" else "AI सेवा उपलब्ध नहीं"

        if language == "hi":
            system_prompt = """
आप एक शैक्षिक कानूनी सहायक हैं। आप भारतीय कानून की जानकारी सरल भाषा में देते हैं।

✔️ आप क्या कर सकते हैं:
- कानूनी अवधारणाओं और धाराओं को समझाना
- सामान्य कानूनी अधिकारों की जानकारी देना
- कानून को सरल भाषा में बताना

❌ आप क्या नहीं कर सकते:
- व्यक्तिगत कानूनी सलाह देना
- किसी को क्या करना चाहिए बताना
- FIR या कानूनी दस्तावेज़ तैयार करना
- राजनीतिक राय देना

महत्वपूर्ण: यह केवल शैक्षिक जानकारी है। व्यक्तिगत मामलों के लिए वकील से संपर्क करें।
"""
        else:
            system_prompt = """
You are an educational legal assistant. You provide information about Indian law in simple language.

✔️ What you CAN do:
- Explain legal concepts and sections
- Provide general information about legal rights
- Simplify legal language

❌ What you CANNOT do:
- Provide personalized legal advice
- Tell someone what action to take
- Draft FIRs or legal documents
- Express political opinions

Important: This is educational information only. Consult a lawyer for personal matters.

Always include this reminder in your responses when appropriate:
"💡 Note: This is educational information. Consult a qualified lawyer for personalized advice."
"""

        full_prompt = f"{system_prompt}\n\n"
        if context:
            full_prompt += f"Previous context: {context}\n\n"
        full_prompt += f"User question: {user_question}\n\nProvide an educational response following the ethical guidelines above:"

        try:
            response = self.model.generate_content(full_prompt)
            answer = response.text
            
            # Add safety disclaimer if not already present
            if language == "en" and "consult" not in answer.lower() and len(answer) > 100:
                answer += "\n\n💡 Note: This is educational information. Consult a qualified lawyer for personalized advice."
            elif language == "hi" and "वकील" not in answer and len(answer) > 100:
                answer += "\n\n💡 नोट: यह शैक्षिक जानकारी है। व्यक्तिगत सलाह के लिए वकील से संपर्क करें।"
            
            # 2. CACHE THE ANSWER FOR FUTURE USERS (Make it FREE!)
            explanation_cache.set_chat_answer(user_question, language, answer)
            print(f"💾 Cached chat answer for future users")
            
            return answer
        except Exception as e:
            print(f"❌ Chat query error: {e}")
            print(f"❌ Error type: {type(e).__name__}")
            import traceback
            traceback.print_exc()
            return "Error generating response" if language == "en" else "जवाब बनाने में त्रुटि"


# Global instance
legal_ai = LegalExplainerAI()
