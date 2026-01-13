# BetterMuslim App - Comprehensive Project Documentation

## 1. Project Overview
**App Name:** BetterMuslim
**Version:** 1.0.0
**Description:** A comprehensive Islamic lifestyle application designed to be a digital sanctuary for Muslims. It features prayer tracking, Quran reading, Islamic quizzes, daily knowledge, nasheed library, and detailed history tracking.
**Technology Stack:**
- **Framework:** Flutter (SDK ^3.10.3)
- **Language:** Dart
- **Architecture:** Clean Architecture (Feature-first)
- **State Management:** flutter_bloc
- **Dependency Injection:** get_it, injectable
- **Navigation:** go_router
- **Database:** sqflite

## 2. Directory Structure
The project follows a scalable Clean Architecture structure:
```
lib/
├── core/               # Shared logic, configs, and widgets
│   ├── config/         # Theme, colors, routes
│   ├── constants/      # App constants
│   ├── database/       # Local database setup
│   ├── repositories/   # Shared repositories
│   ├── services/       # Shared services
│   ├── utils/          # Helper functions
│   └── widgets/        # Reusable UI components
├── features/           # Feature-specific modules
│   ├── daily_knowledge/# Daily Hadith/Ayah feature
│   ├── dashboard/      # Main home screen & prayer tracking
│   ├── history/        # Prayer performance history
│   ├── nasheed/        # Islamic audio/video library
│   ├── prayer_tracker/ # Prayer logic module
│   ├── quiz/           # Islamic quiz feature
│   ├── quran/          # Quran reader feature
│   ├── settings/       # App settings & preferences
│   └── splash/         # Launch screen
└── main.dart           # App entry point
```

## 3. Features Detail

### 3.1. Dashboard (Home)
**File:** `lib/features/dashboard/presentation/pages/dashboard_page.dart`
- **Header:** Displays App Name "BetterMuslim", current Gregorian date, and current Hijri date (using `hijri` package).
- **Daily Progress:** A circular progress indicator showing the percentage of prayers completed for the day.
- **Prayer Cards:** detailed cards for Fajr, Dhuhr, Asr, Maghrib, and Isha.
  - shows prayer time.
  - shows current status (Pending, Masjid, Alone, Qaza, Missed).
- **Logging System:**
  - Users can tap a prayer to log its status.
  - Options: Masjid (Congregation), Alone, Qaza (Make Up), Missed.
  - visual indicators (colors/icons) for each status.
- **Persistence:** "Done" button saves the day's record to the local SQLite database.

### 3.2. Prayer History
**File:** `lib/features/history/presentation/pages/history_page.dart`
- **Calendar View:**
  - Toggle between Gregorian and Islamic (Hijri) calendars.
  - Monthly navigation.
  - Visual heat-map style indicators on days (Full Blue for all prayers, Light Blue for partial, Gray for none).
- **Day Detail:** Tapping a day shows the exact breakdown of prayers for that specific date.
- **Monthly Overview:**
  - Total prayers due.
  - Completed count.
  - Missed count.
  - Completion rate percentage.

### 3.3. Daily Knowledge
**File:** `lib/features/daily_knowledge/presentation/pages/daily_knowledge_page.dart`
**Data Source:** `assets/data/hadiths.json`
- **Content:** Displays a curated list of Hadiths (Prophetic traditions).
- **Data:** loaded from a JSON file containing ID, Source (e.g., Sahih Bukhari), Text, and Narrator.
- **UI:** Clean card-based layout to read and reflect on daily wisdom.

### 3.4. Islamic Quiz
**File:** `lib/features/quiz/presentation/pages/quiz_page.dart`
- **Format:** Daily 5-question quiz.
- **Interaction:**
  - Multiple choice questions.
  - Instant feedback on answer selection (Green for correct, Red for wrong).
- **Results:**
  - Score summary (e.g., "Perfect Score!", "Good Job!").
  - Review section showing user's answer vs correct answer with explanations.

### 3.5. Quran Reader
**File:** `lib/features/quran/presentation/pages/quran_page.dart` & `surah_reader_page.dart`
- **Surah List:**
  - Lists all Surahs.
  - Displays English name, Transliteration, Arabic name, Ayah count, and Revelation type (Meccan/Medinan).
- **Reader:**
  - Full text reading experience for selected Surah.

### 3.6. Nasheed Library
**File:** `lib/features/nasheed/presentation/pages/nasheed_page.dart`
- **Access:** Accessible via Settings.
- **Content:** Library of Islamic nasheeds and videos.
- **Features:** 
  - Thumbnail display with play overlay.
  - Title, Artist, Views, and Duration info.
  - Integration with `url_launcher` to open videos (e.g., YouTube).
- **Performance:** Implements lazy loading / pagination for the list.

### 3.7. Settings
**File:** `lib/features/settings/presentation/pages/settings_page.dart`
- **Notifications:** Toggles for Prayer Times, Inspiring Quotes, Quran Reminders, Community Events, App Updates.
- **Preferences:**
  - Language selection (English, Arabic, Urdu, etc.).
  - Prayer Calculation Method (ISNA, MWL, Makkah, etc.).
  - Adhan Voice selection.
- **Navigation:** Entry point to Nasheed Library.

## 4. Technical Dependencies
Key packages used in `pubspec.yaml`:
- **UI:** `google_fonts`, `flutter_svg`, `flutter_animate`, `shimmer`, `percent_indicator`.
- **Islamic Data:** `adhan` (Prayer times), `hijri` (Islamic calendar).
- **Functionality:** `sqflite` (Database), `shared_preferences` (Simple storage), `url_launcher`.
- **Architecture:** `flutter_bloc` (State mgmt), `injectable`/`get_it` (DI), `go_router` (Nav).

## 5. Assets
- **Data:** `assets/data/hadiths.json`
- **Icons:** Custom app icons and UI assets.

This document provides a comprehensive overview of the BetterMuslim application architecture, features, and implementation details.
