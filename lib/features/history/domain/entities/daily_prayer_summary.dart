import 'package:equatable/equatable.dart';

/// Domain Entity: Daily Prayer Summary
/// Represents prayer completion for a specific date
class DailyPrayerSummary extends Equatable {
  final DateTime date;
  final int totalPrayers;
  final int completedPrayers;
  final Map<String, String> prayerStatuses; // prayer name -> status

  const DailyPrayerSummary({
    required this.date,
    required this.totalPrayers,
    required this.completedPrayers,
    required this.prayerStatuses,
  });

  /// Calculate completion ratio (e.g., "4/5")
  String get completionRatio => '$completedPrayers/$totalPrayers';

  /// Calculate completion percentage
  double get completionPercentage {
    if (totalPrayers == 0) return 0.0;
    return (completedPrayers / totalPrayers) * 100;
  }

  /// Check if all prayers are completed
  bool get isFullyCompleted => completedPrayers == totalPrayers;

  /// Check if any prayer is completed
  bool get hasAnyCompleted => completedPrayers > 0;

  @override
  List<Object?> get props => [date, totalPrayers, completedPrayers, prayerStatuses];
}
