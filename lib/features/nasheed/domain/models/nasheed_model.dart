import 'package:equatable/equatable.dart';

/// Nasheed Model
/// Represents an Islamic nasheed/video
class NasheedModel extends Equatable {
  final String id;
  final String title;
  final String artist;
  final String youtubeUrl;
  final String thumbnailUrl;
  final String duration;
  final int views;

  const NasheedModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.youtubeUrl,
    required this.thumbnailUrl,
    required this.duration,
    required this.views,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        artist,
        youtubeUrl,
        thumbnailUrl,
        duration,
        views,
      ];
}
