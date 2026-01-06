import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_helper.dart';

/// App Initialization Service
/// Handles first launch detection and database initialization
class AppInitService {
  static const String _keyFirstLaunch = 'first_launch';
  static const String _keyDatabaseInitialized = 'database_initialized';
  static const String _keyAppVersion = 'app_version';

  /// Check if this is the first launch
  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyFirstLaunch) ?? true;
  }

  /// Mark first launch as complete
  static Future<void> markFirstLaunchComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFirstLaunch, false);
    await prefs.setString(_keyAppVersion, '1.0.0');
    await prefs.setInt('launch_count', 1);
  }

  /// Initialize app on first launch
  static Future<void> initializeApp() async {
    try {
      // Initialize database
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.database; // This creates the database if it doesn't exist

      // Mark database as initialized
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyDatabaseInitialized, true);
      await prefs.setString('initialized_at', DateTime.now().toIso8601String());

      debugPrint('✅ App initialized successfully');
    } catch (e) {
      debugPrint('❌ Error initializing app: $e');
      rethrow;
    }
  }

  /// Check if database is initialized
  static Future<bool> isDatabaseInitialized() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDatabaseInitialized) ?? false;
  }

  /// Get launch count
  static Future<int> getLaunchCount() async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt('launch_count') ?? 0;
    await prefs.setInt('launch_count', count + 1);
    return count + 1;
  }

  /// Get app version
  static Future<String> getAppVersion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAppVersion) ?? '1.0.0';
  }

  /// Reset app (for testing)
  static Future<void> resetApp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.deleteDatabase();
    
    debugPrint('✅ App reset successfully');
  }
}
