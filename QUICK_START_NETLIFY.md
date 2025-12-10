# 🚀 Quick Start: Deploy to Netlify

Your Flutter web app is ready to deploy! Follow these simple steps:

## ✅ What's Been Done

- ✓ Flutter web app configured and built successfully
- ✓ Web metadata and manifest updated
- ✓ Netlify configuration files created
- ✓ GitHub Actions workflow set up
- ✓ Production build tested locally

## 📦 Files Created

```
mobile/
  ├── netlify.toml          # Netlify configuration
  ├── netlify-build.sh      # Alternative build script
  ├── _redirects            # SPA routing rules
  └── build/web/            # Built web app (ready to deploy!)

.github/workflows/
  └── deploy-netlify.yml    # Automated deployment workflow

NETLIFY_DEPLOYMENT.md       # Detailed deployment guide
```

## 🎯 Deploy Now (3 Options)

### Option 1: Drag & Drop (Easiest - 2 minutes)

1. Go to https://app.netlify.com/drop
2. Drag the `mobile/build/web` folder
3. Done! Your site is live at a random URL

### Option 2: Netlify CLI (Quick)

```bash
# Install Netlify CLI
npm install -g netlify-cli

# Deploy from the mobile folder
cd mobile
netlify deploy --prod --dir=build/web
```

### Option 3: GitHub Integration (Best for Production)

1. **Push to GitHub**
   ```bash
   git add .
   git commit -m "Add Netlify deployment"
   git push origin main
   ```

2. **Connect to Netlify**
   - Go to https://app.netlify.com/
   - Click "Add new site" → "Import an existing project"
   - Select your GitHub repository
   - Use these settings:
     - Base directory: `mobile`
     - Build command: `flutter build web --release`
     - Publish directory: `mobile/build/web`

3. **Add Secrets for GitHub Actions** (Optional - for automated deployment)
   - Go to GitHub repo → Settings → Secrets → Actions
   - Add:
     - `NETLIFY_AUTH_TOKEN`: Get from Netlify → User settings → Applications
     - `NETLIFY_SITE_ID`: Get from Netlify → Site settings → Site details

## 🧪 Test Locally

```bash
cd mobile/build/web
python -m http.server 8080
```

Visit: http://localhost:8080

## 📱 Features

- ✨ Fully responsive web app
- 🔍 All Flutter features work on web
- 🌐 Connected to production API
- 🔐 API authentication configured
- 📚 Access to Indian Constitution & Criminal Codes (BNS, BNSS, BSA)
- 🔎 Law finder functionality
- 📖 Bilingual support (English/Hindi)

## 🔧 Configuration

The app is pre-configured with:
- **API URL**: `https://constitution-vault-api.onrender.com`
- **API Key**: Already set in code
- **Build mode**: Production optimized
- **Client-side routing**: Configured

## 📊 What to Expect

- **Build time**: ~2-3 minutes (first build)
- **Bundle size**: ~10-15 MB (includes Flutter engine)
- **Loading time**: 2-5 seconds (first visit)
- **Netlify free tier**: Perfect for this app
  - 100 GB bandwidth/month
  - 300 build minutes/month

## 🎨 Custom Domain (Optional)

After deployment, add a custom domain in Netlify:
1. Site settings → Domain management
2. Add custom domain
3. Update DNS records

## 📖 Need Help?

See `NETLIFY_DEPLOYMENT.md` for detailed instructions and troubleshooting.

## 🌟 Next Steps

After deployment:
1. Test all routes and features
2. Share your site URL
3. Set up continuous deployment
4. Configure custom domain (optional)
5. Monitor with Netlify Analytics

---

**Ready to deploy?** Just pick one of the 3 options above! 🎉
