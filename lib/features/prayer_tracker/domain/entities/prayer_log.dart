import 'package:equatable/equatable.dart';

/// Domain Entity: Prayer Log
/// Represents a single prayer log entry in the domain layer
/// This is a pure business object with no dependencies on external frameworks
class PrayerLog extends Equatable {
  final int? id;
  final String prayerName;
  final DateTime prayerDate;
  final DateTime prayerTime;
  final String status; // masjid, alone, qaza, missed, pending
  final DateTime loggedAt;
  final String? notes;

  const PrayerLog({
    this.id,
    required this.prayerName,
    required this.prayerDate,
    required this.prayerTime,
    required this.status,
    required this.loggedAt,
    this.notes,
  });

  /// Create a copy with modified fields
  PrayerLog copyWith({
    int? id,
    String? prayerName,
    DateTime? prayerDate,
    DateTime? prayerTime,
    String? status,
    DateTime? loggedAt,
    String? notes,
  }) {
    return PrayerLog(
      id: id ?? this.id,
      prayerName: prayerName ?? this.prayerName,
      prayerDate: prayerDate ?? this.prayerDate,
      prayerTime: prayerTime ?? this.prayerTime,
      status: status ?? this.status,
      loggedAt: loggedAt ?? this.loggedAt,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        prayerName,
        prayerDate,
        prayerTime,
        status,
        loggedAt,
        notes,
      ];

  @override
  String toString() {
    return 'PrayerLog(id: $id, prayerName: $prayerName, prayerDate: $prayerDate, status: $status)';
  }
}
