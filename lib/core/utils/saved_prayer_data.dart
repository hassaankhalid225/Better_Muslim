/// Global storage for saved prayer data
/// In production, this would be replaced with SQLite database
class SavedPrayerData {
  static final Map<String, Map<String, dynamic>> _savedPrayers = {};

  /// Save prayers for a specific date
  static void savePrayersForDate(String dateKey, Map<String, dynamic> data) {
    _savedPrayers[dateKey] = data;
  }

  /// Get prayers for a specific date
  static Map<String, dynamic>? getPrayersForDate(String dateKey) {
    return _savedPrayers[dateKey];
  }

  /// Get all saved prayers
  static Map<String, Map<String, dynamic>> getAllPrayers() {
    return Map.from(_savedPrayers);
  }
 
  /// Clear all saved prayers
  static void clearAll() {
    _savedPrayers.clear();
  }

  /// Check if prayers exist for a date
  static bool hasDataForDate(String dateKey) {
    return _savedPrayers.containsKey(dateKey);
  }
}
