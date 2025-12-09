# 🔧 Configuration Setup Guide

This guide helps you set up the Indian Constitution Vault app after cloning the repository.

## 📋 Prerequisites

- Flutter 3.8.1 or higher
- Git installed
- Access to the API key (contact repository owner)

## 🚀 Quick Setup

### 1. Clone the Repository

```bash
git clone https://github.com/unnatii14/Indian-Constitution-Vault.git
cd Indian-Constitution-Vault
```

### 2. Configure API Key

The app requires an API key to communicate with the backend. This key is **not included** in the repository for security reasons.

**Steps:**

1. Navigate to the config directory:
   ```bash
   cd mobile/lib/config
   ```

2. Copy the template file:
   ```bash
   # Windows (PowerShell)
   Copy-Item app_config.dart.template app_config.dart

   # macOS/Linux
   cp app_config.dart.template app_config.dart
   ```

3. Open `app_config.dart` and replace `YOUR_API_KEY_HERE` with the actual API key:
   ```dart
   static const String apiKey = 'your_actual_api_key_here';
   ```

4. **Important:** Never commit `app_config.dart` to git! It's already in `.gitignore`.

### 3. Get the API Key

**For Team Members:**
- Contact the repository owner (@unnatii14) for the production API key
- Or check your team's secure password manager

**For Local Development:**
- You can run the backend locally (see `backend/` folder)
- Use the local development API key from your backend setup

### 4. Install Dependencies

```bash
cd mobile
flutter pub get
```

### 5. Run the App

```bash
flutter run
```

## ⚠️ Security Best Practices

### DO:
- ✅ Keep `app_config.dart` in `.gitignore`
- ✅ Use environment-specific configurations
- ✅ Share API keys through secure channels (password managers, encrypted messages)
- ✅ Rotate API keys regularly

### DON'T:
- ❌ Commit `app_config.dart` to git
- ❌ Share API keys in Slack/Discord/public channels
- ❌ Use `git add -f` to force-add ignored files
- ❌ Screenshot or copy-paste API keys in public places

## 🔐 Android Release Signing

The app uses a keystore for release builds. **This file is NOT in the repository.**

**To build release APKs:**

1. Contact the repository owner for the keystore file
2. Place it in the project root as `upload-keystore.jks`
3. Create `mobile/android/key.properties`:
   ```properties
   storePassword=<password>
   keyPassword=<password>
   keyAlias=upload
   storeFile=../../upload-keystore.jks
   ```

**Never commit keystore files or key.properties!**

## 🐛 Troubleshooting

### "API key not configured" error

**Solution:** Make sure you've created `app_config.dart` from the template and added a valid API key.

### "Failed to load acts" error

**Possible causes:**
1. Invalid API key
2. Backend server is down
3. Network connectivity issue

**Check:**
```bash
# Test backend health
curl https://constitution-vault-api.onrender.com/health
```

### Build fails with "app_config.dart not found"

**Solution:** You forgot step 2! Copy the template file and configure your API key.

## 🌐 Backend Configuration

**Production API:** `https://constitution-vault-api.onrender.com`

**Local Development:**
- Android Emulator: `http://10.0.2.2:8000`
- Android Device: `http://YOUR_PC_IP:8000` (get IP with `ipconfig` on Windows or `ifconfig` on macOS/Linux)
- iOS Simulator: `http://localhost:8000`

To use local backend, change `apiBaseUrl` in `app_config.dart`:
```dart
static const String apiBaseUrl = 'http://10.0.2.2:8000'; // for emulator
```

## 📞 Need Help?

- **Issues:** Open a GitHub issue
- **Questions:** Contact @unnatii14
- **Documentation:** Check README.md for app features

---

**Last Updated:** December 9, 2025
