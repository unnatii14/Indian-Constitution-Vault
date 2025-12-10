# 🎯 Netlify Deployment Checklist

Use this checklist to ensure a successful deployment of your Flutter web app to Netlify.

## Pre-Deployment Checklist

### ✅ Files & Configuration
- [x] Web app built successfully (`mobile/build/web/`)
- [x] `netlify.toml` created and configured
- [x] `_redirects` file created for SPA routing
- [x] `index.html` updated with proper metadata
- [x] `manifest.json` configured with app details
- [x] GitHub Actions workflow created (`.github/workflows/deploy-netlify.yml`)

### ✅ API Configuration
- [x] API URL configured: `https://constitution-vault-api.onrender.com`
- [x] API Key set in `lib/config/app_config.dart`
- [x] Backend accessible and running

### ✅ Local Testing
- [x] Build completed without errors
- [x] Local server test: http://localhost:8080
  - [ ] Test homepage loads
  - [ ] Test navigation (Acts list, Law finder, etc.)
  - [ ] Test API calls (fetch acts/sections)
  - [ ] Test responsive design (mobile/tablet/desktop)

## Deployment Method Selection

Choose ONE method below:

### Method 1: Drag & Drop (Quickest - Recommended for First Test)
- [ ] Go to https://app.netlify.com/drop
- [ ] Drag `mobile/build/web` folder
- [ ] Wait for deployment (~30 seconds)
- [ ] Visit the generated URL
- [ ] Test the live site

### Method 2: Netlify CLI
- [ ] Install: `npm install -g netlify-cli`
- [ ] Login: `netlify login`
- [ ] Navigate to mobile folder: `cd mobile`
- [ ] Deploy: `netlify deploy --prod --dir=build/web`
- [ ] Follow prompts
- [ ] Visit the generated URL

### Method 3: GitHub Integration (Best for Production)
#### Step 1: Push to GitHub
- [ ] Stage files: `git add .`
- [ ] Commit: `git commit -m "Add Netlify deployment"`
- [ ] Push: `git push origin main`

#### Step 2: Connect Netlify
- [ ] Go to https://app.netlify.com/
- [ ] Click "Add new site" → "Import an existing project"
- [ ] Choose "GitHub"
- [ ] Authorize Netlify
- [ ] Select repository: `Indian-Constitution-Vault`

#### Step 3: Configure Build
- [ ] Base directory: `mobile`
- [ ] Build command: `flutter build web --release`
- [ ] Publish directory: `mobile/build/web`
- [ ] Click "Deploy site"

#### Step 4: (Optional) Set up GitHub Actions
- [ ] Go to GitHub repo → Settings → Secrets → Actions
- [ ] Add `NETLIFY_AUTH_TOKEN`:
  - Get from Netlify: User settings → Applications → New access token
- [ ] Add `NETLIFY_SITE_ID`:
  - Get from Netlify: Site settings → Site details → Site ID
- [ ] Push a change to trigger deployment

## Post-Deployment Checklist

### 🧪 Testing
- [ ] Visit your Netlify URL
- [ ] Test all pages:
  - [ ] Home/Splash screen
  - [ ] Onboarding (if first visit)
  - [ ] Acts list screen
  - [ ] Law finder screen
  - [ ] About Constitution screen
  - [ ] Section detail view
- [ ] Test functionality:
  - [ ] API calls work (data loads)
  - [ ] Navigation works
  - [ ] Search functionality
  - [ ] Dark mode toggle
  - [ ] Responsive design on mobile
  - [ ] Browser back/forward buttons
  - [ ] Direct URL access (deep linking)

### 🔧 Configuration
- [ ] Check Netlify dashboard for build status
- [ ] Review build logs if issues occur
- [ ] Verify redirects are working (check `_redirects` in deployed files)

### 🌐 Domain Setup (Optional)
- [ ] Go to Site settings → Domain management
- [ ] Click "Add custom domain"
- [ ] Enter your domain name
- [ ] Update DNS records with your domain registrar
- [ ] Wait for DNS propagation (15-60 minutes)
- [ ] Enable HTTPS (automatic with Let's Encrypt)

### 📊 Monitoring (Optional)
- [ ] Enable Netlify Analytics
- [ ] Set up uptime monitoring
- [ ] Configure deploy notifications
- [ ] Add status badge to README

### 🚀 Performance
- [ ] Run Lighthouse audit
  - Target scores: Performance 90+, SEO 95+
- [ ] Test on different browsers:
  - [ ] Chrome
  - [ ] Firefox
  - [ ] Safari
  - [ ] Edge
- [ ] Test on different devices:
  - [ ] Desktop
  - [ ] Tablet
  - [ ] Mobile

### 📱 PWA Features (Optional)
- [ ] Test "Add to Home Screen" on mobile
- [ ] Verify app icon appears correctly
- [ ] Check manifest.json is loaded
- [ ] Test offline functionality (if service worker added)

## Troubleshooting Common Issues

### Build Fails
- [ ] Check build logs in Netlify
- [ ] Verify Flutter version in Netlify matches local
- [ ] Ensure all dependencies are in `pubspec.yaml`
- [ ] Try building locally first

### Routing Issues (404 on refresh)
- [ ] Verify `netlify.toml` is in `mobile/` directory
- [ ] Check `_redirects` file exists
- [ ] Confirm redirects in Netlify dashboard

### API Not Working
- [ ] Check browser console for CORS errors
- [ ] Verify API URL in `app_config.dart`
- [ ] Test API endpoint directly
- [ ] Check API key is correct

### Slow Loading
- [ ] Enable compression in Netlify
- [ ] Optimize images/assets
- [ ] Consider CDN configuration
- [ ] Check Flutter build optimization flags

## Success Criteria

Your deployment is successful when:
- ✅ Site loads at Netlify URL
- ✅ All routes work (no 404s)
- ✅ API calls succeed (data displays)
- ✅ Responsive on all devices
- ✅ Navigation works smoothly
- ✅ No console errors
- ✅ Lighthouse score 90+

## Next Steps After Successful Deployment

1. **Share Your Site**
   - [ ] Share Netlify URL with users
   - [ ] Update README with live link
   - [ ] Post on social media

2. **Set Up Continuous Deployment**
   - [ ] Verify GitHub integration works
   - [ ] Test automatic deployments on push
   - [ ] Configure deploy previews for PRs

3. **Monitor Usage**
   - [ ] Check Netlify analytics
   - [ ] Monitor bandwidth usage
   - [ ] Track error rates

4. **Future Enhancements**
   - [ ] Add service worker for offline support
   - [ ] Set up error tracking (e.g., Sentry)
   - [ ] Implement analytics (e.g., Google Analytics)
   - [ ] Add custom 404 page
   - [ ] Optimize bundle size

## Resources

- **Quick Start**: `QUICK_START_NETLIFY.md`
- **Detailed Guide**: `NETLIFY_DEPLOYMENT.md`
- **Conversion Summary**: `CONVERSION_SUMMARY.md`
- **Flutter Web Docs**: https://flutter.dev/web
- **Netlify Docs**: https://docs.netlify.com
- **Support**: GitHub Issues

---

**Current Status**: ✅ Ready for Deployment

**Build Location**: `mobile/build/web/`

**Local Test**: http://localhost:8080 (if server running)

**Recommended First Step**: Method 1 (Drag & Drop) for quick validation
