import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';

/// Prayer Repository
/// Handles all prayer-related database operations
class PrayerRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Log a prayer as completed
  Future<bool> completePrayer({
    required String prayerName,
    required DateTime date,
    required String prayerTime,
    String? notes,
    String status = 'completed', // Default to 'completed' for backward compatibility
  }) async {
    try {
      final db = await _dbHelper.database;
      final dateStr = _formatDate(date);
      final now = DateTime.now().toIso8601String();

      await db.insert(
        'prayer_logs',
        {
          'prayer_name': prayerName,
          'prayer_date': dateStr,
          'prayer_time': prayerTime,
          'status': status, // Use the provided status
          'logged_at': now,
          'notes': notes,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return true;
    } catch (e) {
      debugPrint('Error completing prayer: $e');
      return false;
    }
  }

  /// Mark prayer as incomplete (remove from logs)
  Future<bool> incompletePrayer({
    required String prayerName,
    required DateTime date,
  }) async {
    try {
      final db = await _dbHelper.database;
      final dateStr = _formatDate(date);

      await db.delete(
        'prayer_logs',
        where: 'prayer_name = ? AND prayer_date = ?',
        whereArgs: [prayerName, dateStr],
      );

      return true;
    } catch (e) {
      debugPrint('Error marking prayer as incomplete: $e');
      return false;
    }
  }

  /// Check if a prayer is completed for a specific date
  Future<bool> isPrayerCompleted({
    required String prayerName,
    required DateTime date,
  }) async {
    try {
      final db = await _dbHelper.database;
      final dateStr = _formatDate(date);

      final result = await db.query(
        'prayer_logs',
        where: 'prayer_name = ? AND prayer_date = ? AND status != ?',
        whereArgs: [prayerName, dateStr, 'missed'],
      );

      return result.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking prayer completion: $e');
      return false;
    }
  }

  /// Get all completed prayers for a specific date
  Future<List<String>> getCompletedPrayers(DateTime date) async {
    try {
      final db = await _dbHelper.database;
      final dateStr = _formatDate(date);

      final result = await db.query(
        'prayer_logs',
        columns: ['prayer_name'],
        where: 'prayer_date = ? AND status != ?',
        whereArgs: [dateStr, 'missed'],
      );

      return result.map((row) => row['prayer_name'] as String).toList();
    } catch (e) {
      debugPrint('Error getting completed prayers: $e');
      return [];
    }
  }

  /// Get prayers with their statuses for a specific date
  Future<Map<String, String>> getPrayersWithStatus(DateTime date) async {
    try {
      final db = await _dbHelper.database;
      final dateStr = _formatDate(date);

      final result = await db.query(
        'prayer_logs',
        columns: ['prayer_name', 'status'],
        where: 'prayer_date = ?',
        whereArgs: [dateStr],
      );

      final Map<String, String> prayerStatuses = {};
      for (final row in result) {
        prayerStatuses[row['prayer_name'] as String] = row['status'] as String;
      }

      return prayerStatuses;
    } catch (e) {
      debugPrint('Error getting prayers with status: $e');
      return {};
    }
  }

  /// Get daily prayer statistics
  Future<Map<String, dynamic>> getDailyStats(DateTime date) async {
    try {
      final db = await _dbHelper.database;
      final dateStr = _formatDate(date);

      final result = await db.rawQuery('''
        SELECT 
          COUNT(*) as completed_count
        FROM prayer_logs
        WHERE prayer_date = ? AND status != 'missed'
      ''', [dateStr]);

      final completedCount = result.first['completed_count'] as int;
      final totalPrayers = 5; // Fajr, Dhuhr, Asr, Maghrib, Isha
      final percentage = totalPrayers > 0 ? (completedCount / totalPrayers) * 100 : 0.0;

      return {
        'date': dateStr,
        'total_prayers': totalPrayers,
        'completed_prayers': completedCount,
        'completion_percentage': percentage,
      };
    } catch (e) {
      debugPrint('Error getting daily stats: $e');
      return {
        'date': _formatDate(date),
        'total_prayers': 5,
        'completed_prayers': 0,
        'completion_percentage': 0.0,
      };
    }
  }

  /// Get prayer history for a date range
  Future<List<Map<String, dynamic>>> getPrayerHistory({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final db = await _dbHelper.database;
      final startStr = _formatDate(startDate);
      final endStr = _formatDate(endDate);

      final result = await db.rawQuery('''
        SELECT 
          prayer_date as date,
          COUNT(*) as completed_count,
          5 as total_prayers,
          (COUNT(*) * 100.0 / 5) as completion_percentage
        FROM prayer_logs
        WHERE prayer_date BETWEEN ? AND ? AND status != 'missed'
        GROUP BY prayer_date
        ORDER BY prayer_date DESC
      ''', [startStr, endStr]);

      return result;
    } catch (e) {
      debugPrint('Error getting prayer history: $e');
      return [];
    }
  }

  /// Get monthly statistics
  Future<Map<String, dynamic>> getMonthlyStats(int year, int month) async {
    try {
      final db = await _dbHelper.database;
      final startDate = DateTime(year, month, 1);
      final endDate = DateTime(year, month + 1, 0);
      
      final startStr = _formatDate(startDate);
      final endStr = _formatDate(endDate);

      final result = await db.rawQuery('''
        SELECT 
          COUNT(DISTINCT prayer_date) as total_days,
          COUNT(*) as total_completed,
          (COUNT(*) * 100.0 / (COUNT(DISTINCT prayer_date) * 5)) as avg_percentage
        FROM prayer_logs
        WHERE prayer_date BETWEEN ? AND ? AND status != 'missed'
      ''', [startStr, endStr]);

      if (result.isEmpty || result.first['total_days'] == 0) {
        return {
          'total_days': 0,
          'total_completed': 0,
          'avg_percentage': 0.0,
        };
      }

      return result.first;
    } catch (e) {
      debugPrint('Error getting monthly stats: $e');
      return {
        'total_days': 0,
        'total_completed': 0,
        'avg_percentage': 0.0,
      };
    }
  }

  /// Get all-time statistics
  Future<Map<String, dynamic>> getAllTimeStats() async {
    try {
      final db = await _dbHelper.database;

      final result = await db.rawQuery('''
        SELECT 
          COUNT(DISTINCT prayer_date) as total_days,
          COUNT(*) as total_completed,
          (COUNT(*) * 100.0 / (COUNT(DISTINCT prayer_date) * 5)) as avg_percentage
        FROM prayer_logs
        WHERE status != 'missed'
      ''');

      if (result.isEmpty || result.first['total_days'] == 0) {
        return {
          'total_days': 0,
          'total_completed': 0,
          'avg_percentage': 0.0,
        };
      }

      return result.first;
    } catch (e) {
      debugPrint('Error getting all-time stats: $e');
      return {
        'total_days': 0,
        'total_completed': 0,
        'avg_percentage': 0.0,
      };
    }
  }

  /// Get prayer completion streak (consecutive days)
  Future<int> getCurrentStreak() async {
    try {
      final db = await _dbHelper.database;
      
      // Get all dates with 5 completed prayers, ordered by date descending
      final result = await db.rawQuery('''
        SELECT prayer_date
        FROM prayer_logs
        WHERE status != 'missed'
        GROUP BY prayer_date
        HAVING COUNT(*) = 5
        ORDER BY prayer_date DESC
      ''');

      if (result.isEmpty) return 0;

      int streak = 0;
      DateTime? previousDate;

      for (final row in result) {
        final dateStr = row['prayer_date'] as String;
        final date = DateTime.parse(dateStr);

        if (previousDate == null) {
          // First date - check if it's today or yesterday
          final today = DateTime.now();
          final yesterday = today.subtract(const Duration(days: 1));
          
          if (_isSameDay(date, today) || _isSameDay(date, yesterday)) {
            streak = 1;
            previousDate = date;
          } else {
            break; // Streak is broken
          }
        } else {
          // Check if this date is exactly one day before previous date
          final expectedDate = previousDate.subtract(const Duration(days: 1));
          if (_isSameDay(date, expectedDate)) {
            streak++;
            previousDate = date;
          } else {
            break; // Streak is broken
          }
        }
      }

      return streak;
    } catch (e) {
      debugPrint('Error getting current streak: $e');
      return 0;
    }
  }

  /// Helper: Check if two dates are the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Helper: Format date to YYYY-MM-DD
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
