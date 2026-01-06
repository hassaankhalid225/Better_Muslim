import 'package:flutter/material.dart';
import '../../../../core/widgets/progress_circle.dart';
import '../../../../core/config/theme/app_text_styles.dart';

/// Daily Progress Widget
/// Shows the circular progress indicator for daily spiritual progress
class DailyProgressWidget extends StatelessWidget {
  final double progressPercentage;
  final int completedPrayers;
  final int totalPrayers;

  const DailyProgressWidget({
    super.key,
    required this.progressPercentage,
    required this.completedPrayers,
    required this.totalPrayers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          // Circular progress indicator
          ProgressCircle(
            percentage: progressPercentage,
            label: 'Daily Progress',
            radius: 100,
            lineWidth: 14,
          ),
          
          const SizedBox(height: 16),
          
          // Progress text
          Text(
            '$completedPrayers of $totalPrayers prayers completed',
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}
