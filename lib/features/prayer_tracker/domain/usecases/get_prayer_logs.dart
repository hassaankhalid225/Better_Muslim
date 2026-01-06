import '../entities/prayer_log.dart';
import '../repositories/prayer_repository.dart';

/// Use Case: Get Prayer Logs
/// Retrieves prayer logs for a specific date
class GetPrayerLogs {
  final PrayerRepository repository;

  GetPrayerLogs({required this.repository});

  /// Execute the use case
  /// 
  /// Parameters:
  /// - [date]: The date for which to retrieve prayer logs
  /// 
  /// Returns:
  /// - List of prayer logs for the specified date
  /// 
  /// Throws:
  /// - Exception if the operation fails
  Future<List<PrayerLog>> call(DateTime date) async {
    // Business logic: Normalize date to remove time component
    final normalizedDate = DateTime(date.year, date.month, date.day);
    
    // Delegate to repository
    return await repository.getPrayerLogsByDate(normalizedDate);
  }
}
