/// App-wide constants for BetterMuslim application
/// Contains configuration values, API endpoints, and static data
class AppConstants {
  AppConstants._(); // Private constructor to prevent instantiation

  // ============================================
  // APP INFORMATION
  // ============================================
  static const String appName = 'BetterMuslim';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Your spiritual companion for daily Islamic practices';

  // ============================================
  // DATABASE
  // ============================================
  static const String databaseName = 'bettermuslim.db';
  static const int databaseVersion = 1;

  // ============================================
  // API ENDPOINTS (if using remote data)
  // ============================================
  static const String baseUrl = 'https://api.alquran.cloud/v1';
  static const String hadithApiUrl = 'https://api.hadith.gading.dev';
  
  // API Endpoints
  static const String quranEndpoint = '/quran/en.asad';
  static const String surahEndpoint = '/surah';
  static const String hadithEndpoint = '/books';

  // ============================================
  // LOCAL STORAGE KEYS
  // ============================================
  static const String keyFirstLaunch = 'first_launch';
  static const String keyUserLocation = 'user_location';
  static const String keyCalculationMethod = 'calculation_method';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyLanguage = 'language';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLastSyncDate = 'last_sync_date';

  // ============================================
  // NOTIFICATION CHANNELS
  // ============================================
  static const String notificationChannelId = 'prayer_notifications';
  static const String notificationChannelName = 'Prayer Notifications';
  static const String notificationChannelDescription = 'Notifications for prayer times and reminders';

  // ============================================
  // PAGINATION
  // ============================================
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // ============================================
  // TIMEOUTS
  // ============================================
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ============================================
  // ANIMATION DURATIONS
  // ============================================
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // ============================================
  // UI CONSTANTS
  // ============================================
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultBorderRadius = 12.0;
  static const double cardElevation = 4.0;

  // ============================================
  // PRAYER CALCULATION METHODS
  // ============================================
  static const Map<String, String> calculationMethods = {
    'MWL': 'Muslim World League',
    'ISNA': 'Islamic Society of North America',
    'Egypt': 'Egyptian General Authority of Survey',
    'Makkah': 'Umm al-Qura University, Makkah',
    'Karachi': 'University of Islamic Sciences, Karachi',
    'Tehran': 'Institute of Geophysics, University of Tehran',
    'Jafari': 'Shia Ithna Ashari, Leva Research Institute, Qum',
  };

  // ============================================
  // LANGUAGES
  // ============================================
  static const Map<String, String> supportedLanguages = {
    'en': 'English',
    'ar': 'العربية',
    'ur': 'اردو',
  };

  // ============================================
  // DATE FORMATS
  // ============================================
  static const String dateFormat = 'EEEE, dd MMMM yyyy';
  static const String timeFormat = 'hh:mm a';
  static const String dateTimeFormat = 'dd/MM/yyyy hh:mm a';
  static const String hijriDateFormat = 'dd MMMM yyyy';

  // ============================================
  // VALIDATION
  // ============================================
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;

  // ============================================
  // ASSETS PATHS
  // ============================================
  static const String imagesPath = 'assets/images/';
  static const String audioPath = 'assets/audio/';
  static const String dataPath = 'assets/data/';

  // JSON Data Files
  static const String hadithsJsonPath = '${dataPath}hadiths.json';
  static const String ayahsJsonPath = '${dataPath}ayahs.json';
  static const String quizQuestionsJsonPath = '${dataPath}quiz_questions.json';
  static const String nasheedsJsonPath = '${dataPath}nasheeds.json';

  // ============================================
  // ERROR MESSAGES
  // ============================================
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'No internet connection. Please check your network.';
  static const String errorServer = 'Server error. Please try again later.';
  static const String errorDatabase = 'Database error. Please restart the app.';
  static const String errorLocation = 'Unable to get location. Please enable location services.';
  static const String errorPermission = 'Permission denied. Please grant required permissions.';

  // ============================================
  // SUCCESS MESSAGES
  // ============================================
  static const String successPrayerLogged = 'Prayer logged successfully!';
  static const String successSettingsSaved = 'Settings saved successfully!';
  static const String successDataSynced = 'Data synced successfully!';

  // ============================================
  // QUIZ CONSTANTS
  // ============================================
  static const int quizTimeLimit = 60; // seconds per question
  static const int quizPassingScore = 70; // percentage
  static const int quizQuestionsPerSession = 10;

  // ============================================
  // AUDIO PLAYER
  // ============================================
  static const double defaultVolume = 0.8;
  static const double minVolume = 0.0;
  static const double maxVolume = 1.0;

  // ============================================
  // CACHE
  // ============================================
  static const Duration cacheExpiration = Duration(days: 7);
  static const int maxCacheSize = 50 * 1024 * 1024; // 50 MB
}
