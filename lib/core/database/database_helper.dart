import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../constants/app_constants.dart';

/// SQLite Database Helper for BetterMuslim app
/// Implements Singleton pattern for single database instance
/// Handles database creation, versioning, and migrations
class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  // Private constructor
  DatabaseHelper._internal();

  /// Get database instance (creates if doesn't exist)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDatabase() async {
    try {
      // Get the application documents directory
      final Directory documentsDirectory = await getApplicationDocumentsDirectory();
      final String path = join(documentsDirectory.path, AppConstants.databaseName);

      // Open/create the database
      return await openDatabase(
        path,
        version: AppConstants.databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onConfigure: _onConfigure,
      );
    } catch (e) {
      throw Exception('Failed to initialize database: $e');
    }
  }

  /// Configure database (enable foreign keys)
  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  /// Create database tables
  Future<void> _onCreate(Database db, int version) async {
    // Create prayer_logs table
    await db.execute('''
      CREATE TABLE prayer_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        prayer_name TEXT NOT NULL,
        prayer_date TEXT NOT NULL,
        prayer_time TEXT NOT NULL,
        status TEXT NOT NULL,
        logged_at TEXT NOT NULL,
        notes TEXT,
        UNIQUE(prayer_name, prayer_date)
      )
    ''');

    // Create daily_content table (for Ayah and Hadith)
    await db.execute('''
      CREATE TABLE daily_content (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content_type TEXT NOT NULL,
        content_date TEXT NOT NULL,
        arabic_text TEXT NOT NULL,
        translation TEXT NOT NULL,
        reference TEXT NOT NULL,
        is_favorite INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        UNIQUE(content_type, content_date)
      )
    ''');

    // Create quiz_results table
    await db.execute('''
      CREATE TABLE quiz_results (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        quiz_date TEXT NOT NULL,
        total_questions INTEGER NOT NULL,
        correct_answers INTEGER NOT NULL,
        score_percentage REAL NOT NULL,
        time_taken INTEGER NOT NULL,
        completed_at TEXT NOT NULL
      )
    ''');

    // Create quiz_answers table
    await db.execute('''
      CREATE TABLE quiz_answers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        quiz_result_id INTEGER NOT NULL,
        question_id INTEGER NOT NULL,
        question_text TEXT NOT NULL,
        selected_answer TEXT NOT NULL,
        correct_answer TEXT NOT NULL,
        is_correct INTEGER NOT NULL,
        FOREIGN KEY (quiz_result_id) REFERENCES quiz_results (id) ON DELETE CASCADE
      )
    ''');

    // Create user_settings table
    await db.execute('''
      CREATE TABLE user_settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        setting_key TEXT UNIQUE NOT NULL,
        setting_value TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Create prayer_times_cache table
    await db.execute('''
      CREATE TABLE prayer_times_cache (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cache_date TEXT UNIQUE NOT NULL,
        fajr_time TEXT NOT NULL,
        dhuhr_time TEXT NOT NULL,
        asr_time TEXT NOT NULL,
        maghrib_time TEXT NOT NULL,
        isha_time TEXT NOT NULL,
        sunrise_time TEXT,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        calculation_method TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Create favorites table (for Quran, Hadith, etc.)
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item_type TEXT NOT NULL,
        item_id TEXT NOT NULL,
        item_data TEXT NOT NULL,
        created_at TEXT NOT NULL,
        UNIQUE(item_type, item_id)
      )
    ''');

    // Create indexes for better query performance
    await db.execute('CREATE INDEX idx_prayer_logs_date ON prayer_logs(prayer_date)');
    await db.execute('CREATE INDEX idx_prayer_logs_name ON prayer_logs(prayer_name)');
    await db.execute('CREATE INDEX idx_daily_content_date ON daily_content(content_date)');
    await db.execute('CREATE INDEX idx_daily_content_type ON daily_content(content_type)');
    await db.execute('CREATE INDEX idx_quiz_results_date ON quiz_results(quiz_date)');
    await db.execute('CREATE INDEX idx_prayer_times_cache_date ON prayer_times_cache(cache_date)');
    await db.execute('CREATE INDEX idx_favorites_type ON favorites(item_type)');

    // Insert default settings
    await _insertDefaultSettings(db);
  }

  /// Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle future database migrations here
    if (oldVersion < 2) {
      // Example: Add new column in version 2
      // await db.execute('ALTER TABLE prayer_logs ADD COLUMN new_column TEXT');
    }
  }

  /// Insert default settings
  Future<void> _insertDefaultSettings(Database db) async {
    final now = DateTime.now().toIso8601String();
    
    final defaultSettings = [
      {'setting_key': 'calculation_method', 'setting_value': 'MWL', 'updated_at': now},
      {'setting_key': 'notifications_enabled', 'setting_value': 'true', 'updated_at': now},
      {'setting_key': 'language', 'setting_value': 'en', 'updated_at': now},
      {'setting_key': 'theme_mode', 'setting_value': 'dark', 'updated_at': now},
      {'setting_key': 'first_launch', 'setting_value': 'true', 'updated_at': now},
    ];

    for (final setting in defaultSettings) {
      await db.insert('user_settings', setting);
    }
  }

  /// Close database connection
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  /// Delete database (for testing or reset)
  Future<void> deleteDatabase() async {
    try {
      final Directory documentsDirectory = await getApplicationDocumentsDirectory();
      final String path = join(documentsDirectory.path, AppConstants.databaseName);
      
      await close();
      await databaseFactory.deleteDatabase(path);
    } catch (e) {
      throw Exception('Failed to delete database: $e');
    }
  }

  /// Clear all data from database (keep structure)
  Future<void> clearAllData() async {
    final db = await database;
    
    await db.transaction((txn) async {
      await txn.delete('prayer_logs');
      await txn.delete('daily_content');
      await txn.delete('quiz_results');
      await txn.delete('quiz_answers');
      await txn.delete('prayer_times_cache');
      await txn.delete('favorites');
      // Don't clear user_settings
    });
  }

  /// Get database path (for debugging)
  Future<String> getDatabasePath() async {
    final Directory documentsDirectory = await getApplicationDocumentsDirectory();
    return join(documentsDirectory.path, AppConstants.databaseName);
  }

  /// Check if database exists
  Future<bool> databaseExists() async {
    try {
      final String path = await getDatabasePath();
      return await databaseFactory.databaseExists(path);
    } catch (e) {
      return false;
    }
  }

  /// Get database size in bytes
  Future<int> getDatabaseSize() async {
    try {
      final String path = await getDatabasePath();
      final File file = File(path);
      if (await file.exists()) {
        return await file.length();
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  /// Vacuum database (optimize and reclaim space)
  Future<void> vacuum() async {
    final db = await database;
    await db.execute('VACUUM');
  }

  /// Execute raw query (for advanced operations)
  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<dynamic>? arguments]) async {
    final db = await database;
    return await db.rawQuery(sql, arguments);
  }

  /// Execute raw insert/update/delete
  Future<int> rawExecute(String sql, [List<dynamic>? arguments]) async {
    final db = await database;
    return await db.rawUpdate(sql, arguments);
  }
}
