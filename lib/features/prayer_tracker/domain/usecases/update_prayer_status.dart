import '../repositories/prayer_repository.dart';

/// Use Case: Update Prayer Status
/// Updates the status of a logged prayer
class UpdatePrayerStatus {
  final PrayerRepository repository;

  UpdatePrayerStatus({required this.repository});

  /// Execute the use case
  /// 
  /// Parameters:
  /// - [id]: The ID of the prayer log to update
  /// - [status]: The new status (masjid, alone, qaza, missed)
  /// 
  /// Returns:
  /// - Number of rows affected (should be 1 for success)
  /// 
  /// Throws:
  /// - Exception if the operation fails or validation fails
  Future<int> call(int id, String status) async {
    // Business logic validation
    if (id <= 0) {
      throw Exception('Invalid prayer log ID');
    }

    if (!_isValidStatus(status)) {
      throw Exception('Invalid prayer status: $status');
    }

    // Delegate to repository
    final result = await repository.updatePrayerStatus(id, status);

    if (result == 0) {
      throw Exception('Prayer log not found or update failed');
    }

    return result;
  }

  /// Validate prayer status
  bool _isValidStatus(String status) {
    const validStatuses = ['pending', 'masjid', 'alone', 'qaza', 'missed'];
    return validStatuses.contains(status.toLowerCase());
  }
}
