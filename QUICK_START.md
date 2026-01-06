# BetterMuslim - Quick Start Guide

## 🚀 Getting Started in 5 Minutes

### Prerequisites Checklist
- [ ] Flutter SDK 3.10+ installed
- [ ] Dart SDK 3.0+ installed
- [ ] Android Studio OR VS Code installed
- [ ] Android device/emulator OR iOS simulator
- [ ] Git installed

### Step 1: Clone & Setup (2 minutes)

```bash
# Clone the repository
git clone <your-repo-url>
cd bettermuslim

# Install dependencies
flutter pub get

# Run code generation
dart run build_runner build --delete-conflicting-outputs
```

### Step 2: Run the App (1 minute)

**For Android:**
```bash
flutter run -d android
```

**For iOS:**
```bash
flutter run -d ios
```

**For Web:**
```bash
flutter run -d chrome
```

### Step 3: Explore Features (2 minutes)

1. **Dashboard**: View daily prayer progress
2. **Prayer Cards**: Tap to log prayers
3. **Bottom Navigation**: Explore different sections

---

## 📱 App Features Overview

### 🕌 Dashboard
- Circular progress showing daily completion
- Prayer times with status indicators
- Gregorian and Hijri dates
- Beautiful dark theme UI

### 📊 Prayer Logging
Tap any prayer card to log:
- **Masjid** (Green) - Prayed in congregation
- **Alone** (Blue) - Prayed individually  
- **Qaza** (Orange) - Make-up prayer
- **Missed** (Red) - Prayer was missed

### 🎨 UI Highlights
- Smooth animations
- Gradient backgrounds
- Material Design 3
- Dark theme optimized

---

## 🏗️ Project Structure Quick Reference

```
lib/
├── core/                    # Shared resources
│   ├── config/theme/       # Colors, text styles, theme
│   ├── constants/          # App & prayer constants
│   ├── database/           # SQLite database helper
│   └── widgets/            # Reusable widgets
│
├── features/               # Feature modules
│   ├── dashboard/         # Home screen
│   └── prayer_tracker/    # Prayer tracking
│       ├── data/          # Data layer
│       ├── domain/        # Business logic
│       └── presentation/  # UI & BLoC
│
└── main.dart              # App entry point
```

---

## 🔧 Common Commands

### Development
```bash
# Run app
flutter run

# Hot reload (press 'r' in terminal)
# Hot restart (press 'R' in terminal)

# Run with specific device
flutter run -d <device-id>

# List devices
flutter devices
```

### Code Generation
```bash
# Generate code (JSON serialization, Injectable)
dart run build_runner build --delete-conflicting-outputs

# Watch mode (auto-generate on file changes)
dart run build_runner watch --delete-conflicting-outputs
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/prayer_tracker/domain/usecases/log_prayer_test.dart

# Run with coverage
flutter test --coverage
```

### Build
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

### Analysis
```bash
# Analyze code
flutter analyze

# Format code
dart format lib/

# Check for outdated packages
flutter pub outdated
```

---

## 📚 Key Files to Understand

### 1. main.dart
Entry point of the application. Initializes theme and navigation.

### 2. app_theme.dart
Complete Material 3 theme configuration with dark mode.

### 3. database_helper.dart
SQLite database setup with all tables and migrations.

### 4. prayer_bloc.dart
State management for prayer tracking using BLoC pattern.

### 5. dashboard_page.dart
Main UI screen matching Figma design.

---

## 🎯 Next Steps

### For Development
1. Complete the History module
2. Implement Daily Knowledge feature
3. Add Quiz functionality
4. Integrate Quran Reader
5. Add Nasheed Library

### For Learning
1. Study Clean Architecture in `IMPLEMENTATION_GUIDE.md`
2. Review SOLID principles application
3. Understand BLoC pattern implementation
4. Explore database schema design

### For Presentation
1. Review `PROJECT_SUMMARY.md`
2. Prepare demo scenarios
3. Highlight architecture decisions
4. Showcase SOLID principles

---

## 🐛 Troubleshooting

### Issue: Dependencies not installing
```bash
flutter clean
flutter pub get
```

### Issue: Code generation fails
```bash
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### Issue: App not running
```bash
flutter doctor
# Fix any issues shown
```

### Issue: Hot reload not working
```bash
# Press 'R' for hot restart instead of 'r'
# Or restart the app completely
```

---

## 📖 Documentation

| Document | Purpose |
|----------|---------|
| `README.md` | Project overview and features |
| `IMPLEMENTATION_GUIDE.md` | Detailed architecture and implementation |
| `PROJECT_STRUCTURE.md` | Folder structure explanation |
| `PROJECT_SUMMARY.md` | University project summary |
| `QUICK_START.md` | This guide |

---

## 💡 Tips for University Presentation

### Demo Flow
1. **Start**: Show dashboard with progress
2. **Log Prayer**: Demonstrate prayer logging
3. **Explain Architecture**: Show Clean Architecture layers
4. **Code Review**: Highlight SOLID principles
5. **Database**: Show SQLite schema
6. **Testing**: Demonstrate test coverage

### Key Points to Emphasize
- ✅ Clean Architecture implementation
- ✅ SOLID principles adherence
- ✅ BLoC state management
- ✅ Offline-first with SQLite
- ✅ Production-ready code quality
- ✅ Comprehensive documentation

### Questions to Prepare For
1. **Why Clean Architecture?**
   - Separation of concerns
   - Testability
   - Maintainability
   - Scalability

2. **Why BLoC over other state management?**
   - Clear separation of business logic
   - Predictable state transitions
   - Easy to test
   - Industry standard

3. **How does dependency injection work?**
   - GetIt service locator
   - Injectable code generation
   - Loose coupling
   - Easy testing

4. **Database design decisions?**
   - Normalized schema
   - Indexes for performance
   - Foreign keys for integrity
   - Migration support

---

## 🎓 Learning Resources

### Flutter
- [Flutter Documentation](https://flutter.dev/docs)
- [Flutter Cookbook](https://flutter.dev/docs/cookbook)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)

### Clean Architecture
- [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Clean Architecture](https://resocoder.com/2019/08/27/flutter-tdd-clean-architecture-course-1-explanation-project-structure/)

### BLoC Pattern
- [BLoC Library](https://bloclibrary.dev)
- [BLoC Pattern Explained](https://www.didierboelens.com/2018/08/reactive-programming-streams-bloc/)

### SOLID Principles
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID)
- [SOLID in Dart](https://medium.com/flutter-community/solid-principles-in-flutter-3c6f5c5d3e8e)

---

## ✅ Pre-Submission Checklist

- [ ] All dependencies installed (`flutter pub get`)
- [ ] Code generation completed (`build_runner`)
- [ ] App runs without errors
- [ ] Code is well-commented
- [ ] Documentation is complete
- [ ] README is updated
- [ ] Tests are written (if required)
- [ ] Code is formatted (`dart format`)
- [ ] No linting errors (`flutter analyze`)

---

## 📞 Support

If you encounter any issues:

1. Check the troubleshooting section above
2. Review the documentation
3. Run `flutter doctor` to check your setup
4. Check the GitHub issues (if applicable)

---

**Happy Coding! 🚀**

*May this project help you achieve excellence in your studies and contribute to the Muslim community.*

---

**Quick Links:**
- [Flutter Installation](https://flutter.dev/docs/get-started/install)
- [VS Code Flutter Extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)
- [Android Studio Setup](https://developer.android.com/studio)
