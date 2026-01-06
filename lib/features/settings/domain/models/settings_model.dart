import 'package:equatable/equatable.dart';

/// Settings Model
/// Represents all app settings and preferences
class SettingsModel extends Equatable {
  // Notification Settings
  final bool prayerTimesNotifications;
  final bool inspiringQuotesNotifications;
  final bool quranRemindersNotifications;
  final bool communityEventsNotifications;
  final bool appUpdatesNotifications;

  // App Preferences
  final String language;
  final String prayerCalculationMethod;
  final String adhanVoice;

  const SettingsModel({
    this.prayerTimesNotifications = true,
    this.inspiringQuotesNotifications = true,
    this.quranRemindersNotifications = false,
    this.communityEventsNotifications = true,
    this.appUpdatesNotifications = true,
    this.language = 'English',
    this.prayerCalculationMethod = 'ISNA',
    this.adhanVoice = 'Al-Makkah',
  });

  /// Create a copy with updated values
  SettingsModel copyWith({
    bool? prayerTimesNotifications,
    bool? inspiringQuotesNotifications,
    bool? quranRemindersNotifications,
    bool? communityEventsNotifications,
    bool? appUpdatesNotifications,
    String? language,
    String? prayerCalculationMethod,
    String? adhanVoice,
  }) {
    return SettingsModel(
      prayerTimesNotifications:
          prayerTimesNotifications ?? this.prayerTimesNotifications,
      inspiringQuotesNotifications:
          inspiringQuotesNotifications ?? this.inspiringQuotesNotifications,
      quranRemindersNotifications:
          quranRemindersNotifications ?? this.quranRemindersNotifications,
      communityEventsNotifications:
          communityEventsNotifications ?? this.communityEventsNotifications,
      appUpdatesNotifications:
          appUpdatesNotifications ?? this.appUpdatesNotifications,
      language: language ?? this.language,
      prayerCalculationMethod:
          prayerCalculationMethod ?? this.prayerCalculationMethod,
      adhanVoice: adhanVoice ?? this.adhanVoice,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'prayerTimesNotifications': prayerTimesNotifications,
      'inspiringQuotesNotifications': inspiringQuotesNotifications,
      'quranRemindersNotifications': quranRemindersNotifications,
      'communityEventsNotifications': communityEventsNotifications,
      'appUpdatesNotifications': appUpdatesNotifications,
      'language': language,
      'prayerCalculationMethod': prayerCalculationMethod,
      'adhanVoice': adhanVoice,
    };
  }

  /// Create from JSON
  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      prayerTimesNotifications: json['prayerTimesNotifications'] ?? true,
      inspiringQuotesNotifications: json['inspiringQuotesNotifications'] ?? true,
      quranRemindersNotifications: json['quranRemindersNotifications'] ?? false,
      communityEventsNotifications:
          json['communityEventsNotifications'] ?? true,
      appUpdatesNotifications: json['appUpdatesNotifications'] ?? true,
      language: json['language'] ?? 'English',
      prayerCalculationMethod: json['prayerCalculationMethod'] ?? 'ISNA',
      adhanVoice: json['adhanVoice'] ?? 'Al-Makkah',
    );
  }

  @override
  List<Object?> get props => [
        prayerTimesNotifications,
        inspiringQuotesNotifications,
        quranRemindersNotifications,
        communityEventsNotifications,
        appUpdatesNotifications,
        language,
        prayerCalculationMethod,
        adhanVoice,
      ];
}
