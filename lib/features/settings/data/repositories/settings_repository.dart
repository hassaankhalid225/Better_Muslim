import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/settings_model.dart';

/// Settings Repository
/// Handles persistence of app settings using SharedPreferences
class SettingsRepository {
  static const String _settingsKey = 'app_settings';

  /// Save settings to local storage
  Future<void> saveSettings(SettingsModel settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(settings.toJson());
      await prefs.setString(_settingsKey, jsonString);
    } catch (e) {
      throw Exception('Failed to save settings: $e');
    }
  }

  /// Load settings from local storage
  Future<SettingsModel> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_settingsKey);

      if (jsonString == null) {
        // Return default settings if none exist
        return const SettingsModel();
      }

      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return SettingsModel.fromJson(jsonMap);
    } catch (e) {
      // Return default settings on error
      return const SettingsModel();
    }
  }

  /// Clear all settings (reset to defaults)
  Future<void> clearSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_settingsKey);
    } catch (e) {
      throw Exception('Failed to clear settings: $e');
    }
  }

  /// Update a specific notification setting
  Future<void> updateNotificationSetting(
    String settingName,
    bool value,
  ) async {
    final currentSettings = await loadSettings();
    SettingsModel updatedSettings;

    switch (settingName) {
      case 'prayerTimes':
        updatedSettings =
            currentSettings.copyWith(prayerTimesNotifications: value);
        break;
      case 'inspiringQuotes':
        updatedSettings =
            currentSettings.copyWith(inspiringQuotesNotifications: value);
        break;
      case 'quranReminders':
        updatedSettings =
            currentSettings.copyWith(quranRemindersNotifications: value);
        break;
      case 'communityEvents':
        updatedSettings =
            currentSettings.copyWith(communityEventsNotifications: value);
        break;
      case 'appUpdates':
        updatedSettings =
            currentSettings.copyWith(appUpdatesNotifications: value);
        break;
      default:
        return;
    }

    await saveSettings(updatedSettings);
  }

  /// Update app preference
  Future<void> updatePreference(String key, String value) async {
    final currentSettings = await loadSettings();
    SettingsModel updatedSettings;

    switch (key) {
      case 'language':
        updatedSettings = currentSettings.copyWith(language: value);
        break;
      case 'prayerCalculationMethod':
        updatedSettings =
            currentSettings.copyWith(prayerCalculationMethod: value);
        break;
      case 'adhanVoice':
        updatedSettings = currentSettings.copyWith(adhanVoice: value);
        break;
      default:
        return;
    }

    await saveSettings(updatedSettings);
  }
}
