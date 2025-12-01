from dotenv import load_dotenv
import os

load_dotenv()

api_key = os.getenv("GEMINI_API_KEY", "")
print(f"API Key exists: {bool(api_key)}")
print(f"API Key length: {len(api_key)}")
if api_key:
    print(f"API Key starts with: {api_key[:20]}...")
