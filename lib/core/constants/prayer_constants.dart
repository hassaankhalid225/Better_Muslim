/// Prayer-specific constants for BetterMuslim application
/// Contains prayer names, times, statuses, and related configurations
class PrayerConstants {
  PrayerConstants._(); // Private constructor to prevent instantiation

  // ============================================
  // PRAYER NAMES
  // ============================================
  static const String fajr = 'Fajr';
  static const String dhuhr = 'Dhuhr';
  static const String asr = 'Asr';
  static const String maghrib = 'Maghrib';
  static const String isha = 'Isha';
  static const String tahajjud = 'Tahajjud';

  /// List of all 5 daily prayers (excluding Tahajjud)
  static const List<String> dailyPrayers = [
    fajr,
    dhuhr,
    asr,
    maghrib,
    isha,
  ];

  /// List of all prayers including Tahajjud
  static const List<String> allPrayers = [
    fajr,
    dhuhr,
    asr,
    maghrib,
    isha,
    tahajjud,
  ];

  // ============================================
  // PRAYER STATUSES
  // ============================================
  static const String statusPending = 'pending';
  static const String statusMasjid = 'masjid';
  static const String statusAlone = 'alone';
  static const String statusQaza = 'qaza';
  static const String statusMissed = 'missed';

  /// All possible prayer statuses
  static const List<String> prayerStatuses = [
    statusPending,
    statusMasjid,
    statusAlone,
    statusQaza,
    statusMissed,
  ];

  // ============================================
  // PRAYER STATUS LABELS (User-friendly)
  // ============================================
  static const Map<String, String> statusLabels = {
    statusPending: 'Not Prayed Yet',
    statusMasjid: 'Prayed in Masjid',
    statusAlone: 'Prayed Alone',
    statusQaza: 'Prayed as Qaza',
    statusMissed: 'Missed',
  };

  // ============================================
  // PRAYER STATUS DESCRIPTIONS
  // ============================================
  static const Map<String, String> statusDescriptions = {
    statusMasjid: 'Prayed in congregation at the mosque',
    statusAlone: 'Prayed individually at home or elsewhere',
    statusQaza: 'Made up a previously missed prayer',
    statusMissed: 'Prayer time passed without praying',
    statusPending: 'Prayer time has not arrived yet',
  };

  // ============================================
  // PRAYER REWARDS (for progress calculation)
  // ============================================
  static const Map<String, int> prayerRewards = {
    statusMasjid: 100, // Full reward - Congregation
    statusAlone: 70,   // Good reward - Alone on time
    statusQaza: 40,    // Partial reward - Made up
    statusMissed: 0,   // No reward - Missed
    statusPending: 0,  // Not applicable
  };

  // ============================================
  // PRAYER ICONS (Material Icons names)
  // ============================================
  static const Map<String, String> prayerIcons = {
    fajr: 'wb_twilight',
    dhuhr: 'wb_sunny',
    asr: 'wb_sunny_outlined',
    maghrib: 'wb_twilight',
    isha: 'nights_stay',
    tahajjud: 'bedtime',
  };

  // ============================================
  // PRAYER ARABIC NAMES
  // ============================================
  static const Map<String, String> prayerArabicNames = {
    fajr: 'الفجر',
    dhuhr: 'الظهر',
    asr: 'العصر',
    maghrib: 'المغرب',
    isha: 'العشاء',
    tahajjud: 'التهجد',
  };

  // ============================================
  // PRAYER DESCRIPTIONS
  // ============================================
  static const Map<String, String> prayerDescriptions = {
    fajr: 'The pre-dawn prayer, offered before sunrise',
    dhuhr: 'The midday prayer, offered after the sun passes its zenith',
    asr: 'The afternoon prayer, offered in the late afternoon',
    maghrib: 'The sunset prayer, offered just after sunset',
    isha: 'The night prayer, offered after twilight has disappeared',
    tahajjud: 'The optional night prayer, offered in the last third of the night',
  };

  // ============================================
  // PRAYER RAKATS (Units of prayer)
  // ============================================
  static const Map<String, Map<String, int>> prayerRakats = {
    fajr: {'sunnah': 2, 'fard': 2},
    dhuhr: {'sunnah': 4, 'fard': 4, 'sunnah_after': 2},
    asr: {'sunnah': 4, 'fard': 4},
    maghrib: {'fard': 3, 'sunnah': 2},
    isha: {'sunnah': 4, 'fard': 4, 'sunnah_after': 2, 'witr': 3},
    tahajjud: {'nafl': 8}, // Can vary
  };

  // ============================================
  // NOTIFICATION SETTINGS
  // ============================================
  /// Minutes before prayer time to send notification
  static const int notificationBeforeMinutes = 10;
  
  /// Minutes after prayer time to send reminder for missed prayer
  static const int missedPrayerReminderMinutes = 30;

  // ============================================
  // PROGRESS CALCULATION
  // ============================================
  /// Total prayers per day (5 daily prayers)
  static const int totalDailyPrayers = 5;
  
  /// Maximum daily score (if all prayers in Masjid)
  static const int maxDailyScore = 500; // 5 prayers × 100 points
  
  /// Minimum passing score percentage
  static const int passingScorePercentage = 60;

  // ============================================
  // QIBLA DIRECTION
  // ============================================
  /// Kaaba coordinates (for Qibla calculation)
  static const double kaabaLatitude = 21.4225;
  static const double kaabaLongitude = 39.8262;

  // ============================================
  // HELPER METHODS
  // ============================================
  
  /// Get prayer index (0-4 for daily prayers, 5 for Tahajjud)
  static int getPrayerIndex(String prayerName) {
    return allPrayers.indexOf(prayerName);
  }

  /// Check if prayer is a daily prayer (excluding Tahajjud)
  static bool isDailyPrayer(String prayerName) {
    return dailyPrayers.contains(prayerName);
  }

  /// Get prayer name by index
  static String getPrayerByIndex(int index) {
    if (index >= 0 && index < allPrayers.length) {
      return allPrayers[index];
    }
    return fajr; // Default
  }

  /// Get next prayer name
  static String getNextPrayer(String currentPrayer) {
    final index = getPrayerIndex(currentPrayer);
    if (index >= 0 && index < dailyPrayers.length - 1) {
      return dailyPrayers[index + 1];
    }
    return fajr; // Loop back to Fajr
  }

  /// Calculate progress percentage based on status
  static double calculateProgress(String status) {
    final reward = prayerRewards[status] ?? 0;
    return (reward / 100.0) * 100.0; // Convert to percentage
  }

  /// Get status label
  static String getStatusLabel(String status) {
    return statusLabels[status] ?? 'Unknown';
  }

  /// Get prayer Arabic name
  static String getArabicName(String prayerName) {
    return prayerArabicNames[prayerName] ?? prayerName;
  }

  /// Get prayer description
  static String getDescription(String prayerName) {
    return prayerDescriptions[prayerName] ?? '';
  }

  /// Check if status is completed (prayed in any form)
  static bool isCompleted(String status) {
    return status == statusMasjid || 
           status == statusAlone || 
           status == statusQaza;
  }

  /// Check if status is missed
  static bool isMissed(String status) {
    return status == statusMissed;
  }

  /// Check if status is pending
  static bool isPending(String status) {
    return status == statusPending;
  }
}
