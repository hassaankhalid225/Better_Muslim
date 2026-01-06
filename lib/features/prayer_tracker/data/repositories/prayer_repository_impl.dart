import '../../domain/entities/prayer_log.dart';
import '../../domain/repositories/prayer_repository.dart';
import '../datasources/prayer_local_datasource.dart';
import '../models/prayer_log_model.dart';

/// Prayer Repository Implementation (Data Layer)
/// Implements the domain repository interface
/// Coordinates between data sources and converts models to entities
class PrayerRepositoryImpl implements PrayerRepository {
  final PrayerLocalDataSource localDataSource;

  PrayerRepositoryImpl({required this.localDataSource});

  @override
  Future<int> logPrayer(PrayerLog prayerLog) async {
    try {
      final model = PrayerLogModel.fromEntity(prayerLog);
      return await localDataSource.logPrayer(model);
    } catch (e) {
      throw Exception('Repository: Failed to log prayer - $e');
    }
  }

  @override
  Future<List<PrayerLog>> getPrayerLogsByDate(DateTime date) async {
    try {
      final models = await localDataSource.getPrayerLogsByDate(date);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Repository: Failed to get prayer logs by date - $e');
    }
  }

  @override
  Future<List<PrayerLog>> getPrayerLogsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final models = await localDataSource.getPrayerLogsByDateRange(
        startDate,
        endDate,
      );
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Repository: Failed to get prayer logs by date range - $e');
    }
  }

  @override
  Future<PrayerLog?> getPrayerLog(String prayerName, DateTime date) async {
    try {
      final model = await localDataSource.getPrayerLog(prayerName, date);
      return model?.toEntity();
    } catch (e) {
      throw Exception('Repository: Failed to get prayer log - $e');
    }
  }

  @override
  Future<int> updatePrayerStatus(int id, String status) async {
    try {
      return await localDataSource.updatePrayerStatus(id, status);
    } catch (e) {
      throw Exception('Repository: Failed to update prayer status - $e');
    }
  }

  @override
  Future<int> updatePrayerLog(PrayerLog prayerLog) async {
    try {
      final model = PrayerLogModel.fromEntity(prayerLog);
      return await localDataSource.updatePrayerLog(model);
    } catch (e) {
      throw Exception('Repository: Failed to update prayer log - $e');
    }
  }

  @override
  Future<int> deletePrayerLog(int id) async {
    try {
      return await localDataSource.deletePrayerLog(id);
    } catch (e) {
      throw Exception('Repository: Failed to delete prayer log - $e');
    }
  }

  @override
  Future<List<PrayerLog>> getAllPrayerLogs() async {
    try {
      final models = await localDataSource.getAllPrayerLogs();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Repository: Failed to get all prayer logs - $e');
    }
  }

  @override
  Future<List<PrayerLog>> getPrayerLogsByMonth(int year, int month) async {
    try {
      final models = await localDataSource.getPrayerLogsByMonth(year, month);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Repository: Failed to get prayer logs by month - $e');
    }
  }

  @override
  Future<Map<String, int>> getPrayerStatistics(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      return await localDataSource.getPrayerStatistics(startDate, endDate);
    } catch (e) {
      throw Exception('Repository: Failed to get prayer statistics - $e');
    }
  }

  @override
  Future<void> clearAllPrayerLogs() async {
    try {
      await localDataSource.clearAllPrayerLogs();
    } catch (e) {
      throw Exception('Repository: Failed to clear prayer logs - $e');
    }
  }
}
