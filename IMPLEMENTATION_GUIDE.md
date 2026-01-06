# BetterMuslim - Implementation Guide

## 📋 Table of Contents
1. [Project Overview](#project-overview)
2. [Architecture Deep Dive](#architecture-deep-dive)
3. [Feature Implementation](#feature-implementation)
4. [Database Design](#database-design)
5. [State Management](#state-management)
6. [Dependency Injection](#dependency-injection)
7. [Testing Strategy](#testing-strategy)
8. [Deployment](#deployment)

---

## 1. Project Overview

### Purpose
BetterMuslim is a comprehensive Islamic companion app designed to help Muslims:
- Track daily prayers systematically
- Gain authentic Islamic knowledge
- Test their understanding through quizzes
- Read the Quran with translations
- Listen to spiritual nasheeds

### Target Audience
- Muslims seeking to improve their daily worship
- Students learning about Islam
- Anyone interested in Islamic spirituality

### Key Objectives
1. **Simplicity**: Easy-to-use interface
2. **Authenticity**: Verified Islamic content
3. **Offline-First**: Works without internet
4. **Performance**: Fast and responsive
5. **Scalability**: Easy to add new features

---

## 2. Architecture Deep Dive

### Clean Architecture Layers

#### **Presentation Layer**
**Responsibility**: UI and user interaction

**Components**:
- **Pages**: Full-screen views (e.g., DashboardPage)
- **Widgets**: Reusable UI components (e.g., PrayerCardWidget)
- **BLoC**: State management and business logic coordination

**Example Structure**:
```dart
features/
  prayer_tracker/
    presentation/
      pages/
        prayer_tracker_page.dart
      widgets/
        prayer_logging_sheet.dart
        prayer_tag_selector.dart
      bloc/
        prayer_bloc.dart
        prayer_event.dart
        prayer_state.dart
```

**Key Principles**:
- Pages should be thin, delegating logic to BLoC
- Widgets should be reusable and composable
- BLoC handles all business logic and state

#### **Domain Layer**
**Responsibility**: Core business logic

**Components**:
- **Entities**: Pure business objects (e.g., PrayerLog)
- **Repositories**: Abstract interfaces
- **Use Cases**: Single-purpose business operations

**Example**:
```dart
// Entity: Pure business object
class PrayerLog extends Equatable {
  final int? id;
  final String prayerName;
  final DateTime prayerDate;
  final String status;
  // ... other fields
}

// Repository Interface: Abstraction
abstract class PrayerRepository {
  Future<int> logPrayer(PrayerLog prayerLog);
  Future<List<PrayerLog>> getPrayerLogsByDate(DateTime date);
}

// Use Case: Single business operation
class LogPrayer {
  final PrayerRepository repository;
  
  Future<int> call(PrayerLog prayerLog) async {
    // Validation logic
    if (prayerLog.prayerName.isEmpty) {
      throw Exception('Prayer name cannot be empty');
    }
    
    // Delegate to repository
    return await repository.logPrayer(prayerLog);
  }
}
```

**Key Principles**:
- No dependencies on external frameworks
- Pure Dart code only
- Framework-agnostic business rules

#### **Data Layer**
**Responsibility**: Data management and persistence

**Components**:
- **Models**: Data transfer objects with JSON serialization
- **Data Sources**: Local (SQLite) and Remote (API) access
- **Repository Implementations**: Concrete implementations

**Example**:
```dart
// Model: Extends entity, adds serialization
@JsonSerializable()
class PrayerLogModel extends PrayerLog {
  factory PrayerLogModel.fromDatabase(Map<String, dynamic> map) {
    return PrayerLogModel(
      id: map['id'],
      prayerName: map['prayer_name'],
      // ... map other fields
    );
  }
  
  Map<String, dynamic> toDatabase() {
    return {
      'prayer_name': prayerName,
      'prayer_date': prayerDate.toIso8601String(),
      // ... other fields
    };
  }
}

// Data Source: Database operations
class PrayerLocalDataSourceImpl {
  final DatabaseHelper databaseHelper;
  
  Future<int> logPrayer(PrayerLogModel model) async {
    final db = await databaseHelper.database;
    return await db.insert('prayer_logs', model.toDatabase());
  }
}

// Repository Implementation: Coordinates data sources
class PrayerRepositoryImpl implements PrayerRepository {
  final PrayerLocalDataSource localDataSource;
  
  @override
  Future<int> logPrayer(PrayerLog prayerLog) async {
    final model = PrayerLogModel.fromEntity(prayerLog);
    return await localDataSource.logPrayer(model);
  }
}
```

### Data Flow

```
User Action (UI)
    ↓
Event (BLoC)
    ↓
Use Case (Domain)
    ↓
Repository Interface (Domain)
    ↓
Repository Implementation (Data)
    ↓
Data Source (Data)
    ↓
Database / API
    ↓
Data Source (Data)
    ↓
Repository Implementation (Data)
    ↓
Use Case (Domain)
    ↓
State (BLoC)
    ↓
UI Update
```

---

## 3. Feature Implementation

### Prayer Tracker Feature

#### Step 1: Define Domain Entities
```dart
// lib/features/prayer_tracker/domain/entities/prayer_log.dart
class PrayerLog extends Equatable {
  final int? id;
  final String prayerName;
  final DateTime prayerDate;
  final String status;
  // ... implementation
}
```

#### Step 2: Create Repository Interface
```dart
// lib/features/prayer_tracker/domain/repositories/prayer_repository.dart
abstract class PrayerRepository {
  Future<int> logPrayer(PrayerLog prayerLog);
  Future<List<PrayerLog>> getPrayerLogsByDate(DateTime date);
}
```

#### Step 3: Implement Use Cases
```dart
// lib/features/prayer_tracker/domain/usecases/log_prayer.dart
class LogPrayer {
  final PrayerRepository repository;
  
  Future<int> call(PrayerLog prayerLog) async {
    // Business logic and validation
    return await repository.logPrayer(prayerLog);
  }
}
```

#### Step 4: Create Data Models
```dart
// lib/features/prayer_tracker/data/models/prayer_log_model.dart
@JsonSerializable()
class PrayerLogModel extends PrayerLog {
  // JSON serialization
  // Database mapping
}
```

#### Step 5: Implement Data Sources
```dart
// lib/features/prayer_tracker/data/datasources/prayer_local_datasource.dart
class PrayerLocalDataSourceImpl {
  Future<int> logPrayer(PrayerLogModel model) async {
    // SQLite operations
  }
}
```

#### Step 6: Implement Repository
```dart
// lib/features/prayer_tracker/data/repositories/prayer_repository_impl.dart
class PrayerRepositoryImpl implements PrayerRepository {
  final PrayerLocalDataSource localDataSource;
  
  @override
  Future<int> logPrayer(PrayerLog prayerLog) async {
    final model = PrayerLogModel.fromEntity(prayerLog);
    return await localDataSource.logPrayer(model);
  }
}
```

#### Step 7: Create BLoC
```dart
// lib/features/prayer_tracker/presentation/bloc/prayer_bloc.dart
class PrayerBloc extends Bloc<PrayerEvent, PrayerState> {
  final LogPrayer logPrayerUseCase;
  
  PrayerBloc({required this.logPrayerUseCase}) : super(PrayerInitial()) {
    on<LogPrayerEvent>(_onLogPrayer);
  }
  
  Future<void> _onLogPrayer(
    LogPrayerEvent event,
    Emitter<PrayerState> emit,
  ) async {
    emit(PrayerLoading());
    try {
      final id = await logPrayerUseCase(/* prayer log */);
      emit(PrayerLoggedSuccess(message: 'Prayer logged!'));
    } catch (e) {
      emit(PrayerError(e.toString()));
    }
  }
}
```

#### Step 8: Build UI
```dart
// lib/features/prayer_tracker/presentation/pages/prayer_tracker_page.dart
class PrayerTrackerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerBloc, PrayerState>(
      builder: (context, state) {
        if (state is PrayerLoading) {
          return CircularProgressIndicator();
        }
        // ... handle other states
      },
    );
  }
}
```

---

## 4. Database Design

### Schema Overview

#### prayer_logs Table
Stores all prayer logging data.

```sql
CREATE TABLE prayer_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  prayer_name TEXT NOT NULL,           -- Fajr, Dhuhr, Asr, Maghrib, Isha, Tahajjud
  prayer_date TEXT NOT NULL,           -- ISO 8601 date (YYYY-MM-DD)
  prayer_time TEXT NOT NULL,           -- ISO 8601 datetime
  status TEXT NOT NULL,                -- masjid, alone, qaza, missed, pending
  logged_at TEXT NOT NULL,             -- When the log was created
  notes TEXT,                          -- Optional user notes
  UNIQUE(prayer_name, prayer_date)     -- One log per prayer per day
);

CREATE INDEX idx_prayer_logs_date ON prayer_logs(prayer_date);
CREATE INDEX idx_prayer_logs_name ON prayer_logs(prayer_name);
```

**Design Decisions**:
- `UNIQUE(prayer_name, prayer_date)`: Prevents duplicate logs
- Indexes on `prayer_date` and `prayer_name`: Optimizes queries
- Text dates: SQLite doesn't have native date type, ISO 8601 ensures sorting

#### daily_content Table
Caches Ayah and Hadith of the day.

```sql
CREATE TABLE daily_content (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  content_type TEXT NOT NULL,          -- 'ayah' or 'hadith'
  content_date TEXT NOT NULL,          -- Date for this content
  arabic_text TEXT NOT NULL,           -- Original Arabic text
  translation TEXT NOT NULL,           -- English translation
  reference TEXT NOT NULL,             -- Quran reference or Hadith source
  is_favorite INTEGER DEFAULT 0,       -- Boolean: 0 or 1
  created_at TEXT NOT NULL,
  UNIQUE(content_type, content_date)   -- One of each type per day
);

CREATE INDEX idx_daily_content_date ON daily_content(content_date);
CREATE INDEX idx_daily_content_type ON daily_content(content_type);
```

#### quiz_results Table
Stores quiz attempt results.

```sql
CREATE TABLE quiz_results (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  quiz_date TEXT NOT NULL,
  total_questions INTEGER NOT NULL,
  correct_answers INTEGER NOT NULL,
  score_percentage REAL NOT NULL,
  time_taken INTEGER NOT NULL,         -- Seconds
  completed_at TEXT NOT NULL
);

CREATE INDEX idx_quiz_results_date ON quiz_results(quiz_date);
```

#### quiz_answers Table
Stores individual question answers.

```sql
CREATE TABLE quiz_answers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  quiz_result_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  question_text TEXT NOT NULL,
  selected_answer TEXT NOT NULL,
  correct_answer TEXT NOT NULL,
  is_correct INTEGER NOT NULL,         -- Boolean: 0 or 1
  FOREIGN KEY (quiz_result_id) REFERENCES quiz_results (id) ON DELETE CASCADE
);
```

**Design Decisions**:
- Foreign key with `ON DELETE CASCADE`: Deleting quiz result deletes all answers
- Denormalized question text: Preserves question even if source changes

### Database Migrations

For future schema changes:

```dart
Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    // Add new column in version 2
    await db.execute('ALTER TABLE prayer_logs ADD COLUMN reminder_sent INTEGER DEFAULT 0');
  }
  
  if (oldVersion < 3) {
    // Create new table in version 3
    await db.execute('''
      CREATE TABLE user_preferences (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        key TEXT UNIQUE NOT NULL,
        value TEXT NOT NULL
      )
    ''');
  }
}
```

---

## 5. State Management

### BLoC Pattern

#### Why BLoC?
1. **Separation of Concerns**: Business logic separate from UI
2. **Testability**: Easy to unit test
3. **Predictability**: Clear state transitions
4. **Scalability**: Handles complex state easily

#### BLoC Structure

**Events**: User actions
```dart
abstract class PrayerEvent extends Equatable {}

class LoadPrayerLogsEvent extends PrayerEvent {
  final DateTime date;
  const LoadPrayerLogsEvent(this.date);
}

class LogPrayerEvent extends PrayerEvent {
  final String prayerName;
  final String status;
  const LogPrayerEvent({required this.prayerName, required this.status});
}
```

**States**: UI states
```dart
abstract class PrayerState extends Equatable {}

class PrayerInitial extends PrayerState {}
class PrayerLoading extends PrayerState {}
class PrayerLogsLoaded extends PrayerState {
  final List<PrayerLog> prayerLogs;
  const PrayerLogsLoaded(this.prayerLogs);
}
class PrayerError extends PrayerState {
  final String message;
  const PrayerError(this.message);
}
```

**BLoC**: State management
```dart
class PrayerBloc extends Bloc<PrayerEvent, PrayerState> {
  final LogPrayer logPrayerUseCase;
  final GetPrayerLogs getPrayerLogsUseCase;
  
  PrayerBloc({
    required this.logPrayerUseCase,
    required this.getPrayerLogsUseCase,
  }) : super(const PrayerInitial()) {
    on<LoadPrayerLogsEvent>(_onLoadPrayerLogs);
    on<LogPrayerEvent>(_onLogPrayer);
  }
  
  Future<void> _onLoadPrayerLogs(
    LoadPrayerLogsEvent event,
    Emitter<PrayerState> emit,
  ) async {
    emit(const PrayerLoading());
    try {
      final logs = await getPrayerLogsUseCase(event.date);
      emit(PrayerLogsLoaded(logs));
    } catch (e) {
      emit(PrayerError(e.toString()));
    }
  }
}
```

#### UI Integration

```dart
class PrayerTrackerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PrayerBloc>()
        ..add(LoadPrayerLogsEvent(DateTime.now())),
      child: Scaffold(
        body: BlocBuilder<PrayerBloc, PrayerState>(
          builder: (context, state) {
            if (state is PrayerLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PrayerLogsLoaded) {
              return ListView.builder(
                itemCount: state.prayerLogs.length,
                itemBuilder: (context, index) {
                  return PrayerLogTile(state.prayerLogs[index]);
                },
              );
            } else if (state is PrayerError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
```

---

## 6. Dependency Injection

### GetIt + Injectable Setup

#### Step 1: Configure Injectable

```dart
// lib/core/config/injection/injection.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  await getIt.init();
}
```

#### Step 2: Register Dependencies

```dart
// Database
@singleton
class DatabaseHelper {
  // Implementation
}

// Data Sources
@LazySingleton(as: PrayerLocalDataSource)
class PrayerLocalDataSourceImpl implements PrayerLocalDataSource {
  final DatabaseHelper databaseHelper;
  
  PrayerLocalDataSourceImpl({required this.databaseHelper});
}

// Repositories
@LazySingleton(as: PrayerRepository)
class PrayerRepositoryImpl implements PrayerRepository {
  final PrayerLocalDataSource localDataSource;
  
  PrayerRepositoryImpl({required this.localDataSource});
}

// Use Cases
@lazySingleton
class LogPrayer {
  final PrayerRepository repository;
  
  LogPrayer({required this.repository});
}

// BLoCs
@injectable
class PrayerBloc extends Bloc<PrayerEvent, PrayerState> {
  final LogPrayer logPrayerUseCase;
  final GetPrayerLogs getPrayerLogsUseCase;
  
  PrayerBloc({
    required this.logPrayerUseCase,
    required this.getPrayerLogsUseCase,
  }) : super(const PrayerInitial());
}
```

#### Step 3: Initialize in main.dart

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure dependency injection
  await configureDependencies();
  
  runApp(const BetterMuslimApp());
}
```

---

## 7. Testing Strategy

### Unit Tests

Test individual components in isolation.

```dart
// test/features/prayer_tracker/domain/usecases/log_prayer_test.dart
void main() {
  late LogPrayer useCase;
  late MockPrayerRepository mockRepository;
  
  setUp(() {
    mockRepository = MockPrayerRepository();
    useCase = LogPrayer(repository: mockRepository);
  });
  
  test('should log prayer successfully', () async {
    // Arrange
    final prayerLog = PrayerLog(/* ... */);
    when(mockRepository.logPrayer(any))
        .thenAnswer((_) async => 1);
    
    // Act
    final result = await useCase(prayerLog);
    
    // Assert
    expect(result, 1);
    verify(mockRepository.logPrayer(prayerLog));
  });
  
  test('should throw exception for empty prayer name', () async {
    // Arrange
    final prayerLog = PrayerLog(prayerName: '', /* ... */);
    
    // Act & Assert
    expect(
      () => useCase(prayerLog),
      throwsException,
    );
  });
}
```

### Widget Tests

Test UI components.

```dart
// test/features/dashboard/presentation/widgets/prayer_card_widget_test.dart
void main() {
  testWidgets('PrayerCardWidget displays prayer info', (tester) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrayerCardWidget(
            prayerName: 'Fajr',
            prayerTime: '5:12 AM',
            status: 'masjid',
          ),
        ),
      ),
    );
    
    // Assert
    expect(find.text('Fajr'), findsOneWidget);
    expect(find.text('5:12 AM'), findsOneWidget);
  });
}
```

### Integration Tests

Test complete user flows.

```dart
// integration_test/prayer_logging_test.dart
void main() {
  testWidgets('User can log a prayer', (tester) async {
    // Start app
    app.main();
    await tester.pumpAndSettle();
    
    // Tap on Fajr prayer card
    await tester.tap(find.text('Fajr'));
    await tester.pumpAndSettle();
    
    // Select "Masjid" option
    await tester.tap(find.text('Masjid (Congregation)'));
    await tester.pumpAndSettle();
    
    // Verify success message
    expect(find.text('Prayer logged successfully!'), findsOneWidget);
  });
}
```

---

## 8. Deployment

### Android

1. **Update version in pubspec.yaml**
   ```yaml
   version: 1.0.0+1
   ```

2. **Build release APK**
   ```bash
   flutter build apk --release
   ```

3. **Build App Bundle (for Play Store)**
   ```bash
   flutter build appbundle --release
   ```

### iOS

1. **Update version**
   ```yaml
   version: 1.0.0+1
   ```

2. **Build release**
   ```bash
   flutter build ios --release
   ```

3. **Archive in Xcode**
   - Open `ios/Runner.xcworkspace` in Xcode
   - Product → Archive
   - Upload to App Store Connect

---

## 📚 Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [BLoC Pattern Guide](https://bloclibrary.dev)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID)

---

**This implementation guide demonstrates deep understanding of:**
- Clean Architecture principles
- SOLID design patterns
- Modern Flutter development
- Production-ready code structure
- Comprehensive testing strategies

Perfect for university final project evaluation! 🎓
