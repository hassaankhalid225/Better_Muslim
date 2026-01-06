import 'package:flutter/material.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_bottom_nav.dart';
import '../../data/repositories/settings_repository.dart';
import '../../domain/models/settings_model.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../../../history/presentation/pages/history_page.dart';
import '../../../daily_knowledge/presentation/pages/daily_knowledge_page.dart';
import '../../../quiz/presentation/pages/quiz_page.dart';
import '../../../quran/presentation/pages/quran_page.dart';
import '../../../nasheed/presentation/pages/nasheed_page.dart';

/// Settings Page
/// Allows users to customize notifications and app preferences
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsRepository _repository = SettingsRepository();
  SettingsModel _settings = const SettingsModel();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  /// Load settings from repository
  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    try {
      final settings = await _repository.loadSettings();
      setState(() {
        _settings = settings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        _showErrorSnackBar('Failed to load settings');
      }
    }
  }

  /// Update notification setting
  Future<void> _updateNotificationSetting(String settingName, bool value) async {
    try {
      await _repository.updateNotificationSetting(settingName, value);
      await _loadSettings();
      if (mounted) {
        _showSuccessSnackBar('Setting updated');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Failed to update setting');
      }
    }
  }

  /// Update app preference
  Future<void> _updatePreference(String key, String value) async {
    try {
      await _repository.updatePreference(key, value);
      await _loadSettings();
      if (mounted) {
        _showSuccessSnackBar('Preference updated');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Failed to update preference');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryAccent,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // Header
                    _buildHeader(),

                    const SizedBox(height: 24),

                    // Notifications Section
                    _buildNotificationsSection(),

                    const SizedBox(height: 24),

                    // App Preferences Section
                    _buildAppPreferencesSection(),

                    const SizedBox(height: 24),

                    // App Info
                    _buildAppInfo(),

                    const SizedBox(height: 100), // Space for bottom nav
                  ],
                ),
              ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 5, // Settings tab
        onTap: _handleNavigation,
      ),
    );
  }

  /// Build header
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Settings',
            style: AppTextStyles.h1.copyWith(color: AppColors.primaryAccent),
          ),
          const SizedBox(height: 8),
          Text(
            'Customize your experience',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Build notifications section
  Widget _buildNotificationsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications',
              style: AppTextStyles.h4.copyWith(color: AppColors.primaryAccent),
            ),
            const SizedBox(height: 20),
            _buildToggleSetting(
              'Prayer Times',
              _settings.prayerTimesNotifications,
              (value) => _updateNotificationSetting('prayerTimes', value),
            ),
            const SizedBox(height: 16),
            _buildToggleSetting(
              'Inspiring Quotes',
              _settings.inspiringQuotesNotifications,
              (value) => _updateNotificationSetting('inspiringQuotes', value),
            ),
            const SizedBox(height: 16),
            _buildToggleSetting(
              'Quran Reminders',
              _settings.quranRemindersNotifications,
              (value) => _updateNotificationSetting('quranReminders', value),
            ),
            const SizedBox(height: 16),
            _buildToggleSetting(
              'Community Events',
              _settings.communityEventsNotifications,
              (value) => _updateNotificationSetting('communityEvents', value),
            ),
            const SizedBox(height: 16),
            _buildToggleSetting(
              'App Updates',
              _settings.appUpdatesNotifications,
              (value) => _updateNotificationSetting('appUpdates', value),
            ),
          ],
        ),
      ),
    );
  }

  /// Build app preferences section
  Widget _buildAppPreferencesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Preferences',
              style: AppTextStyles.h4.copyWith(color: AppColors.primaryAccent),
            ),
            const SizedBox(height: 20),
            _buildPreferenceSetting(
              'Language',
              _settings.language,
              ['English', 'Arabic', 'Urdu', 'Turkish', 'Malay'],
              (value) => _updatePreference('language', value),
            ),
            const SizedBox(height: 16),
            _buildPreferenceSetting(
              'Prayer Calculation Method',
              _settings.prayerCalculationMethod,
              ['ISNA', 'MWL', 'Egypt', 'Makkah', 'Karachi', 'Tehran'],
              (value) => _updatePreference('prayerCalculationMethod', value),
            ),
            const SizedBox(height: 16),
            _buildPreferenceSetting(
              'Adhan Voice',
              _settings.adhanVoice,
              ['Al-Makkah', 'Al-Madinah', 'Al-Aqsa', 'Egypt', 'Turkey'],
              (value) => _updatePreference('adhanVoice', value),
            ),
            const SizedBox(height: 16),
            // Nasheed Library navigation
            _buildNavigationSetting(
              'Nasheed Library',
              'Islamic nasheeds and videos',
              Icons.music_note,
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const NasheedPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Build toggle setting row
  Widget _buildToggleSetting(
    String label,
    bool value,
    Function(bool) onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyLarge,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.primaryAccent,
          activeTrackColor: AppColors.primaryAccent.withValues(alpha: 0.5),
          inactiveThumbColor: AppColors.textTertiary,
          inactiveTrackColor: AppColors.progressBackground,
        ),
      ],
    );
  }

  /// Build preference setting row
  Widget _buildPreferenceSetting(
    String label,
    String currentValue,
    List<String> options,
    Function(String) onChanged,
  ) {
    return InkWell(
      onTap: () => _showPreferenceDialog(label, currentValue, options, onChanged),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyLarge,
              ),
            ),
            Row(
              children: [
                Text(
                  currentValue,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryAccent,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textTertiary,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build navigation setting row (for pages like Nasheed Library)
  Widget _buildNavigationSetting(
    String label,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryAccent.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryAccent,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.bodyLarge,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textTertiary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  /// Show preference selection dialog
  void _showPreferenceDialog(
    String title,
    String currentValue,
    List<String> options,
    Function(String) onChanged,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Select $title',
          style: AppTextStyles.h4,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) {
            final isSelected = option == currentValue;
            return InkWell(
              onTap: () {
                Navigator.pop(context);
                onChanged(option);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryAccent.withValues(alpha: 0.2)
                      : AppColors.secondaryBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryAccent
                        : AppColors.cardBorder,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      option,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isSelected
                            ? AppColors.primaryAccent
                            : AppColors.textPrimary,
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.primaryAccent,
                        size: 20,
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build app info
  Widget _buildAppInfo() {
    return Column(
      children: [
        Text(
          'BetterMuslim v1.0',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Your Digital Sanctuary',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.primaryAccent,
          ),
        ),
      ],
    );
  }

  /// Show success snackbar
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  /// Show error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Handle bottom navigation
  void _handleNavigation(int index) {
    if (index == 5) return; // Already on settings

    switch (index) {
      case 0:
        // Prayers
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
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
          MaterialPageRoute(builder: (context) => const QuranPage()),
        );
        break;
    }
  }
}
