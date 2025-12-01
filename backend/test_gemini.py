"""Quick test of Gemini API directly"""
import os
from dotenv import load_dotenv

load_dotenv()

api_key = os.getenv("GEMINI_API_KEY")
print(f"API Key loaded: {bool(api_key)}")

if api_key:
    try:
        import google.generativeai as genai
        genai.configure(api_key=api_key)
        model = genai.GenerativeModel('gemini-pro')
        
        response = model.generate_content("Say 'Hello from Gemini!' in one sentence.")
        print(f"\n✅ Gemini API working!")
        print(f"Response: {response.text}")
    except Exception as e:
        print(f"\n❌ Gemini API error: {e}")
else:
    print("❌ No API key found")
