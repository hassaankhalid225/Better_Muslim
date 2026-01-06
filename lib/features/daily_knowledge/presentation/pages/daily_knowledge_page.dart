import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_bottom_nav.dart';
import '../../data/daily_knowledge_service.dart';
import '../../domain/models.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../../../history/presentation/pages/history_page.dart';
import '../../../quiz/presentation/pages/quiz_page.dart';
import '../../../quran/presentation/pages/quran_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';

class DailyKnowledgePage extends StatefulWidget {
  const DailyKnowledgePage({super.key});

  @override
  State<DailyKnowledgePage> createState() => _DailyKnowledgePageState();
}

class _DailyKnowledgePageState extends State<DailyKnowledgePage> {
  int _currentIndex = 2; // Daily Knowledge tab index
  final DailyKnowledgeService _service = DailyKnowledgeService();

  List<Ayah> _dailyAyahs = [];
  List<Hadith> _dailyHadiths = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final ayahs = await _service.getDailyAyahs(count: 3);
      final hadiths = await _service.getDailyHadiths(count: 3);

      setState(() {
        _dailyAyahs = ayahs;
        _dailyHadiths = hadiths;
        _isLoading = false;
      });
    } catch (e) {
      // Handle error gracefully
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error loading daily knowledge: $e');
    }
  }

  void _handleNavigation(int index) {
    if (index == _currentIndex) return;

    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
        break;
      case 1:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HistoryPage()),
        );
        break;
      case 2:
        // Already here
        break;
      case 3:
        // Quiz Page
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const QuizPage()),
        );
        break;
      case 4:
        // Quran Page
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      'Daily Knowledge',
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.primaryAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Enlighten your day', style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Content
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryAccent,
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            // Display multiple Ayahs
                            ..._dailyAyahs.asMap().entries.map((entry) {
                              final index = entry.key;
                              final ayah = entry.value;
                              return Column(
                                children: [
                                  _buildContentCard(
                                    title: index == 0
                                        ? 'Ayah of the Day'
                                        : 'Daily Ayah ${index + 1}',
                                    content: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          ayah.arabicText,
                                          style: AppTextStyles.quranText
                                              .copyWith(fontSize: 24),
                                          textAlign: TextAlign.center,
                                          textDirection: TextDirection.rtl,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          '"${ayah.englishText}"',
                                          style: AppTextStyles.bodyMedium,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          ayah.reference,
                                          style: AppTextStyles.caption.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onShare: () {
                                      Share.share(
                                        'Daily Ayah:\n\n${ayah.arabicText}\n\n"${ayah.englishText}"\n\n- ${ayah.reference}\n\nShared via BetterMuslim App',
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              );
                            }).toList(),

                            // Display multiple Hadiths
                            ..._dailyHadiths.asMap().entries.map((entry) {
                              final index = entry.key;
                              final hadith = entry.value;
                              return Column(
                                children: [
                                  _buildContentCard(
                                    title: index == 0
                                        ? 'Hadith of the Day'
                                        : 'Daily Hadith ${index + 1}',
                                    content: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          hadith.text,
                                          style: AppTextStyles.bodyMedium,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          hadith.source,
                                          style: AppTextStyles.caption.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onShare: () {
                                      Share.share(
                                        'Daily Hadith:\n\n"${hadith.text}"\n\n- ${hadith.source}\n\nShared via BetterMuslim App',
                                      );
                                    },
                                  ),
                                  if (index < _dailyHadiths.length - 1)
                                    const SizedBox(height: 20),
                                ],
                              );
                            }).toList(),

                            const SizedBox(height: 80), // Bottom padding
                          ],
                        ),
                      ),
              ),
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

  Widget _buildContentCard({
    required String title,
    required Widget content,
    required VoidCallback onShare,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.h3.copyWith(color: AppColors.primaryAccent),
          ),
          const SizedBox(height: 20),
          content,
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: onShare,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Text(
                  'Share',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.primaryAccent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
