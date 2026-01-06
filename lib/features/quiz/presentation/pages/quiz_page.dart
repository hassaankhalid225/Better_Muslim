import 'package:flutter/material.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_bottom_nav.dart';
import '../../data/quiz_service.dart';
import '../../domain/models.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../../../history/presentation/pages/history_page.dart';
import '../../../daily_knowledge/presentation/pages/daily_knowledge_page.dart';
import '../../../quran/presentation/pages/quran_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentIndex = 3; // Quiz tab index
  final QuizService _service = QuizService();

  List<QuizQuestion> _dailyQuestions = [];
  int _currentQuestionIndex = 0;
  Map<int, String?> _userAnswers = {};
  bool _isLoading = true;
  bool _showResults = false;
  int _correctAnswers = 0;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final questions = await _service.getDailyQuestions(count: 5);
      setState(() {
        _dailyQuestions = questions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error loading quiz questions: $e');
    }
  }

  void _selectAnswer(String answer) {
    setState(() {
      _userAnswers[_currentQuestionIndex] = answer;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _dailyQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _calculateResults();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _calculateResults() {
    int correct = 0;
    for (int i = 0; i < _dailyQuestions.length; i++) {
      if (_userAnswers[i] == _dailyQuestions[i].correctAnswer) {
        correct++;
      }
    }
    setState(() {
      _correctAnswers = correct;
      _showResults = true;
    });
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _userAnswers = {};
      _showResults = false;
      _correctAnswers = 0;
    });
    _loadQuestions();
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
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DailyKnowledgePage()),
        );
        break;
      case 3:
        // Already here
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
        child: Column(
          children: [
            // Daily Results Header
            if (!_isLoading && _dailyQuestions.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daily Quiz',
                          style: AppTextStyles.h2.copyWith(
                            color: AppColors.primaryAccent,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _showResults
                              ? 'Score: $_correctAnswers/${_dailyQuestions.length}'
                              : 'Question ${_currentQuestionIndex + 1}/${_dailyQuestions.length}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    if (_showResults)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _correctAnswers == _dailyQuestions.length
                              ? Colors.green.withValues(alpha: 0.2)
                              : _correctAnswers >= _dailyQuestions.length / 2
                              ? Colors.orange.withValues(alpha: 0.2)
                              : Colors.red.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${((_correctAnswers / _dailyQuestions.length) * 100).toInt()}%',
                          style: AppTextStyles.h3.copyWith(
                            color: AppColors.primaryAccent,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

            // Content
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryAccent,
                      ),
                    )
                  : _dailyQuestions.isEmpty
                  ? Center(
                      child: Text(
                        'No questions available',
                        style: AppTextStyles.bodyMedium,
                      ),
                    )
                  : _showResults
                  ? _buildResultsView()
                  : _buildQuestionView(),
            ),
          ],
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

  Widget _buildQuestionView() {
    final question = _dailyQuestions[_currentQuestionIndex];
    final selectedAnswer = _userAnswers[_currentQuestionIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),

          // Question Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.cardBorder.withValues(alpha: 0.5),
              ),
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
                  'Question ${_currentQuestionIndex + 1}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  question.question,
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Answer Options
          ...question.options.map((option) {
            final isSelected = selectedAnswer == option;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => _selectAnswer(option),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryAccent.withValues(alpha: 0.2)
                        : AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryAccent
                          : AppColors.cardBorder.withValues(alpha: 0.5),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    option,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isSelected
                          ? AppColors.primaryAccent
                          : AppColors.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 32),

          // Navigation Buttons
          Row(
            children: [
              if (_currentQuestionIndex > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _previousQuestion,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: AppColors.primaryAccent),
                    ),
                    child: Text(
                      'Previous',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.primaryAccent,
                      ),
                    ),
                  ),
                ),
              if (_currentQuestionIndex > 0) const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: selectedAnswer != null ? _nextQuestion : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    disabledBackgroundColor: AppColors.primaryAccent.withValues(
                      alpha: 0.3,
                    ),
                  ),
                  child: Text(
                    _currentQuestionIndex < _dailyQuestions.length - 1
                        ? 'Next'
                        : 'Finish',
                    style: AppTextStyles.labelLarge,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildResultsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),

          // Results Summary Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.cardBorder.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  _correctAnswers == _dailyQuestions.length
                      ? Icons.check_circle
                      : _correctAnswers >= _dailyQuestions.length / 2
                      ? Icons.sentiment_satisfied
                      : Icons.sentiment_dissatisfied,
                  size: 64,
                  color: _correctAnswers == _dailyQuestions.length
                      ? Colors.green
                      : _correctAnswers >= _dailyQuestions.length / 2
                      ? Colors.orange
                      : Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  _correctAnswers == _dailyQuestions.length
                      ? 'Perfect Score!'
                      : _correctAnswers >= _dailyQuestions.length / 2
                      ? 'Good Job!'
                      : 'Keep Learning!',
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.primaryAccent,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You got $_correctAnswers out of ${_dailyQuestions.length} correct',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Detailed Results
          Text(
            'Review Your Answers',
            style: AppTextStyles.h3.copyWith(color: AppColors.primaryAccent),
          ),
          const SizedBox(height: 16),

          ...List.generate(_dailyQuestions.length, (index) {
            final question = _dailyQuestions[index];
            final userAnswer = _userAnswers[index];
            final isCorrect = userAnswer == question.correctAnswer;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isCorrect
                      ? Colors.green.withValues(alpha: 0.5)
                      : Colors.red.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isCorrect ? Icons.check_circle : Icons.cancel,
                        color: isCorrect ? Colors.green : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Question ${index + 1}',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.primaryAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(question.question, style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 12),
                  if (!isCorrect) ...[
                    Text(
                      'Your answer: $userAnswer',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    'Correct answer: ${question.correctAnswer}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    question.explanation,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 24),

          // Restart Button
          ElevatedButton(
            onPressed: _restartQuiz,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryAccent,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text('Try Again', style: AppTextStyles.labelLarge),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
