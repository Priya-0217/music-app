import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class Song {
  final String title;
  final String author;
  final String thumbnailUrl; // Can be YT thumbnail or album cover from YT Music
  final String videoId;
  final Duration duration;
  bool isPlaying = false;
  String? audioUrl; // Loaded lazily when needed

  static const String defaultThumbnailAsset = 'assets/thumbnail.jpg';

  Song({
    this.title = "Unknown",
    this.author = "Unknown",
    this.thumbnailUrl = defaultThumbnailAsset,
    required this.videoId,
    this.duration = const Duration(seconds: 0), required audioUrl,
  });

  // Factory constructor to allow external override of thumbnail
  factory Song.fromVideo(Video video, {String? overrideThumbnail}) {
    return Song(
      title: video.title,
      author: video.author,
      thumbnailUrl: overrideThumbnail ??
          (video.thumbnails.highResUrl.isNotEmpty
              ? video.thumbnails.highResUrl
              : defaultThumbnailAsset),
      videoId: video.id.value,
      duration: video.duration ?? Duration.zero, audioUrl: null,
    );
  }
}
