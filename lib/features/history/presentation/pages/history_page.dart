import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_bottom_nav.dart';
import '../../../../core/utils/saved_prayer_data.dart';
import '../../../../core/repositories/prayer_repository.dart';
import '../../../daily_knowledge/presentation/pages/daily_knowledge_page.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../../../quiz/presentation/pages/quiz_page.dart';
import '../../../quran/presentation/pages/quran_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';

/// Prayer History Page
/// Shows calendar view with prayer completion tracking
/// Supports both Gregorian and Islamic (Hijri) calendars
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int _currentIndex = 1; // History tab
  bool _isGregorian = true; // Calendar type toggle
  DateTime _selectedMonth = DateTime.now();
  HijriCalendar _selectedHijriMonth = HijriCalendar.now();
  bool _isLoading = true; // Loading state
  final PrayerRepository _prayerRepo = PrayerRepository();

  // Prayer data from database - loaded from database
  Map<String, Map<String, dynamic>> _prayerData = {};

  @override
  void initState() {
    super.initState();
    _loadPrayerData();
  }

  /// Load prayer data from database
  Future<void> _loadPrayerData() async {
    setState(() {
      _isLoading = true;
    });

    // Load prayer history from database for the current month
    final startDate = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final endDate = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    
    final history = await _prayerRepo.getPrayerHistory(
      startDate: startDate,
      endDate: endDate,
    );

    // Convert to map format
    final Map<String, Map<String, dynamic>> prayerData = {};
    for (final entry in history) {
      final date = entry['date'] as String;
      prayerData[date] = {
        'completed': entry['completed_count'] as int,
        'total': 5,
        'percentage': entry['completion_percentage'] as double,
      };
    }

    setState(() {
      _prayerData = prayerData;
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: AppColors.primaryAccent,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Loading History...',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Header
                    _buildHeader(),

                    const SizedBox(height: 24),

                    // Calendar Type Toggle
                    _buildCalendarToggle(),

                    const SizedBox(height: 24),

                    // Calendar View
                    _buildCalendar(),

                    const SizedBox(height: 24),

                    // Monthly Overview
                    _buildMonthlyOverview(),

                    const SizedBox(height: 80), // Space for bottom nav
                  ],
                ),
              ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          _handleNavigation(index);
        },
      ),
    );
  }

  /// Build header
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            'Prayer History',
            style: AppTextStyles.h2.copyWith(color: AppColors.primaryAccent),
          ),
          const SizedBox(height: 8),
          Text('Track your spiritual journey', style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  /// Build calendar type toggle
  Widget _buildCalendarToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildToggleButton('Gregorian', _isGregorian, () {
            setState(() {
              _isGregorian = true;
            });
          }),
          const SizedBox(width: 12),
          _buildToggleButton('Islamic', !_isGregorian, () {
            setState(() {
              _isGregorian = false;
            });
          }),
        ],
      ),
    );
  }

  /// Build toggle button
  Widget _buildToggleButton(String label, bool isSelected, VoidCallback onTap) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 400 ? 24.0 : 20.0;
    final verticalPadding = screenWidth > 400 ? 12.0 : 10.0;
    final fontSize = screenWidth > 400 ? 14.0 : 13.0;
    final iconSize = screenWidth > 400 ? 18.0 : 16.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryAccent
              : AppColors.secondaryBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primaryAccent : AppColors.cardBorder,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.calendar_today : Icons.calendar_today_outlined,
              color: isSelected
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
              size: iconSize,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.labelLarge.copyWith(
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build calendar
  Widget _buildCalendar() {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalMargin = screenWidth > 600 ? 40.0 : 20.0;
    final containerPadding = screenWidth > 600 ? 24.0 : 16.0;
    final borderRadius = screenWidth > 600 ? 20.0 : 16.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      padding: EdgeInsets.all(containerPadding),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        children: [
          // Month header
          _buildMonthHeader(),

          const SizedBox(height: 16),

          // Calendar grid
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  /// Build month header
  Widget _buildMonthHeader() {
    String monthText;

    if (_isGregorian) {
      monthText = DateFormat('MMMM yyyy').format(_selectedMonth);
    } else {
      // Islamic calendar month names
      monthText =
          '${_selectedHijriMonth.longMonthName} ${_selectedHijriMonth.hYear}';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
          onPressed: () {
            setState(() {
              if (_isGregorian) {
                _selectedMonth = DateTime(
                  _selectedMonth.year,
                  _selectedMonth.month - 1,
                );
              } else {
                _selectedHijriMonth = HijriCalendar.fromDate(
                  DateTime(_selectedMonth.year, _selectedMonth.month - 1),
                );
                _selectedMonth = DateTime(
                  _selectedMonth.year,
                  _selectedMonth.month - 1,
                );
              }
            });
            _loadPrayerData(); // Reload data for new month
          },
        ),
        Expanded(
          child: Text(
            monthText,
            style: AppTextStyles.h4.copyWith(color: AppColors.primaryAccent),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: AppColors.textPrimary),
          onPressed: () {
            setState(() {
              if (_isGregorian) {
                _selectedMonth = DateTime(
                  _selectedMonth.year,
                  _selectedMonth.month + 1,
                );
              } else {
                _selectedHijriMonth = HijriCalendar.fromDate(
                  DateTime(_selectedMonth.year, _selectedMonth.month + 1),
                );
                _selectedMonth = DateTime(
                  _selectedMonth.year,
                  _selectedMonth.month + 1,
                );
              }
            });
            _loadPrayerData(); // Reload data for new month
          },
        ),
      ],
    );
  }

  /// Build calendar grid
  Widget _buildCalendarGrid() {
    int daysInMonth;

    if (_isGregorian) {
      daysInMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + 1,
        0,
      ).day;
    } else {
      // Get days in Hijri month
      daysInMonth = _selectedHijriMonth.lengthOfMonth;
    }

    // Calculate responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = 40.0; // 20px on each side
    final availableWidth = screenWidth - horizontalPadding - 40; // Minus container padding
    final cellSize = (availableWidth - (6 * 8)) / 7; // 7 cells, 6 gaps of 8px
    final spacing = screenWidth > 400 ? 8.0 : 4.0; // Smaller spacing on small screens

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: daysInMonth,
      itemBuilder: (context, index) {
        final day = index + 1;

        // Get prayer data for this day
        String dateKey;
        if (_isGregorian) {
          dateKey =
              '${_selectedMonth.year}-${_selectedMonth.month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
        } else {
          // For Hijri, we still use Gregorian date as key for database lookup
          final gregorianDate = _selectedHijriMonth.hijriToGregorian(
            _selectedHijriMonth.hYear,
            _selectedHijriMonth.hMonth,
            day,
          );
          dateKey =
              '${gregorianDate.year}-${gregorianDate.month.toString().padLeft(2, '0')}-${gregorianDate.day.toString().padLeft(2, '0')}';
        }

        final data = _prayerData[dateKey];

        return _buildDayCell(day, data, cellSize);
      },
    );
  }

  /// Build day cell
  Widget _buildDayCell(int day, Map<String, dynamic>? data, double cellSize) {
    // Default: 0/5 (no prayers logged)
    final completed = data?['completed'] ?? 0;
    final total = data?['total'] ?? 5;
    final isFullyCompleted = completed == total && total > 0 && completed > 0;
    final hasPartialCompletion = completed > 0 && completed < total;

    Color backgroundColor;
    Color textColor;

    if (isFullyCompleted) {
      // All prayers completed - Full blue
      backgroundColor = AppColors.primaryAccent;
      textColor = AppColors.textPrimary;
    } else if (hasPartialCompletion) {
      // Some prayers completed - Light blue
      backgroundColor = AppColors.primaryAccent.withValues(alpha: 0.3);
      textColor = AppColors.textPrimary;
    } else {
      // No prayers logged - Gray (default)
      backgroundColor = AppColors.secondaryBackground;
      textColor = AppColors.textTertiary;
    }

    // Responsive font sizes based on cell size
    final dayFontSize = cellSize > 45 ? 14.0 : (cellSize > 35 ? 12.0 : 10.0);
    final ratioFontSize = cellSize > 45 ? 9.0 : (cellSize > 35 ? 8.0 : 7.0);

    return InkWell(
      onTap: () => _showDayDetails(day, data),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isFullyCompleted
                ? AppColors.primaryAccent
                : AppColors.cardBorder,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$day',
              style: AppTextStyles.labelLarge.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: dayFontSize,
              ),
            ),
            SizedBox(height: cellSize > 40 ? 2 : 1),
            // Always show ratio (default 0/5)
            Text(
              '$completed/$total',
              style: AppTextStyles.caption.copyWith(
                color: textColor.withValues(alpha: 0.8),
                fontSize: ratioFontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build monthly overview
  Widget _buildMonthlyOverview() {
    // Calculate statistics from prayer data
    int totalPrayers = 0;
    int completedPrayers = 0;

    _prayerData.forEach((date, data) {
      totalPrayers += (data['total'] as int? ?? 5);
      completedPrayers += (data['completed'] as int? ?? 0);
    });

    final missedPrayers = totalPrayers - completedPrayers;
    final completionRate = totalPrayers > 0
        ? ((completedPrayers / totalPrayers) * 100).toStringAsFixed(0)
        : '0';

    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalMargin = screenWidth > 600 ? 40.0 : 20.0;
    final containerPadding = screenWidth > 600 ? 24.0 : 16.0;
    final borderRadius = screenWidth > 600 ? 20.0 : 16.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      padding: EdgeInsets.all(containerPadding),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Overview',
            style: AppTextStyles.h4.copyWith(color: AppColors.primaryAccent),
          ),
          const SizedBox(height: 16),

          _buildStatRow('Total Prayers', '$totalPrayers'),
          _buildStatRow('Completed', '$completedPrayers'),
          _buildStatRow('Missed', '$missedPrayers'),
          _buildStatRow('Completion Rate', '$completionRate%'),
        ],
      ),
    );
  }

  /// Build stat row
  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(
            value,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.primaryAccent,
            ),
          ),
        ],
      ),
    );
  }

  /// Show day details
  void _showDayDetails(int day, Map<String, dynamic>? data) {
    final completed = data?['completed'] ?? 0;
    final total = data?['total'] ?? 5;

    String monthText;
    if (_isGregorian) {
      monthText = DateFormat('MMMM yyyy').format(_selectedMonth);
    } else {
      monthText =
          '${_selectedHijriMonth.longMonthName} ${_selectedHijriMonth.hYear}';
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 24),

            Text('Day $day - $monthText', style: AppTextStyles.h4),

            const SizedBox(height: 16),

            Text('Prayers: $completed/$total', style: AppTextStyles.bodyLarge),

            const SizedBox(height: 8),

            if (completed == 0)
              Text(
                'No prayers logged for this day',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Handle navigation
  void _handleNavigation(int index) {
    if (index == _currentIndex) return;

    switch (index) {
      case 0:
        // Dashboard (Prayers)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
        break;
      case 1:
        // History (current page)
        break;
      case 2:
        // Daily Knowledge
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DailyKnowledgePage()),
        );
        break;
      case 3:
        // Quiz
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const QuizPage()),
        );
        break;
      case 4:
        // Quran
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const QuranPage()),
        );
        break;
      case 5:
        // Settings
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SettingsPage()),
        );
        break;
    }
  }
}
