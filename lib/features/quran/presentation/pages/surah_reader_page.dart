import 'package:flutter/material.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_text_styles.dart';
import '../../domain/models/surah_model.dart';
import '../../data/quran_service.dart';

/// Surah Reader Page
/// Displays the selected Surah with Arabic and English text
class SurahReaderPage extends StatefulWidget {
  final SurahModel surah;

  const SurahReaderPage({
    super.key,
    required this.surah,
  });

  @override
  State<SurahReaderPage> createState() => _SurahReaderPageState();
}

class _SurahReaderPageState extends State<SurahReaderPage> {
  final ScrollController _scrollController = ScrollController();
  final QuranService _quranService = QuranService();
  bool _showScrollToTop = false;
  bool _isLoading = true;
  SurahModel? _completeSurah;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadSurahAyahs();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  /// Load complete Surah with all Ayahs from API
  Future<void> _loadSurahAyahs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final completeSurah = await _quranService.fetchSurahWithAyahs(widget.surah.number);
      
      if (completeSurah != null && mounted) {
        setState(() {
          _completeSurah = completeSurah;
          _isLoading = false;
        });
      } else if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load Surah. Please check your internet connection.';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error loading Surah: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  void _scrollListener() {
    if (_scrollController.offset > 500 && !_showScrollToTop) {
      setState(() => _showScrollToTop = true);
    } else if (_scrollController.offset <= 500 && _showScrollToTop) {
      setState(() => _showScrollToTop = false);
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Divider
            Container(
              height: 1,
              color: AppColors.cardBorder,
            ),
            
            // Content
            Expanded(
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
                            'Loading Surah...',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : _errorMessage != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: AppColors.error,
                                  size: 64,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _errorMessage!,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton(
                                  onPressed: _loadSurahAyahs,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryAccent,
                                  ),
                                  child: Text(
                                    'Retry',
                                    style: AppTextStyles.labelLarge,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : _completeSurah != null && _completeSurah!.ayahs.isNotEmpty
                          ? ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(20),
                              itemCount: _completeSurah!.ayahs.length,
                              itemBuilder: (context, index) {
                                final ayah = _completeSurah!.ayahs[index];
                                return _buildAyahCard(ayah, index);
                              },
                            )
                          : Center(
                              child: Text(
                                'No verses available',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
            ),
          ],
        ),
      ),
      floatingActionButton: _showScrollToTop
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              backgroundColor: AppColors.primaryAccent,
              child: const Icon(
                Icons.arrow_upward,
                color: AppColors.textPrimary,
              ),
            )
          : null,
    );
  }

  /// Build header
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Back button and title row
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.textPrimary,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.surah.nameEnglish,
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.surah.nameTransliteration} • ${widget.surah.numberOfAyahs} Ayahs • ${widget.surah.revelationType}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Arabic name
              Text(
                widget.surah.nameArabic,
                style: AppTextStyles.quranText.copyWith(
                  fontSize: 28,
                  color: AppColors.primaryAccent,
                ),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build Ayah card
  Widget _buildAyahCard(AyahModel ayah, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.cardBorder.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ayah number badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryAccent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.primaryAccent.withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  'Ayah ${ayah.numberInSurah}',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primaryAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Bookmark icon (non-functional for now)
              IconButton(
                icon: const Icon(
                  Icons.bookmark_border,
                  color: AppColors.textTertiary,
                  size: 20,
                ),
                onPressed: () {
                  // TODO: Implement bookmark functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bookmark feature coming soon'),
                      duration: Duration(seconds: 1),
                      backgroundColor: AppColors.info,
                    ),
                  );
                },
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Bismillah for first ayah (except for Surah 1 and 9)
          if (index == 0 && _completeSurah != null && _completeSurah!.number != 1 && _completeSurah!.number != 9)
            Column(
              children: [
                Text(
                  'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                  style: AppTextStyles.quranText.copyWith(
                    fontSize: 24,
                    color: AppColors.quranTextArabic,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 20),
                Container(
                  height: 1,
                  color: AppColors.cardBorder.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 20),
              ],
            ),
          
          // Arabic text
          Text(
            ayah.textArabic,
            style: AppTextStyles.quranText.copyWith(
              fontSize: 28,
              height: 2.0,
              color: AppColors.quranTextArabic,
            ),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
          
          const SizedBox(height: 20),
          
          // Divider
          Container(
            height: 1,
            color: AppColors.cardBorder.withValues(alpha: 0.3),
          ),
          
          const SizedBox(height: 16),
          
          // English translation
          Text(
            ayah.textEnglish,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 16,
              height: 1.6,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
