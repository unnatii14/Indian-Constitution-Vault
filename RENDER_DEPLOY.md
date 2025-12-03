# 🚀 Render.com Deployment Guide

Complete step-by-step guide to deploy your Constitution Vault backend to Render.com.

---

## 📋 Prerequisites

- [x] GitHub account
- [x] Render.com account (sign up at https://render.com)
- [x] Your code pushed to GitHub
- [x] Gemini API key ready
- [x] App API key generated

---

## 🔧 Step 1: Prepare Your Repository

Your backend is already ready with:
- ✅ `Dockerfile` - Container configuration
- ✅ `render.yaml` - Render deployment config
- ✅ `requirements.txt` - Python dependencies
- ✅ `.env.example` - Environment variables template
- ✅ `.gitignore` - Prevents committing secrets

**Verify files exist:**
```bash
cd backend
ls Dockerfile render.yaml requirements.txt
```

---

## 🌐 Step 2: Create Render Account

1. Go to **https://render.com**
2. Click **"Get Started for Free"**
3. Sign up with GitHub (recommended) or email
4. Verify your email address

---

## 🚀 Step 3: Deploy Backend to Render

### Option A: Using Dashboard (Easiest)

1. **Login to Render Dashboard**
   - Go to https://dashboard.render.com

2. **Create New Web Service**
   - Click **"New +"** button (top right)
   - Select **"Web Service"**

3. **Connect GitHub Repository**
   - Click **"Connect account"** if not connected
   - Authorize Render to access your repositories
   - Select **"Indian-Constitution-Vault"** repository
   - Click **"Connect"**

4. **Configure Service**
   ```
   Name: constitution-vault-api
   Region: Singapore (or closest to India)
   Branch: main
   Root Directory: backend
   Runtime: Python 3
   Build Command: pip install -r requirements.txt
   Start Command: uvicorn app.main:app --host 0.0.0.0 --port $PORT
   Instance Type: Free
   ```

5. **Add Environment Variables**
   - Scroll down to **"Environment Variables"**
   - Click **"Add Environment Variable"**
   - Add these TWO variables:

   ```
   Key: GEMINI_API_KEY
   Value: <Your Gemini API key from https://aistudio.google.com/apikey>
   ```

   ```
   Key: APP_API_KEY
   Value: <Generate with: python -c "import secrets; print(secrets.token_urlsafe(32))">
   ```

6. **Create Web Service**
   - Click **"Create Web Service"**
   - Wait 5-10 minutes for deployment
   - You'll see build logs in real-time

### Option B: Using render.yaml (Automatic)

1. **In Render Dashboard**
   - Click **"New +"** → **"Blueprint"**
   - Connect your repository
   - Render will detect `render.yaml` automatically

2. **Add Environment Variables**
   - Same as Option A (add GEMINI_API_KEY and APP_API_KEY)

3. **Deploy**
   - Click **"Apply"**

---

## ✅ Step 4: Verify Deployment

1. **Check Deployment Status**
   - Wait for "Live" status (green dot)
   - View logs for any errors

2. **Get Your API URL**
   - Copy your service URL: `https://constitution-vault-api.onrender.com`

3. **Test Health Endpoint**
   ```bash
   curl https://constitution-vault-api.onrender.com/health
   ```
   
   Expected response:
   ```json
   {"status": "ok"}
   ```

4. **Test Authenticated Endpoint**
   ```bash
   curl -X POST https://constitution-vault-api.onrender.com/api/chat \
     -H "Content-Type: application/json" \
     -H "X-API-Key: YOUR_APP_API_KEY" \
     -d '{"question":"What is BNS?","language":"en"}'
   ```

   Should return AI response.

---

## 📱 Step 5: Update Flutter App

1. **Update Backend URL**
   
   Edit `mobile/lib/config/app_config.dart`:
   ```dart
   static const String apiBaseUrl = String.fromEnvironment(
     'API_BASE_URL',
     defaultValue: 'https://constitution-vault-api.onrender.com',
   );
   ```

2. **Rebuild App**
   ```bash
   cd mobile
   flutter clean
   flutter pub get
   flutter build apk --release
   ```

3. **Test on Device**
   - Install the APK
   - Test chatbot features
   - Verify AI responses work

---

## 🔒 Step 6: Security Checklist

- [x] Environment variables set in Render (not in code)
- [x] `.env` file NOT committed to Git
- [x] Strong API key generated
- [x] HTTPS enabled (automatic on Render)
- [x] CORS configured properly
- [x] Health check endpoint working

---

## 💰 Render Free Tier Limits

**What you get FREE:**
- ✅ 750 hours/month
- ✅ Automatic SSL (HTTPS)
- ✅ Auto-deploy on Git push
- ✅ 512 MB RAM
- ✅ Shared CPU

**Limitations:**
- ⚠️ Spins down after 15 minutes of inactivity
- ⚠️ First request after spin-down takes ~30 seconds
- ⚠️ 400 build minutes/month

**Tip:** Keep your app active by:
- Using a free uptime monitor (e.g., UptimeRobot)
- Pinging `/health` endpoint every 10 minutes

---

## 🐛 Troubleshooting

### Build Failed
```bash
# Check logs in Render dashboard
# Common issues:
- Missing dependencies in requirements.txt
- Wrong Python version
- Root directory not set to "backend"
```

### Environment Variables Not Loading
```bash
# Verify in Render dashboard:
1. Settings → Environment
2. Check variable names match exactly
3. Click "Save Changes"
```

### App Keeps Spinning Down
```bash
# Upgrade to paid plan ($7/month) for always-on
# OR use UptimeRobot to ping every 10 min
```

### CORS Errors
```bash
# Already configured in main.py
# If issues persist, check browser console
```

### Slow First Request
```bash
# Normal on free tier (cold start)
# App spins down after 15 min inactivity
# First request wakes it up (~30s)
```

---

## 🔄 Auto-Deploy Setup

Render automatically deploys when you push to GitHub:

```bash
# Make changes locally
git add .
git commit -m "Update backend"
git push origin main

# Render will detect changes and auto-deploy
# Check dashboard for deployment status
```

---

## 📊 Monitoring

1. **View Logs**
   - Render Dashboard → Your Service → Logs
   - Real-time logs of all requests

2. **Check Metrics**
   - Dashboard shows CPU, Memory, Requests
   - Free plan: Basic metrics

3. **Set Up Alerts** (Paid plan)
   - Email notifications for downtime
   - Slack integration available

---

## 🎉 Success Checklist

After completing all steps, verify:

- [ ] Backend deployed to Render
- [ ] Health endpoint returns `{"status": "ok"}`
- [ ] Chat endpoint works with API key
- [ ] Flutter app updated with new URL
- [ ] App tested on physical device
- [ ] AI chatbot responds correctly
- [ ] Voice features still work
- [ ] No errors in Render logs

---

## 📞 Support

**Render Issues:**
- Documentation: https://render.com/docs
- Community: https://community.render.com
- Support: support@render.com

**Your Backend Issues:**
- Check Render logs first
- Verify environment variables
- Test with curl commands above

---

## 🚀 Next Steps

1. **Deploy to Play Store**
   - Your backend is now production-ready
   - Follow Google Play Console guide

2. **Add Custom Domain** (Optional, Paid)
   - `api.yourapp.com` instead of `.onrender.com`

3. **Upgrade Plan** (Optional)
   - $7/month for always-on instance
   - Better for production apps

4. **Add Monitoring**
   - UptimeRobot (free)
   - Better Stack (paid, advanced)

---

**🎊 Congratulations! Your backend is now live on the internet!** 🎊

Your API URL: `https://constitution-vault-api.onrender.com`

Test it: `curl https://constitution-vault-api.onrender.com/health`
