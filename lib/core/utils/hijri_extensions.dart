import 'package:hijri/hijri_calendar.dart';

/// Extension on HijriCalendar to provide additional functionality
extension HijriCalendarExtension on HijriCalendar {
  /// Get long month name in English
  String getLongMonthName() {
    const monthNames = [
      'Muharram',
      'Safar',
      'Rabi\' al-Awwal',
      'Rabi\' al-Thani',
      'Jumada al-Awwal',
      'Jumada al-Thani',
      'Rajab',
      'Sha\'ban',
      'Ramadan',
      'Shawwal',
      'Dhu al-Qi\'dah',
      'Dhu al-Hijjah',
    ];
    
    return monthNames[hMonth - 1];
  }

  /// Get short month name in English
  String getShortMonthName() {
    const monthNames = [
      'Muh',
      'Saf',
      'Rab I',
      'Rab II',
      'Jum I',
      'Jum II',
      'Raj',
      'Sha',
      'Ram',
      'Shaw',
      'Dhu Q',
      'Dhu H',
    ];
    
    return monthNames[hMonth - 1];
  }

  /// Get Arabic month name
  String getArabicMonthName() {
    const monthNames = [
      'مُحَرَّم',
      'صَفَر',
      'رَبِيع ٱلْأَوَّل',
      'رَبِيع ٱلثَّانِي',
      'جُمَادَىٰ ٱلْأُولَىٰ',
      'جُمَادَىٰ ٱلثَّانِيَة',
      'رَجَب',
      'شَعْبَان',
      'رَمَضَان',
      'شَوَّال',
      'ذُو ٱلْقَعْدَة',
      'ذُو ٱلْحِجَّة',
    ];
    
    return monthNames[hMonth - 1];
  }

  /// Get day name in English
  String getDayName() {
    const dayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    
    final gregorianDate = hijriToGregorian(hYear, hMonth, hDay);
    final weekday = gregorianDate.weekday;
    
    return dayNames[weekday - 1];
  }

  /// Get formatted date string
  String toFormattedString({bool includeDay = false}) {
    if (includeDay) {
      return '$hDay ${getLongMonthName()} $hYear AH';
    }
    return '${getLongMonthName()} $hYear AH';
  }

  /// Get formatted Arabic date string
  String toArabicString() {
    return '$hDay ${getArabicMonthName()} $hYear هـ';
  }
}
