import '../entities/prayer_log.dart';

/// Prayer Repository Interface (Domain Layer)
/// Defines the contract for prayer data operations
/// This abstraction allows the domain layer to be independent of data sources
abstract class PrayerRepository {
  /// Log a new prayer
  Future<int> logPrayer(PrayerLog prayerLog);

  /// Get all prayer logs for a specific date
  Future<List<PrayerLog>> getPrayerLogsByDate(DateTime date);

  /// Get prayer logs for a date range
  Future<List<PrayerLog>> getPrayerLogsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// Get a specific prayer log
  Future<PrayerLog?> getPrayerLog(String prayerName, DateTime date);

  /// Update prayer status
  Future<int> updatePrayerStatus(int id, String status);

  /// Update prayer log
  Future<int> updatePrayerLog(PrayerLog prayerLog);

  /// Delete prayer log
  Future<int> deletePrayerLog(int id);

  /// Get all prayer logs
  Future<List<PrayerLog>> getAllPrayerLogs();

  /// Get prayer logs for a specific month
  Future<List<PrayerLog>> getPrayerLogsByMonth(int year, int month);

  /// Get prayer statistics
  Future<Map<String, int>> getPrayerStatistics(
    DateTime startDate,
    DateTime endDate,
  );

  /// Clear all prayer logs
  Future<void> clearAllPrayerLogs();
}
