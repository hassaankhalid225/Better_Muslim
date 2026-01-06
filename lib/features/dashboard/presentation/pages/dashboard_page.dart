import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_bottom_nav.dart';
import '../../../../core/constants/prayer_constants.dart';
import '../../../../core/utils/saved_prayer_data.dart';
import '../../../../core/repositories/prayer_repository.dart';
import '../../../history/presentation/pages/history_page.dart';
import '../../../daily_knowledge/presentation/pages/daily_knowledge_page.dart';
import '../../../quiz/presentation/pages/quiz_page.dart';
import '../../../quran/presentation/pages/quran_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../widgets/daily_progress_widget.dart';
import '../widgets/prayer_card_widget.dart';

/// Dashboard Page
/// Main screen showing daily progress and prayer times
/// Matches the Figma design with circular progress and prayer cards
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  final PrayerRepository _prayerRepo = PrayerRepository();
  bool _isLoading = true;

  // Prayer data - initially all pending (not selected)
  final List<Map<String, String>> _prayers = [
    {'name': 'Fajr', 'time': '5:12 AM', 'status': 'pending'},
    {'name': 'Dhuhr', 'time': '12:30 PM', 'status': 'pending'},
    {'name': 'Asr', 'time': '3:45 PM', 'status': 'pending'},
    {'name': 'Maghrib', 'time': '6:21 PM', 'status': 'pending'},
    {'name': 'Isha', 'time': '7:45 PM', 'status': 'pending'},
  ];

  @override
  void initState() {
    super.initState();
    _loadTodaysPrayers();
  }

  /// Load today's prayer completions from database
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

  /// Toggle prayer status and save to database
  Future<void> _togglePrayer(int index) async {
    final prayer = _prayers[index];
    final prayerName = prayer['name']!;
    final prayerTime = prayer['time']!;
    final currentStatus = prayer['status']!;
    final isLogged = currentStatus != 'pending';

    if (isLogged) {
      // Mark as incomplete (remove from database)
      await _prayerRepo.incompletePrayer(
        prayerName: prayerName,
        date: DateTime.now(),
      );
      setState(() {
        prayer['status'] = 'pending';
      });
    } else {
      // Mark as completed (default status)
      await _prayerRepo.completePrayer(
        prayerName: prayerName,
        date: DateTime.now(),
        prayerTime: prayerTime,
        status: 'masjid', // Default to masjid when toggling
      );
      setState(() {
        prayer['status'] = 'masjid';
      });
    }
  }


  double _calculateProgress() {
    // Only count prayers that were actually prayed (not missed or pending)
    int completed = _prayers.where((p) {
      final status = p['status']!;
      return status != 'pending' && status != 'missed';
    }).length;
    return (completed / _prayers.length) * 100;
  }

  int _getCompletedPrayers() {
    // Only count prayers that were actually prayed (not missed or pending)
    return _prayers.where((p) {
      final status = p['status']!;
      return status != 'pending' && status != 'missed';
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final hijriDate = HijriCalendar.fromDate(now);

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with app name and date
              _buildHeader(now, hijriDate),

              const SizedBox(height: 24),

              // Daily Progress Circle
              DailyProgressWidget(
                progressPercentage: _calculateProgress(),
                completedPrayers: _getCompletedPrayers(),
                totalPrayers: _prayers.length,
              ),

              const SizedBox(height: 24),

              // Prayer Cards List
              _buildPrayersList(),

              const SizedBox(height: 24),

              // Done Button - Save to Database
              _buildDoneButton(),

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

  /// Build header with app name and dates
  Widget _buildHeader(DateTime now, HijriCalendar hijriDate) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // App Name
          Text(
            'BetterMuslim',
            style: AppTextStyles.h1.copyWith(color: AppColors.primaryAccent),
          ),

          const SizedBox(height: 8),

          // Gregorian Date
          Text(
            DateFormat('EEEE, dd MMMM yyyy').format(now),
            style: AppTextStyles.dateText,
          ),

          const SizedBox(height: 4),

          // Hijri Date
          Text(
            '${hijriDate.hDay} ${hijriDate.longMonthName} ${hijriDate.hYear}',
            style: AppTextStyles.hijriDate,
          ),
        ],
      ),
    );
  }

  /// Build prayers list
  Widget _buildPrayersList() {
    return Column(
      children: _prayers.map((prayer) {
        return PrayerCardWidget(
          prayerName: prayer['name']!,
          prayerTime: prayer['time']!,
          status: prayer['status']!,
          onTap: () => _showPrayerLoggingSheet(prayer['name']!),
        );
      }).toList(),
    );
  }

  /// Build Done button
  Widget _buildDoneButton() {
    final hasLoggedPrayers = _prayers.any((p) => p['status'] != 'pending');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: hasLoggedPrayers ? _savePrayersToDatabase : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: hasLoggedPrayers
              ? AppColors.primaryAccent
              : AppColors.textDisabled,
          foregroundColor: AppColors.textPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: hasLoggedPrayers ? 4 : 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 24),
            const SizedBox(width: 12),
            Text('Done - Save to History', style: AppTextStyles.buttonPrimary),
          ],
        ),
      ),
    );
  }

  /// Show prayer logging bottom sheet
  void _showPrayerLoggingSheet(String prayerName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildPrayerLoggingSheet(prayerName),
    );
  }

  /// Build prayer logging bottom sheet
  Widget _buildPrayerLoggingSheet(String prayerName) {
    return Container(
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

          // Title
          Text('Log $prayerName Prayer', style: AppTextStyles.h3),

          const SizedBox(height: 24),

          // Status options
          _buildStatusOption(
            prayerName,
            'Masjid (Congregation)',
            'masjid',
            Icons.mosque,
          ),
          _buildStatusOption(prayerName, 'Alone', 'alone', Icons.person),
          _buildStatusOption(
            prayerName,
            'Qaza (Make Up)',
            'qaza',
            Icons.restore,
          ),
          _buildStatusOption(prayerName, 'Missed', 'missed', Icons.close),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Build status option button
  Widget _buildStatusOption(
    String prayerName,
    String label,
    String status,
    IconData icon,
  ) {
    final color = AppColors.getPrayerStatusColor(status);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          _logPrayer(prayerName, status);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.secondaryBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(child: Text(label, style: AppTextStyles.bodyLarge)),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textTertiary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Log prayer and save to database
  Future<void> _logPrayer(String prayerName, String status) async {
    // Find prayer index and time
    final prayerIndex = _prayers.indexWhere((p) => p['name'] == prayerName);
    if (prayerIndex == -1) return;

    final prayerTime = _prayers[prayerIndex]['time']!;

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

    // Update local state
    setState(() {
      _prayers[prayerIndex]['status'] = status;
    });

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$prayerName logged as ${PrayerConstants.getStatusLabel(status)}',
          ),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  /// Save all logged prayers to database
  void _savePrayersToDatabase() async {
    // Get today's date
    final today = DateTime.now();
    final dateKey =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    // Count completed prayers
    final completedPrayers = _prayers
        .where((p) => p['status'] != 'pending')
        .length;
    final totalPrayers = _prayers.length;

    // Save to shared preferences or global state (for now, using a static variable)
    // In production, this would save to SQLite database via BLoC
    SavedPrayerData.savePrayersForDate(dateKey, {
      'completed': completedPrayers,
      'total': totalPrayers,
      'prayers': Map.fromEntries(
        _prayers
            .where((p) => p['status'] != 'pending')
            .map((p) => MapEntry(p['name']!, p['status']!)),
      ),
    });

    // Show success dialog
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 32,
              ),
              const SizedBox(width: 12),
              Text('Saved!', style: AppTextStyles.h4),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your prayers have been saved to history.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.secondaryBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _buildSummaryRow(
                      'Date',
                      DateFormat('MMM dd, yyyy').format(today),
                    ),
                    const SizedBox(height: 8),
                    _buildSummaryRow(
                      'Prayers Logged',
                      '$completedPrayers/$totalPrayers',
                    ),
                    const SizedBox(height: 8),
                    _buildSummaryRow(
                      'Completion',
                      '${((completedPrayers / totalPrayers) * 100).toInt()}%',
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // DON'T reset prayers - keep them displayed
              },
              child: Text(
                'OK',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primaryAccent,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to history
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAccent,
              ),
              child: Text('View History', style: AppTextStyles.labelLarge),
            ),
          ],
        ),
      );
    }
  }

  /// Build summary row for dialog
  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.primaryAccent,
          ),
        ),
      ],
    );
  }

  /// Handle bottom navigation
  void _handleNavigation(int index) {
    if (index == _currentIndex) return;

    switch (index) {
      case 0:
        // Prayers (current page)
        break;
      case 1:
        // History
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HistoryPage()),
        );
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
          MaterialPageRoute(
            builder: (context) => const QuranPage(),
          ),
        );
        break;
      case 5:
        // Settings
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const SettingsPage(),
          ),
        );
        break;
    }
  }
}
