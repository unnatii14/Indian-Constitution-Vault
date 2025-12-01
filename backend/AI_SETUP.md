# 🤖 AI Features Setup

## Getting Your Free Gemini API Key

The app uses Google's Gemini AI to explain laws in simple language (Hindi & English).

### Steps:

1. **Visit Google AI Studio**  
   Go to: https://makersuite.google.com/app/apikey

2. **Sign in with Google Account**  
   Use your Gmail account

3. **Create API Key**  
   - Click "Create API Key"
   - Select a project or create new one
   - Copy the generated key

4. **Add to Backend**  
   Create a `.env` file in the `backend/` directory:
   ```bash
   cd backend
   cp .env.example .env
   ```

5. **Edit `.env` file**  
   ```
   GEMINI_API_KEY=your_actual_api_key_here
   ```

6. **Restart Backend Server**  
   ```bash
   uvicorn app.main:app --reload
   ```

## Without API Key

The app will still work without the AI features. AI endpoints will return:
- English: "AI service is not available. Please try again later."
- Hindi: "AI सेवा उपलब्ध नहीं है। कृपया बाद में पुनः प्रयास करें।"

## Free Tier Limits

Google Gemini Free Tier:
- **60 requests per minute**
- **1,500 requests per day**
- Perfect for development and moderate usage

## Testing AI Endpoints

Once configured, test with:

```bash
# Test explanation (English)
curl -X POST http://localhost:8000/api/explain \
  -H "Content-Type: application/json" \
  -d '{
    "section_text": "Whoever commits murder shall be punished with death or imprisonment for life",
    "language": "en",
    "include_examples": true
  }'

# Test explanation (Hindi)
curl -X POST http://localhost:8000/api/explain \
  -H "Content-Type: application/json" \
  -d '{
    "section_text": "जो कोई हत्या करेगा वह मृत्युदंड या आजीवन कारावास से दंडित किया जाएगा",
    "language": "hi",
    "include_examples": true
  }'

# Test chat
curl -X POST http://localhost:8000/api/chat \
  -H "Content-Type: application/json" \
  -d '{
    "question": "What are my rights if police stops me?",
    "language": "en"
  }'
```

## Security Note

⚠️ **Never commit your `.env` file to Git!**  
The `.gitignore` file already excludes `.env` files.

---

**Ready to make law accessible to everyone! 🇮🇳**
