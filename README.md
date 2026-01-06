# BetterMuslim - Your Spiritual Companion

[![Flutter](https://img.shields.io/badge/Flutter-3.10+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A comprehensive, production-ready Flutter application designed to help Muslims track their daily prayers, gain Islamic knowledge, and strengthen their spiritual journey. Built with Clean Architecture and modern development practices for a University Final Project.

## 📱 Features

### 🕌 Prayer Tracker
- **Manual Prayer Logging**: Log all 5 daily prayers + Tahajjud
- **Prayer Status Tags**: 
  - 🕌 Masjid (Congregation)
  - 👤 Alone
  - 🔄 Qaza (Make-up prayer)
  - ❌ Missed
- **Smart Notifications**: Reminders for prayer times and missed prayers
- **Automatic Prayer Times**: Location-based calculation using Adhan package

### 📊 Prayer History
- **Calendar View**: Interactive calendar showing prayer completion
- **Monthly Overview**: Statistics and trends
- **Gregorian & Islamic Dates**: Dual calendar support

### 📖 Daily Knowledge
- **Ayah of the Day**: Daily Quranic verses with translation
- **Hadith of the Day**: Authentic Hadith with references
- **Favorites**: Save your favorite verses and Hadiths
- **Share Feature**: Share wisdom with others

### 🎯 Islamic Quiz
- **Interactive Questions**: Test your Islamic knowledge
- **Multiple Categories**: History, Fiqh, Quran, Prophets
- **Score Tracking**: Monitor your progress
- **Detailed Explanations**: Learn from each question

### 📕 Quran Reader
- **Complete Quran**: All 114 Surahs
- **Arabic Text**: Beautiful Arabic typography
- **English Translation**: Side-by-side translation
- **Audio Recitation**: Listen to Quranic recitation

### 🎵 Nasheed Library
- **Curated Collection**: Spiritual Islamic nasheeds
- **Audio Player**: Play, pause, skip controls
- **Progress Bar**: Track playback
- **Playlist Management**: Create custom playlists

## 🏗️ Architecture

This project follows **Clean Architecture** principles with a **feature-driven modular structure**:

```
lib/
├── core/                    # Shared resources
│   ├── config/             # App configuration
│   ├── constants/          # Constants
│   ├── database/           # SQLite setup
│   ├── services/           # Core services
│   └── widgets/            # Shared widgets
│
└── features/               # Feature modules
    ├── dashboard/
    ├── prayer_tracker/
    ├── history/
    ├── daily_knowledge/
    ├── quiz/
    ├── quran/
    └── nasheed/
```

Each feature follows the **3-layer architecture**:

1. **Presentation Layer** (UI + BLoC)
2. **Domain Layer** (Business Logic)
3. **Data Layer** (Data Sources + Repositories)

## 🛠️ Tech Stack

| Category | Technology |
|----------|-----------|
| **Framework** | Flutter 3.10+ |
| **Language** | Dart 3.0+ |
| **State Management** | BLoC Pattern (flutter_bloc) |
| **Local Database** | SQLite (sqflite) |
| **Dependency Injection** | GetIt + Injectable |
| **Navigation** | GoRouter |
| **Islamic Features** | Adhan (prayer times) |
| **Location** | Geolocator |
| **Audio** | AudioPlayers |
| **Notifications** | flutter_local_notifications |
| **UI Components** | Google Fonts, Shimmer, Percent Indicator |

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.10 or higher)
- Dart SDK (3.0 or higher)
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/bettermuslim.git
   cd bettermuslim
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run code generation**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📐 SOLID Principles Applied

### Single Responsibility Principle (SRP)
- Each class has one reason to change
- Use cases handle single operations
- Widgets focus on UI rendering only

### Open/Closed Principle (OCP)
- Abstract repository interfaces
- Extensible through inheritance
- New features don't modify existing code

### Liskov Substitution Principle (LSP)
- Repository implementations are substitutable
- Data models extend domain entities correctly

### Interface Segregation Principle (ISP)
- Specific interfaces for each feature
- No forced implementation of unused methods

### Dependency Inversion Principle (DIP)
- Domain layer depends on abstractions
- Dependency injection for loose coupling
- Repository pattern for data abstraction

## 🎨 UI/UX Design

### Theme: "Spiritual Sanctuary"
- **Primary Color**: #0A0E21 (Deep Space Navy)
- **Accent Color**: #4FC3F7 (Bright Cyan)
- **Typography**: Poppins (English), Amiri (Arabic)
- **Design System**: Material 3 with custom components

### Key UI Features
- ✨ Smooth animations and transitions
- 🌙 Dark theme optimized for night use
- 📱 Responsive layout
- ♿ Accessibility support
- 🎨 Gradient effects and shadows

## 📊 Database Schema

### Prayer Logs Table
```sql
CREATE TABLE prayer_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  prayer_name TEXT NOT NULL,
  prayer_date TEXT NOT NULL,
  prayer_time TEXT NOT NULL,
  status TEXT NOT NULL,
  logged_at TEXT NOT NULL,
  notes TEXT,
  UNIQUE(prayer_name, prayer_date)
);
```

### Daily Content Table
```sql
CREATE TABLE daily_content (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  content_type TEXT NOT NULL,
  content_date TEXT NOT NULL,
  arabic_text TEXT NOT NULL,
  translation TEXT NOT NULL,
  reference TEXT NOT NULL,
  is_favorite INTEGER DEFAULT 0,
  created_at TEXT NOT NULL,
  UNIQUE(content_type, content_date)
);
```

[See DATABASE_SCHEMA.md for complete schema](docs/DATABASE_SCHEMA.md)

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=test_driver/app.dart
```

## 📦 Build

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 📝 Code Quality

- **Linting**: Strict analysis_options.yaml
- **Formatting**: dart format
- **Documentation**: Comprehensive inline comments
- **Type Safety**: Null safety enabled

## 🤝 Contributing

This is a university project, but suggestions are welcome!

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Your Name**
- University: [Your University]
- Course: [Your Course]
- Year: 2026

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Islamic scholars for authentic content
- Open source community for packages
- University professors for guidance

## 📞 Support

For questions or support:
- Email: your.email@example.com
- GitHub Issues: [Create an issue](https://github.com/yourusername/bettermuslim/issues)

---

**Made with ❤️ for the Muslim Ummah**

*"And when My servants ask you concerning Me - indeed I am near."* - Quran 2:186
