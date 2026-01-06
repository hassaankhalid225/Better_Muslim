import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../config/theme/app_colors.dart';
import '../config/theme/app_text_styles.dart';

/// Circular Progress Widget
/// Displays daily spiritual progress as a circular indicator
class ProgressCircle extends StatelessWidget {
  final double percentage; // 0.0 to 100.0
  final String label;
  final double radius;
  final double lineWidth;
  final bool animate;

  const ProgressCircle({
    super.key,
    required this.percentage,
    this.label = 'Daily Progress',
    this.radius = 80.0,
    this.lineWidth = 12.0,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: radius,
      lineWidth: lineWidth,
      percent: percentage / 100.0,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${percentage.toInt()}%',
            style: AppTextStyles.progressPercentage.copyWith(
              fontSize: radius * 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.progressLabel.copyWith(
              fontSize: radius * 0.15,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      backgroundColor: AppColors.progressBackground,
      linearGradient: AppColors.progressGradient,
      circularStrokeCap: CircularStrokeCap.round,
      animation: animate,
      animationDuration: 1000,
      curve: Curves.easeInOut,
    );
  }
}
