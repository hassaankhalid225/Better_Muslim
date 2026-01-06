# Prayer Status Highlighting Fix

## Problem
When reopening the app, the progress percentage was displayed correctly (e.g., "4 of 5 prayers completed"), but all prayer cards showed gray indicators instead of their actual status colors (green for masjid, blue for alone, orange for qaza, red for missed).

## Root Cause
The issue had two parts:

### 1. Legacy Database Entries
Prayers logged before the fix were stored with a generic `'completed'` status instead of specific status values (`'masjid'`, `'alone'`, `'qaza'`, `'missed'`). This was because the old code hardcoded the status as `'completed'` in the database.

### 2. Missing Color Mapping
The `getPrayerStatusColor()` function didn't have a case for `'completed'`, so it defaulted to the gray "pending" color for all legacy entries.

## Solution

### Changes Made

#### 1. Added `getPrayersWithStatus()` Method
**File:** `lib/core/repositories/prayer_repository.dart`

```dart
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
```

This method retrieves both prayer names AND their statuses from the database, instead of just the prayer names.

#### 2. Updated `completePrayer()` Method
**File:** `lib/core/repositories/prayer_repository.dart`

```dart
Future<bool> completePrayer({
  required String prayerName,
  required DateTime date,
  required String prayerTime,
  String? notes,
  String status = 'completed', // Default for backward compatibility
}) async {
  // ... saves the actual status to database
  'status': status, // Use the provided status instead of hardcoding 'completed'
}
```

Added a `status` parameter so the actual prayer status (masjid, alone, qaza, missed) is saved to the database.

#### 3. Updated `_loadTodaysPrayers()` Method
**File:** `lib/features/dashboard/presentation/pages/dashboard_page.dart`

```dart
Future<void> _loadTodaysPrayers() async {
  final prayerStatuses = await _prayerRepo.getPrayersWithStatus(DateTime.now());
  
  setState(() {
    for (var prayer in _prayers) {
      final prayerName = prayer['name']!;
      if (prayerStatuses.containsKey(prayerName)) {
        // Restore the actual status from database
        prayer['status'] = prayerStatuses[prayerName]!;
      } else {
        // No record in database, keep as pending
        prayer['status'] = 'pending';
      }
    }
    _isLoading = false;
  });
}
```

Now properly restores the actual status values from the database.

#### 4. Updated `_logPrayer()` Method
**File:** `lib/features/dashboard/presentation/pages/dashboard_page.dart`

```dart
Future<void> _logPrayer(String prayerName, String status) async {
  // ... 
  
  // Save to database with the actual status
  if (status != 'pending') {
    await _prayerRepo.completePrayer(
      prayerName: prayerName,
      date: DateTime.now(),
      prayerTime: prayerTime,
      status: status, // Pass the actual status (masjid, alone, qaza, missed)
      notes: PrayerConstants.getStatusLabel(status),
    );
  }
  
  // ...
}
```

Now passes the actual status to the database instead of using the default.

#### 5. Added Backward Compatibility for Color Mapping
**File:** `lib/core/config/theme/app_colors.dart`

```dart
static Color getPrayerStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'masjid':
    case 'congregation':
    case 'completed': // Backward compatibility for old database entries
      return prayedInMasjid;
    case 'alone':
      return prayedAlone;
    case 'qaza':
      return prayedQaza;
    case 'missed':
      return prayedMissed;
    case 'pending':
    default:
      return prayedPending;
  }
}
```

Added `'completed'` case to map legacy database entries to green color (same as masjid).

## Result

✅ **Old prayers** (with `'completed'` status) now show green indicators  
✅ **New prayers** save with specific statuses (`'masjid'`, `'alone'`, `'qaza'`, `'missed'`)  
✅ **Prayer highlights** persist correctly when reopening the app  
✅ **Progress percentage** continues to work correctly  

## Testing

1. **For existing prayers:** Old prayers with `'completed'` status will now show green indicators
2. **For new prayers:** Log prayers with different statuses and verify:
   - Masjid → Green 🟢
   - Alone → Blue 🔵
   - Qaza → Orange 🟠
   - Missed → Red 🔴
   - Pending → Gray ⚪
3. **Persistence:** Close and reopen the app - all colors should remain the same

## Future Improvements

Consider adding a database migration to update all `'completed'` entries to `'masjid'` for consistency:

```dart
Future<void> migrateCompletedToMasjid() async {
  final db = await _dbHelper.database;
  await db.rawUpdate(
    "UPDATE prayer_logs SET status = 'masjid' WHERE status = 'completed'"
  );
}
```

This would eliminate the need for the backward compatibility case in the color mapping function.
