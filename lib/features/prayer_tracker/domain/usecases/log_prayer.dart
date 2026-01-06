import '../entities/prayer_log.dart';
import '../repositories/prayer_repository.dart';

/// Use Case: Log Prayer
/// Encapsulates the business logic for logging a prayer
/// Follows Single Responsibility Principle - one use case, one action
class LogPrayer {
  final PrayerRepository repository;

  LogPrayer({required this.repository});

  /// Execute the use case
  /// 
  /// Parameters:
  /// - [prayerLog]: The prayer log to be saved
  /// 
  /// Returns:
  /// - The ID of the inserted/updated prayer log
  /// 
  /// Throws:
  /// - Exception if the operation fails
  Future<int> call(PrayerLog prayerLog) async {
    // Business logic validation
    if (prayerLog.prayerName.isEmpty) {
      throw Exception('Prayer name cannot be empty');
    }

    if (!_isValidStatus(prayerLog.status)) {
      throw Exception('Invalid prayer status: ${prayerLog.status}');
    }

    // Delegate to repository
    return await repository.logPrayer(prayerLog);
  }

  /// Validate prayer status
  bool _isValidStatus(String status) {
    const validStatuses = ['pending', 'masjid', 'alone', 'qaza', 'missed'];
    return validStatuses.contains(status.toLowerCase());
  }
}
