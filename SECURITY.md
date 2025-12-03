# 🔒 Security Implementation Guide

## Overview
This app implements API key authentication to protect the backend from unauthorized access when deployed to production.

## How It Works

### Architecture
```
Flutter App → (X-API-Key header) → FastAPI Backend → Gemini API
```

### Protected Endpoints
- `POST /api/chat` - AI chat queries
- `POST /api/explain` - Section explanations

### Public Endpoints (No auth required)
- `GET /health` - Health check
- `GET /acts` - List all acts
- `GET /acts/{id}` - Act details
- `GET /acts/{id}/sections` - Section list
- `GET /search` - Search functionality

## Setup Instructions

### 1. Backend Configuration

**Generate a strong API key:**
```bash
python -c "import secrets; print(secrets.token_urlsafe(32))"
```

**Update `.env` file:**
```env
GEMINI_API_KEY=your_gemini_key_here
APP_API_KEY=your_generated_secure_key_here
```

**Never commit `.env` file to Git!** (already added to .gitignore)

### 2. Mobile App Configuration

**Update `mobile/lib/config/app_config.dart`:**
```dart
static const String apiKey = String.fromEnvironment(
  'API_KEY',
  defaultValue: 'your_generated_secure_key_here',
);
```

**Important:** When deploying to production, use the same key in both backend and mobile app.

### 3. For Production Deployment

**Backend (.env):**
```env
APP_API_KEY=production_key_xyz123
```

**Mobile App (update app_config.dart):**
```dart
defaultValue: 'production_key_xyz123',
```

## Security Best Practices

### ✅ What This Protects Against
- Unauthorized API access
- Random users calling your backend
- Basic abuse and spam
- Excessive API usage

### ⚠️ Important Notes
1. **API key is visible in APK** - Users can extract it using reverse engineering tools
2. **This is NOT military-grade security** - It's basic protection for a free/educational app
3. **Gemini API key stays safe** - Hidden on backend, never exposed to users
4. **Backend is the secure layer** - All sensitive operations happen server-side

### 🚀 Additional Security (Optional)

**Rate Limiting (Recommended):**
```bash
pip install slowapi
```

Add to `backend/app/main.py`:
```python
from slowapi import Limiter
from slowapi.util import get_remote_address

limiter = Limiter(key_func=get_remote_address)

@app.post("/api/chat")
@limiter.limit("10/minute")
async def chat_query(...):
    # your code
```

**User Authentication (Advanced):**
- Firebase Authentication
- OAuth 2.0
- JWT tokens

## Deployment Checklist

- [ ] Generated strong API key
- [ ] Updated backend `.env` file
- [ ] Updated mobile `app_config.dart`
- [ ] Verified `.env` is in `.gitignore`
- [ ] Tested API calls with authentication
- [ ] Deployed backend to cloud (Render, Railway, etc.)
- [ ] Updated mobile app with production backend URL
- [ ] (Optional) Added rate limiting
- [ ] (Optional) Set up monitoring/logging

## Testing Authentication

**Test with curl:**
```bash
# Without API key (should fail)
curl -X POST http://localhost:8000/api/chat \
  -H "Content-Type: application/json" \
  -d '{"question":"test","language":"en"}'

# With API key (should work)
curl -X POST http://localhost:8000/api/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: your_api_key_here" \
  -d '{"question":"test","language":"en"}'
```

**Expected Responses:**
- ❌ Without key: `401 Unauthorized - Invalid or missing API key`
- ✅ With key: `200 OK - {answer: "...", disclaimer: "..."}`

## FAQ

**Q: Can someone steal my API key from the APK?**
A: Yes, but they can only access your backend, NOT your Gemini key. The backend validates all requests and has rate limits.

**Q: Is this safe for Play Store?**
A: Yes! Your Gemini API key is protected on the backend. The app API key is just for basic access control.

**Q: Should I use the same key for dev and production?**
A: No! Use different keys:
- Development: Simple key for testing
- Production: Strong random key

**Q: What if my API key is compromised?**
A: Simply generate a new key, update backend `.env` and mobile app, then redeploy.

**Q: Do I need more security?**
A: For a free educational app, this is sufficient. For paid/commercial apps, consider Firebase Auth or OAuth.

## Support

For issues or questions:
- Check backend logs
- Verify API key matches in both places
- Test authentication with curl
- Review FastAPI error messages

---

**Remember:** Perfect security doesn't exist. This implementation provides reasonable protection for a free educational app while keeping your Gemini API key safe on the backend.
