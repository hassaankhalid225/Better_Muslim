import 'package:equatable/equatable.dart';

/// Domain Entity: Prayer
/// Represents a prayer with its time information
class Prayer extends Equatable {
  final String name;
  final String arabicName;
  final DateTime time;
  final String status;
  final bool isPassed;

  const Prayer({
    required this.name,
    required this.arabicName,
    required this.time,
    required this.status,
    required this.isPassed,
  });

  /// Create a copy with modified fields
  Prayer copyWith({
    String? name,
    String? arabicName,
    DateTime? time,
    String? status,
    bool? isPassed,
  }) {
    return Prayer(
      name: name ?? this.name,
      arabicName: arabicName ?? this.arabicName,
      time: time ?? this.time,
      status: status ?? this.status,
      isPassed: isPassed ?? this.isPassed,
    );
  }

  @override
  List<Object?> get props => [name, arabicName, time, status, isPassed];

  @override
  String toString() {
    return 'Prayer(name: $name, time: $time, status: $status)';
  }
}
