import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/prayer_log.dart';

part 'prayer_log_model.g.dart';

/// Data Model: Prayer Log Model
/// Extends domain entity and adds JSON serialization
/// This is used in the data layer for database and API operations
@JsonSerializable()
class PrayerLogModel extends PrayerLog {
  const PrayerLogModel({
    super.id,
    required super.prayerName,
    required super.prayerDate,
    required super.prayerTime,
    required super.status,
    required super.loggedAt,
    super.notes,
  });

  /// Create model from domain entity
  factory PrayerLogModel.fromEntity(PrayerLog entity) {
    return PrayerLogModel(
      id: entity.id,
      prayerName: entity.prayerName,
      prayerDate: entity.prayerDate,
      prayerTime: entity.prayerTime,
      status: entity.status,
      loggedAt: entity.loggedAt,
      notes: entity.notes,
    );
  }

  /// Create model from JSON
  factory PrayerLogModel.fromJson(Map<String, dynamic> json) =>
      _$PrayerLogModelFromJson(json);

  /// Convert model to JSON
  Map<String, dynamic> toJson() => _$PrayerLogModelToJson(this);

  /// Create model from database map
  factory PrayerLogModel.fromDatabase(Map<String, dynamic> map) {
    return PrayerLogModel(
      id: map['id'] as int?,
      prayerName: map['prayer_name'] as String,
      prayerDate: DateTime.parse(map['prayer_date'] as String),
      prayerTime: DateTime.parse(map['prayer_time'] as String),
      status: map['status'] as String,
      loggedAt: DateTime.parse(map['logged_at'] as String),
      notes: map['notes'] as String?,
    );
  }

  /// Convert model to database map
  Map<String, dynamic> toDatabase() {
    return {
      if (id != null) 'id': id,
      'prayer_name': prayerName,
      'prayer_date': prayerDate.toIso8601String().split('T')[0], // Date only
      'prayer_time': prayerTime.toIso8601String(),
      'status': status,
      'logged_at': loggedAt.toIso8601String(),
      'notes': notes,
    };
  }

  /// Convert to domain entity
  PrayerLog toEntity() {
    return PrayerLog(
      id: id,
      prayerName: prayerName,
      prayerDate: prayerDate,
      prayerTime: prayerTime,
      status: status,
      loggedAt: loggedAt,
      notes: notes,
    );
  }

  @override
  PrayerLogModel copyWith({
    int? id,
    String? prayerName,
    DateTime? prayerDate,
    DateTime? prayerTime,
    String? status,
    DateTime? loggedAt,
    String? notes,
  }) {
    return PrayerLogModel(
      id: id ?? this.id,
      prayerName: prayerName ?? this.prayerName,
      prayerDate: prayerDate ?? this.prayerDate,
      prayerTime: prayerTime ?? this.prayerTime,
      status: status ?? this.status,
      loggedAt: loggedAt ?? this.loggedAt,
      notes: notes ?? this.notes,
    );
  }
}
