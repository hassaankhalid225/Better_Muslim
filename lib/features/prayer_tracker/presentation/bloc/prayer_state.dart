import 'package:equatable/equatable.dart';
import '../../domain/entities/prayer_log.dart';

/// Prayer Tracker States
/// All possible states of the Prayer Tracker feature
abstract class PrayerState extends Equatable {
  const PrayerState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class PrayerInitial extends PrayerState {
  const PrayerInitial();
}

/// Loading state
class PrayerLoading extends PrayerState {
  const PrayerLoading();
}

/// Prayer logs loaded successfully
class PrayerLogsLoaded extends PrayerState {
  final List<PrayerLog> prayerLogs;
  final DateTime date;

  const PrayerLogsLoaded({
    required this.prayerLogs,
    required this.date,
  });

  @override
  List<Object?> get props => [prayerLogs, date];
}

/// Prayer logged successfully
class PrayerLoggedSuccess extends PrayerState {
  final String message;
  final PrayerLog? prayerLog;

  const PrayerLoggedSuccess({
    required this.message,
    this.prayerLog,
  });

  @override
  List<Object?> get props => [message, prayerLog];
}

/// Prayer status updated successfully
class PrayerStatusUpdated extends PrayerState {
  final String message;

  const PrayerStatusUpdated(this.message);

  @override
  List<Object?> get props => [message];
}

/// Prayer deleted successfully
class PrayerDeleted extends PrayerState {
  final String message;

  const PrayerDeleted(this.message);

  @override
  List<Object?> get props => [message];
}

/// Prayer statistics loaded
class PrayerStatisticsLoaded extends PrayerState {
  final Map<String, int> statistics;
  final DateTime startDate;
  final DateTime endDate;

  const PrayerStatisticsLoaded({
    required this.statistics,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [statistics, startDate, endDate];
}

/// Error state
class PrayerError extends PrayerState {
  final String message;

  const PrayerError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Empty state (no prayers logged)
class PrayerEmpty extends PrayerState {
  final String message;

  const PrayerEmpty(this.message);

  @override
  List<Object?> get props => [message];
}
