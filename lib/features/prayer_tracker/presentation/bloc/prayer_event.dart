import 'package:equatable/equatable.dart';

/// Prayer Tracker Events
/// All events that can be triggered in the Prayer Tracker feature
abstract class PrayerEvent extends Equatable {
  const PrayerEvent();

  @override
  List<Object?> get props => [];
}

/// Event: Load prayer logs for a specific date
class LoadPrayerLogsEvent extends PrayerEvent {
  final DateTime date;

  const LoadPrayerLogsEvent(this.date);

  @override
  List<Object?> get props => [date];
}

/// Event: Log a new prayer
class LogPrayerEvent extends PrayerEvent {
  final String prayerName;
  final String status;
  final String? notes;

  const LogPrayerEvent({
    required this.prayerName,
    required this.status,
    this.notes,
  });

  @override
  List<Object?> get props => [prayerName, status, notes];
}

/// Event: Update prayer status
class UpdatePrayerStatusEvent extends PrayerEvent {
  final int id;
  final String status;

  const UpdatePrayerStatusEvent({
    required this.id,
    required this.status,
  });

  @override
  List<Object?> get props => [id, status];
}

/// Event: Delete prayer log
class DeletePrayerLogEvent extends PrayerEvent {
  final int id;

  const DeletePrayerLogEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event: Load prayer statistics
class LoadPrayerStatisticsEvent extends PrayerEvent {
  final DateTime startDate;
  final DateTime endDate;

  const LoadPrayerStatisticsEvent({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

/// Event: Refresh prayer data
class RefreshPrayerDataEvent extends PrayerEvent {
  const RefreshPrayerDataEvent();
}
