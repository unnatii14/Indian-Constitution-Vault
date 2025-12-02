# 🏛️ Indian Constitution Vault

**Making Indian Law Accessible to Every Citizen**

A bilingual (English & Hindi) mobile application powered by AI to help common people understand Indian laws in simple language.

[![Flutter](https://img.shields.io/badge/Flutter-3.32.5-blue.svg)](https://flutter.dev/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.115.0-green.svg)](https://fastapi.tiangolo.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## 🌟 Features

### 🧭 Dual Navigation Interface
- **Browse Laws** - Explore all legal acts and sections with beautiful gradient cards
- **AI Legal Assistant** - Chat with an ethical AI chatbot about legal concepts
- **About Constitution** - Learn about India's constitutional history and the visionaries who created it
- Smooth navigation with clear separation of features
- Educational disclaimer on every screen

### 📚 Comprehensive Legal Database
- **Bharatiya Nyaya Sanhita (BNS) 2023** - 358 sections
- **Bharatiya Nagarik Suraksha Sanhita (BNSS) 2023** - 532 sections  
- **Bharatiya Sakshya Adhiniyam (BSA) 2023** - 170 sections
- **Code of Criminal Procedure (CRPC) 1973** - 533 sections
- **Indian Penal Code (IPC) 1860** - 515 sections

### 🤖 AI-Powered Features
- **Section Explanations** - Get complex legal sections explained in simple words
- **Ethical Chatbot** - Ask questions about laws in natural language
- **Safety-First Design** - Built-in ethical constraints (no legal advice, no political bias)
- Available in both **English** and **Hindi**
- Real-world examples for better understanding
- Powered by **Google Gemini 2.5 Flash**

### 🔒 Ethical AI Guidelines
- ✅ Educational information only, not legal advice
- ✅ Clear disclaimers on every response
- ✅ Automatic filtering of prohibited questions
- ✅ No storage of personal legal details
- ✅ Politically neutral and fact-based
- ✅ Encourages consultation with qualified lawyers

### 🎨 Beautiful Modern UI
- Material Design 3
- Gradient cards for visual appeal
- Smooth animations and transitions
- Responsive design for all screen sizes
- Search functionality across sections
- Splash screen and onboarding flow

### 🌐 Bilingual Support
- Complete Hindi translations for new laws
- Toggle between English and Hindi explanations
- Accessible to Hindi-speaking citizens

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** (3.32.5 or higher)
- **Python** (3.10 or higher)
- **Google Gemini API Key** ([Get it here](https://aistudio.google.com/app/apikey))

### Backend Setup

1. **Navigate to backend directory:**
   ```bash
   cd backend
   ```

2. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

3. **Create `.env` file:**
   ```bash
   GEMINI_API_KEY=your_api_key_here
   ```

4. **Start the server:**
   ```bash
   python -m uvicorn app.main:app --reload
   ```

   Server will run at `http://localhost:8000`

### Mobile App Setup

1. **Navigate to mobile directory:**
   ```bash
   cd mobile
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate model files:**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app:**
   ```bash
   flutter run -d chrome  # For web
   flutter run -d android # For Android
   flutter run -d ios     # For iOS
   ```

## 🏗️ Architecture

### Backend (FastAPI)
```
backend/
├── app/
│   ├── main.py           # FastAPI application & routes
│   ├── models.py         # Pydantic models
│   ├── data_loader.py    # Legal data loader
│   └── ai_service.py     # Gemini AI integration
├── data/
│   └── structured/       # JSON legal data files
├── requirements.txt
└── .env
```

### Mobile (Flutter)
```
mobile/
├── lib/
│   ├── main.dart                  # App entry point & routing
│   ├── models/                    # Data models (Freezed)
│   ├── providers/                 # Riverpod providers
│   ├── screens/
│   │   ├── splash_screen.dart     # App splash screen
│   │   ├── onboarding_screen.dart # First-time user flow
│   │   ├── main_navigation_screen.dart # Dual option screen
│   │   ├── acts_list_screen.dart  # Browse all laws
│   │   ├── sections_list_screen.dart
│   │   ├── section_detail_screen.dart
│   │   ├── ai_explanation_screen.dart
│   │   └── chatbot_screen.dart    # Ethical AI chatbot
│   └── services/                  # API services
└── pubspec.yaml
```

## 🔌 API Endpoints

### Legal Data
- `GET /acts` - List all acts
- `GET /acts/{act_id}/sections` - Get sections for an act
- `GET /acts/{act_id}/sections/{section_number}` - Get section detail

### AI Features
- `POST /api/explain` - Get AI explanation for a section
  ```json
  {
    "section_text": "string",
    "language": "en",
    "include_examples": true
  }
  ```
- `POST /api/chat` - Chat with ethical legal AI assistant
  ```json
  {
    "question": "string",
    "language": "en",
    "context": "optional"
  }
  ```

### System
- `GET /health` - Health check

## 🛠️ Tech Stack

### Frontend
- **Flutter** - Cross-platform UI framework
- **Riverpod** - State management
- **Freezed** - Immutable data classes
- **GoRouter** - Navigation
- **HTTP** - API calls

### Backend
- **FastAPI** - Modern Python web framework
- **Google Gemini AI** - AI explanations
- **Python-dotenv** - Environment management
- **Uvicorn** - ASGI server

## 🌍 Roadmap

- [x] AI-powered section explanations
- [x] Ethical AI chatbot with safety constraints
- [x] Bilingual support (English & Hindi)
- [x] Beautiful Material Design 3 UI
- [x] Splash screen and onboarding
- [ ] Voice-to-voice feature (speech recognition + text-to-speech)
- [ ] Multi-language support (regional languages)
- [ ] Real-world legal scenarios database
- [ ] Offline mode with local caching
- [ ] Bookmarks & favorites
- [ ] Share functionality
- [ ] Constitution articles support
- [ ] Supreme Court judgments integration

## 📚 Documentation

- [About Constitution Section](docs/ABOUT_CONSTITUTION_SECTION.md) - Historical information and educational content about India's Constitution
- [Ethical AI Chatbot Guidelines](docs/ETHICAL_AI_CHATBOT.md) - Comprehensive safety and ethical design documentation
- [AI Setup & Success Report](docs/AI_SUCCESS_REPORT.md) - Implementation details and testing results

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Legal data sourced from official government publications
- AI powered by Google Gemini
- Icons from Material Design Icons
- Special thanks to the Flutter and FastAPI communities

---

**Made with ❤️ for the people of India**

*Making law accessible, one section at a time.*
