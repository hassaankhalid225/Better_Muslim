import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../models/prayer_log_model.dart';

/// Local Data Source for Prayer Tracker
/// Handles all database operations for prayer logs
/// Implements CRUD operations using SQLite
abstract class PrayerLocalDataSource {
  /// Log a new prayer
  Future<int> logPrayer(PrayerLogModel prayerLog);

  /// Get all prayer logs for a specific date
  Future<List<PrayerLogModel>> getPrayerLogsByDate(DateTime date);

  /// Get prayer logs for a date range
  Future<List<PrayerLogModel>> getPrayerLogsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// Get a specific prayer log by prayer name and date
  Future<PrayerLogModel?> getPrayerLog(String prayerName, DateTime date);

  /// Update prayer log status
  Future<int> updatePrayerStatus(int id, String status);

  /// Update entire prayer log
  Future<int> updatePrayerLog(PrayerLogModel prayerLog);

  /// Delete prayer log
  Future<int> deletePrayerLog(int id);

  /// Get all prayer logs (for history)
  Future<List<PrayerLogModel>> getAllPrayerLogs();

  /// Get prayer logs for a specific month
  Future<List<PrayerLogModel>> getPrayerLogsByMonth(int year, int month);

  /// Get prayer statistics for a date range
  Future<Map<String, int>> getPrayerStatistics(
    DateTime startDate,
    DateTime endDate,
  );

  /// Clear all prayer logs
  Future<void> clearAllPrayerLogs();
}

/// Implementation of PrayerLocalDataSource
class PrayerLocalDataSourceImpl implements PrayerLocalDataSource {
  final DatabaseHelper databaseHelper;

  PrayerLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<int> logPrayer(PrayerLogModel prayerLog) async {
    try {
      final db = await databaseHelper.database;
      
      // Check if prayer log already exists for this prayer and date
      final existing = await getPrayerLog(
        prayerLog.prayerName,
        prayerLog.prayerDate,
      );

      if (existing != null) {
        // Update existing log
        return await updatePrayerLog(prayerLog.copyWith(id: existing.id));
      } else {
        // Insert new log
        return await db.insert(
          'prayer_logs',
          prayerLog.toDatabase(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    } catch (e) {
      throw Exception('Failed to log prayer: $e');
    }
  }

  @override
  Future<List<PrayerLogModel>> getPrayerLogsByDate(DateTime date) async {
    try {
      final db = await databaseHelper.database;
      final dateString = date.toIso8601String().split('T')[0];

      final List<Map<String, dynamic>> maps = await db.query(
        'prayer_logs',
        where: 'prayer_date = ?',
        whereArgs: [dateString],
        orderBy: 'prayer_time ASC',
      );

      return maps.map((map) => PrayerLogModel.fromDatabase(map)).toList();
    } catch (e) {
      throw Exception('Failed to get prayer logs by date: $e');
    }
  }

  @override
  Future<List<PrayerLogModel>> getPrayerLogsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final db = await databaseHelper.database;
      final startDateString = startDate.toIso8601String().split('T')[0];
      final endDateString = endDate.toIso8601String().split('T')[0];

      final List<Map<String, dynamic>> maps = await db.query(
        'prayer_logs',
        where: 'prayer_date BETWEEN ? AND ?',
        whereArgs: [startDateString, endDateString],
        orderBy: 'prayer_date DESC, prayer_time ASC',
      );

      return maps.map((map) => PrayerLogModel.fromDatabase(map)).toList();
    } catch (e) {
      throw Exception('Failed to get prayer logs by date range: $e');
    }
  }

  @override
  Future<PrayerLogModel?> getPrayerLog(String prayerName, DateTime date) async {
    try {
      final db = await databaseHelper.database;
      final dateString = date.toIso8601String().split('T')[0];

      final List<Map<String, dynamic>> maps = await db.query(
        'prayer_logs',
        where: 'prayer_name = ? AND prayer_date = ?',
        whereArgs: [prayerName, dateString],
        limit: 1,
      );

      if (maps.isEmpty) return null;
      return PrayerLogModel.fromDatabase(maps.first);
    } catch (e) {
      throw Exception('Failed to get prayer log: $e');
    }
  }

  @override
  Future<int> updatePrayerStatus(int id, String status) async {
    try {
      final db = await databaseHelper.database;
      return await db.update(
        'prayer_logs',
        {'status': status, 'logged_at': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Failed to update prayer status: $e');
    }
  }

  @override
  Future<int> updatePrayerLog(PrayerLogModel prayerLog) async {
    try {
      final db = await databaseHelper.database;
      return await db.update(
        'prayer_logs',
        prayerLog.toDatabase(),
        where: 'id = ?',
        whereArgs: [prayerLog.id],
      );
    } catch (e) {
      throw Exception('Failed to update prayer log: $e');
    }
  }

  @override
  Future<int> deletePrayerLog(int id) async {
    try {
      final db = await databaseHelper.database;
      return await db.delete(
        'prayer_logs',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Failed to delete prayer log: $e');
    }
  }

  @override
  Future<List<PrayerLogModel>> getAllPrayerLogs() async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'prayer_logs',
        orderBy: 'prayer_date DESC, prayer_time ASC',
      );

      return maps.map((map) => PrayerLogModel.fromDatabase(map)).toList();
    } catch (e) {
      throw Exception('Failed to get all prayer logs: $e');
    }
  }

  @override
  Future<List<PrayerLogModel>> getPrayerLogsByMonth(int year, int month) async {
    try {
      final startDate = DateTime(year, month, 1);
      final endDate = DateTime(year, month + 1, 0); // Last day of month
      return await getPrayerLogsByDateRange(startDate, endDate);
    } catch (e) {
      throw Exception('Failed to get prayer logs by month: $e');
    }
  }

  @override
  Future<Map<String, int>> getPrayerStatistics(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final db = await databaseHelper.database;
      final startDateString = startDate.toIso8601String().split('T')[0];
      final endDateString = endDate.toIso8601String().split('T')[0];

      // Get count of each status
      final List<Map<String, dynamic>> results = await db.rawQuery('''
        SELECT status, COUNT(*) as count
        FROM prayer_logs
        WHERE prayer_date BETWEEN ? AND ?
        GROUP BY status
      ''', [startDateString, endDateString]);

      final Map<String, int> statistics = {};
      for (final result in results) {
        statistics[result['status'] as String] = result['count'] as int;
      }

      return statistics;
    } catch (e) {
      throw Exception('Failed to get prayer statistics: $e');
    }
  }

  @override
  Future<void> clearAllPrayerLogs() async {
    try {
      final db = await databaseHelper.database;
      await db.delete('prayer_logs');
    } catch (e) {
      throw Exception('Failed to clear prayer logs: $e');
    }
  }
}
