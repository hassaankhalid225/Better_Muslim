# Prayer Dashboard & History Fixes

## Issues Fixed

### 1. **Progress Calculation Issue**
**Problem:** The progress counter was counting "missed" prayers as completed prayers.
- Example: If you had 4 prayers prayed and 1 missed, it showed "5 of 5 prayers completed" instead of "4 of 5 prayers completed"

**Solution:** Updated `_calculateProgress()` and `_getCompletedPrayers()` methods to exclude missed prayers:

```dart
double _calculateProgress() {
  // Only count prayers that were actually prayed (not missed or pending)
  int completed = _prayers.where((p) {
    final status = p['status']!;
    return status != 'pending' && status != 'missed';
  }).length;
  return (completed / _prayers.length) * 100;
}
```

### 2. **Missed Prayers Not Being Logged**
**Problem:** When clicking "Missed", the prayer was being saved to the database, which was correct, but it was being counted as "completed" in statistics.

**Solution:** Missed prayers are now properly saved to the database with `status = 'missed'`, and all statistics queries exclude them from the completed count.

### 3. **History Page Showing Incorrect Statistics**
**Problem:** The history page was counting missed prayers as completed prayers in:
- Daily statistics
- Monthly overview
- Completion percentages
- Streak calculations

**Solution:** Updated all database queries in `prayer_repository.dart` to use `status != 'missed'` instead of `status = 'completed'`:

#### Updated Methods:
1. **`getDailyStats()`** - Daily prayer statistics
2. **`getPrayerHistory()`** - Prayer history for date range
3. **`getMonthlyStats()`** - Monthly statistics
4. **`getAllTimeStats()`** - All-time statistics
5. **`getCurrentStreak()`** - Consecutive days streak
6. **`getCompletedPrayers()`** - List of completed prayers
7. **`isPrayerCompleted()`** - Check if prayer is completed

## How It Works Now

### Prayer Status Flow

1. **User logs a prayer:**
   - Masjid → Saved as `'masjid'` → Counted as completed ✅
   - Alone → Saved as `'alone'` → Counted as completed ✅
   - Qaza → Saved as `'qaza'` → Counted as completed ✅
   - Missed → Saved as `'missed'` → NOT counted as completed ❌

2. **Progress Calculation:**
   - Only counts: `'masjid'`, `'alone'`, `'qaza'`, `'completed'` (legacy)
   - Excludes: `'missed'`, `'pending'`

3. **History Display:**
   - Shows correct completion percentages
   - Missed prayers are tracked but not counted as completed
   - Monthly overview shows accurate statistics

### Database Queries

All queries now use this pattern:
```sql
WHERE status != 'missed'  -- Excludes missed prayers
```

Instead of the old pattern:
```sql
WHERE status = 'completed'  -- Only included legacy entries
```

## Examples

### Example 1: Daily Progress
**Scenario:** User prays 4 prayers and misses 1

**Before Fix:**
- Progress: "5 of 5 prayers completed" (100%)
- All 5 prayers counted as completed

**After Fix:**
- Progress: "4 of 5 prayers completed" (80%)
- Only 4 actually prayed prayers counted

### Example 2: History Page
**Scenario:** Month with 30 days, user prays 4/5 prayers each day (misses 1 daily)

**Before Fix:**
- Monthly Overview: 150/150 prayers completed (100%)
- All days show 5/5

**After Fix:**
- Monthly Overview: 120/150 prayers completed (80%)
- All days show 4/5
- 30 prayers marked as missed

### Example 3: Streak Calculation
**Scenario:** User completes all 5 prayers for 7 days, then misses 1 prayer on day 8

**Before Fix:**
- Streak continues (8 days)

**After Fix:**
- Streak breaks on day 8 (7 days streak)
- Only days with all 5 prayers prayed count toward streak

## Color Indicators

Prayer cards now show:
- 🟢 **Green** - Masjid (Congregation) or Completed (legacy)
- 🔵 **Blue** - Alone
- 🟠 **Orange** - Qaza (Make Up)
- 🔴 **Red** - Missed (logged but not counted as completed)
- ⚪ **Gray** - Pending (not yet logged)

## Testing Checklist

✅ **Dashboard:**
- [ ] Log prayers with different statuses
- [ ] Verify progress shows correct count (excludes missed)
- [ ] Close and reopen app - colors persist correctly
- [ ] Missed prayers show red indicator

✅ **History Page:**
- [ ] View current month - verify completion percentages
- [ ] Check monthly overview statistics
- [ ] Navigate between months
- [ ] Tap on days to see details

✅ **Statistics:**
- [ ] Daily stats exclude missed prayers
- [ ] Monthly stats show accurate completion rates
- [ ] Streak calculation only counts fully completed days

## Files Modified

1. `lib/features/dashboard/presentation/pages/dashboard_page.dart`
   - Updated `_calculateProgress()`
   - Updated `_getCompletedPrayers()`

2. `lib/core/repositories/prayer_repository.dart`
   - Updated `isPrayerCompleted()`
   - Updated `getCompletedPrayers()`
   - Updated `getDailyStats()`
   - Updated `getPrayerHistory()`
   - Updated `getMonthlyStats()`
   - Updated `getAllTimeStats()`
   - Updated `getCurrentStreak()`

3. `lib/core/config/theme/app_colors.dart`
   - Added `'completed'` case for backward compatibility

## Notes

- **Backward Compatibility:** Old prayers with `'completed'` status are still supported and counted as completed
- **Missed Prayers:** Are saved in the database for tracking purposes but excluded from completion statistics
- **Future Enhancement:** Consider adding a "Missed Prayers" section in the history to show which prayers were missed
