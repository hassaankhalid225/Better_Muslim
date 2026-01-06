// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrayerLogModel _$PrayerLogModelFromJson(Map<String, dynamic> json) =>
    PrayerLogModel(
      id: (json['id'] as num?)?.toInt(),
      prayerName: json['prayerName'] as String,
      prayerDate: DateTime.parse(json['prayerDate'] as String),
      prayerTime: DateTime.parse(json['prayerTime'] as String),
      status: json['status'] as String,
      loggedAt: DateTime.parse(json['loggedAt'] as String),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$PrayerLogModelToJson(PrayerLogModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'prayerName': instance.prayerName,
      'prayerDate': instance.prayerDate.toIso8601String(),
      'prayerTime': instance.prayerTime.toIso8601String(),
      'status': instance.status,
      'loggedAt': instance.loggedAt.toIso8601String(),
      'notes': instance.notes,
    };
