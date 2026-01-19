# 🏛️ Indian Constitution Vault

**Making Indian Law Accessible to Every Citizen - Now 100% Offline!**

A beautiful mobile and web application that helps you explore Indian laws easily. The mobile app is **fully offline** - all data is bundled locally for instant access without internet. Built with Flutter, featuring categorized law finder, comprehensive legal database, and intuitive navigation.

[![Flutter](https://img.shields.io/badge/Flutter-3.32.5-blue.svg)](https://flutter.dev/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.115.0-green.svg)](https://fastapi.tiangolo.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Offline](https://img.shields.io/badge/Mobile-100%25%20Offline-green.svg)](OFFLINE_IMPLEMENTATION.md)
[![Live Demo](https://img.shields.io/badge/Live%20Demo-Netlify-00C7B7?logo=netlify)](https://enchanting-queijadas-bcd393.netlify.app/)

## 🚀 New: Fully Offline Mobile App!

The mobile app now works **completely offline** with no internet required:
- ⚡ **50x faster** - Instant data access (<100ms vs 2-5s)
- 💰 **$0 cost** - No server hosting needed
- 🌐 **Works anywhere** - No internet needed
- 🔒 **Complete privacy** - All data stays on your device
- 📦 **Small size** - Only ~40MB with all data included

## 🌐 Live Demo

**Try it now:** 
(Join on Android
Testers can join your test using Google Play on Android
https://play.google.com/store/apps/details?id=com.indianlaw.indian_constitution_vault 

Join on the web
Testers can join your test on the web
https://play.google.com/apps/testing/com.indianlaw.indian_constitution_vault)

Available on:
- 📱 **Android**: Fully offline app - Download from releases
- 🌐 **Web**: Access instantly in your browser (online)
- 🍎 **iOS**: Coming soon

## 📱 Screenshots

<div align="center">

| Main Navigation | Law Finder | Browse Acts |
|:---:|:---:|:---:|
| ![Main Screen](app_ss/main_screen.jpg) | ![Law Finder](app_ss/law_guide.jpg) | ![Browse Acts](app_ss/section.jpg) |

| About Constitution | Section Details |
|:---:|:---:|
| ![About](app_ss/about.jpg) | ![Chat](app_ss/chat.jpg) |

</div>

## 🌟 Key Features

### 🎯 Core Capabilities
- **📚 Comprehensive Legal Database** - 5 major Indian legal acts with 2000+ sections
- **🔍 Law Finder** - Browse laws by categories (Criminal Law, Property Rights, Women's Rights, Cyber Crime, Consumer Rights, etc.)
- **📖 Browse Acts** - Explore all acts and their sections systematically
- **🌐 Bilingual Support** - Complete interface and content in English and Hindi
- **🎨 Beautiful UI** - Material Design 3 with gradient cards and smooth animations
- **🌐 Web & Mobile** - Access on any device - desktop, tablet, or mobile

### 📖 Legal Acts Covered
| Act | Year | Sections |
|-----|------|----------|
| Bharatiya Nyaya Sanhita (BNS) | 2023 | 358 |
| Bharatiya Nagarik Suraksha Sanhita (BNSS) | 2023 | 532 |
| Bharatiya Sakshya Adhiniyam (BSA) | 2023 | 170 |

### 🎯 Law Categories
- **⚖️ Criminal Law** - Offences, punishments & criminal procedures
- **🏠 Property Rights** - Land, property and ownership laws
- **♀️ Women's Rights** - Laws protecting women
- **💻 Cyber Crime** - Online and digital offences
- **🛒 Consumer Rights** - Shopping and consumer protection
- **📄 Documentation** - Legal documents and procedures
- **👨‍👩‍👧 Family Law** - Marriage, divorce and family matters
- **💼 Employment** - Labor laws and workplace rights

## 🛠️ Tech Stack

**Frontend:**
- Flutter 3.32.5 - Cross-platform framework (Web, Android, iOS)
- Riverpod - State management
- GoRouter - Navigation and routing
- Material Design 3 - Modern UI components

**Backend:**
- JSON Database - Structured legal data
- Uvicorn - ASGI server

**Deployment:**
- Netlify - Web hosting with CDN

## 🚀 Quick Start

### Platforms
- **📱 Mobile**: Android & iOS
- **🌐 Web**: Deploy to Netlify, Vercel, Firebase Hosting, etc.

### Prerequisites
- Flutter SDK 3.32.5+
- Python 3.10+ (for backend)
- Git

### Setup

**1. Backend:**
```bash
cd backend
pip install -r requirements.txt
python -m uvicorn app.main:app --reload
```

**2. Mobile:**
```bash
cd mobile
flutter pub get

# Update lib/config/app_config.dart with your backend URL and API key
dart run build_runner build --delete-conflicting-outputs
flutter run
```

**3. Web Deployment:**
```bash
cd mobile
flutter pub get
flutter build web --release

# Deploy to Netlify (see QUICK_START_NETLIFY.md for detailed guide)
```

## 📐 Architecture

```
Constitution_Website/
├── backend/
│   ├── app/
│   │   ├── main.py         # FastAPI routes
│   │   ├── data_loader.py  # Load legal data
│   │   └── models.py       # Data models
│   └── data/structured/    # Legal JSON database
├── mobile/
│   ├── lib/
│   │   ├── screens/        # UI screens (Law Finder, Acts, Sections)
│   │   ├── providers/      # State management
│   │   ├── models/         # Data models
│   │   └── services/       # API services
│   └── web/                # Web-specific files
└── .github/workflows/      # CI/CD for Netlify
```

## 🌍 Roadmap

- [x] Comprehensive legal database with 2000+ sections
- [x] Law Finder with categorized search
- [x] Bilingual support (English & Hindi)
- [x] Material Design 3 UI
- [x] Web application deployed on Netlify

## 🤝 Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) for details.

## 🙏 Acknowledgments

- Legal data from official Indian government sources
- Built with Flutter
- Icons from Material Design
- Hosted on Netlify & Render

---

<div align="center">

**Made with ❤️ for the people of India**

*Making law accessible, one section at a time.*

[⭐ Star this repo](https://github.com/unnatii14/Indian-Constitution-Vault) if you find it helpful!

</div>
