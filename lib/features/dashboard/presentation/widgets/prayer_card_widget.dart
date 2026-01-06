import 'package:flutter/material.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_card.dart';

/// Prayer Card Widget
/// Displays individual prayer information with time and status indicator
class PrayerCardWidget extends StatelessWidget {
  final String prayerName;
  final String prayerTime;
  final String status;
  final VoidCallback? onTap;

  const PrayerCardWidget({
    super.key,
    required this.prayerName,
    required this.prayerTime,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = AppColors.getPrayerStatusColor(status);

    return CustomCard(
      onTap: onTap,
      useGradient: true,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Prayer name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prayerName,
                  style: AppTextStyles.prayerName,
                ),
                const SizedBox(height: 4),
                Text(
                  prayerTime,
                  style: AppTextStyles.prayerTime,
                ),
              ],
            ),
          ),
          
          // Status indicator
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: statusColor.withValues(alpha: 0.5),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
