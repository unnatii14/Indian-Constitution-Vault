# Netlify Deployment Guide for Indian Law Guide

This guide will help you deploy the Flutter web application to Netlify.

## Prerequisites

1. **Flutter SDK** (version 3.8.1 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   - Add Flutter to your PATH

2. **Git** installed and configured

3. **Netlify Account**
   - Sign up at: https://www.netlify.com/

## Option 1: Deploy via Netlify CLI (Recommended for Quick Testing)

### Step 1: Install Netlify CLI

```bash
npm install -g netlify-cli
```

### Step 2: Build the Flutter Web App

Navigate to the mobile directory and build:

```bash
cd mobile
flutter pub get
flutter build web --release --web-renderer canvaskit
```

### Step 3: Deploy to Netlify

```bash
# Login to Netlify
netlify login

# Deploy the site
netlify deploy --prod --dir=build/web
```

Follow the prompts to create a new site or link to an existing one.

## Option 2: Deploy via Netlify UI (Recommended for Production)

### Step 1: Push Code to GitHub

1. Ensure your code is committed to a Git repository
2. Push to GitHub:

```bash
git add .
git commit -m "Prepare for Netlify deployment"
git push origin main
```

### Step 2: Connect to Netlify

1. Go to [Netlify Dashboard](https://app.netlify.com/)
2. Click **"Add new site"** → **"Import an existing project"**
3. Choose **GitHub** and authorize Netlify
4. Select your repository: `Constitution_Website`

### Step 3: Configure Build Settings

Use these build settings:

- **Base directory**: `mobile`
- **Build command**: `flutter build web --release --web-renderer canvaskit`
- **Publish directory**: `mobile/build/web`

### Step 4: Environment Variables (Optional)

If you need to set environment variables, go to:
**Site settings** → **Build & deploy** → **Environment** → **Environment variables**

You may want to add:
- `FLUTTER_VERSION`: `3.8.1` (or your Flutter version)

### Step 5: Deploy

1. Click **"Deploy site"**
2. Netlify will:
   - Install Flutter
   - Run `flutter pub get`
   - Build the web app
   - Deploy to a URL like: `https://random-name-12345.netlify.app`

### Step 6: Configure Custom Domain (Optional)

1. Go to **Site settings** → **Domain management**
2. Click **"Add custom domain"**
3. Follow the instructions to configure DNS

## Configuration Files Included

### `netlify.toml`
- Defines build settings
- Sets up redirects for client-side routing
- Configures security headers
- Sets cache policies

### `_redirects`
- Fallback file for SPA routing (backup for netlify.toml)

### `netlify-build.sh`
- Alternative build script if needed

## Build Locally to Test

Before deploying, test the build locally:

```bash
cd mobile

# Get dependencies
flutter pub get

# Build for web
flutter build web --release --web-renderer canvaskit

# Serve locally (requires Python)
cd build/web
python -m http.server 8080
```

Visit `http://localhost:8080` to test.

## Troubleshooting

### Build Fails: Flutter Not Found

Netlify doesn't have Flutter pre-installed. You need to:

1. Use the **Flutter Netlify Plugin**:
   - Add to `netlify.toml`:
   ```toml
   [[plugins]]
     package = "@fluttertools/netlify-plugin-flutter"
   ```

2. Or use a **custom Docker container**:
   - Create a Docker-based build
   - Use CircleCI or GitHub Actions to build, then deploy

### Recommended: Use GitHub Actions to Build

Create `.github/workflows/deploy.yml`:

```yaml
name: Build and Deploy to Netlify

on:
  push:
    branches: [ main ]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.8.1'
    
    - name: Install dependencies
      working-directory: ./mobile
      run: flutter pub get
    
    - name: Build web
      working-directory: ./mobile
      run: flutter build web --release --web-renderer canvaskit
    
    - name: Deploy to Netlify
      uses: nwtgck/actions-netlify@v2
      with:
        publish-dir: './mobile/build/web'
        production-branch: main
        deploy-message: "Deploy from GitHub Actions"
      env:
        NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
        NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}
```

### API Configuration

The app is already configured to use the production API:
- **API URL**: `https://constitution-vault-api.onrender.com`
- **API Key**: Already set in `lib/config/app_config.dart`

No additional API configuration is needed.

### Client-Side Routing Issues

The `netlify.toml` file includes redirects to handle Flutter's client-side routing. If routes don't work:

1. Verify `netlify.toml` is in the `mobile/` directory
2. Check that the redirect rules are applied in Netlify dashboard
3. Try adding the `_redirects` file to `mobile/web/` directory

## Performance Optimization

The build uses `--web-renderer canvaskit` which provides:
- Better rendering performance
- Consistent behavior across browsers
- Better support for complex UI

For smaller bundle size (at the cost of some features), you can use:
```bash
flutter build web --release --web-renderer html
```

## Post-Deployment

After successful deployment:

1. **Test all routes**: Navigate through the app
2. **Test API calls**: Ensure backend connectivity works
3. **Check mobile responsiveness**: Test on different screen sizes
4. **Monitor performance**: Use Lighthouse or Netlify Analytics

## Continuous Deployment

Once connected to GitHub, Netlify will automatically:
- Build and deploy on every push to `main` branch
- Create preview deployments for pull requests
- Provide unique URLs for each deployment

## Custom Domain Setup

1. Purchase a domain (e.g., from Namecheap, Google Domains)
2. In Netlify: **Domain settings** → **Add custom domain**
3. Update your domain's DNS settings with Netlify's nameservers
4. Enable HTTPS (automatic with Let's Encrypt)

## Cost

- **Netlify Free Tier**:
  - 100 GB bandwidth/month
  - 300 build minutes/month
  - Automatic HTTPS
  - Continuous deployment
  - Perfect for this project!

## Support

For issues:
- Flutter Web: https://flutter.dev/docs/deployment/web
- Netlify Docs: https://docs.netlify.com/
- GitHub Issues: https://github.com/unnatii14/Indian-Constitution-Vault/issues

---

## Quick Command Reference

```bash
# Build locally
cd mobile
flutter pub get
flutter build web --release --web-renderer canvaskit

# Deploy via CLI
netlify deploy --prod --dir=build/web

# Test locally
cd build/web
python -m http.server 8080
```

Good luck with your deployment! 🚀
