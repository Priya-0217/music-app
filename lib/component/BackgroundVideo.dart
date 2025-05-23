import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BackgroundVideo extends StatefulWidget {
  final String? videoAsset; // Path to your video asset (nullable)
  final String? imageAsset; // Path to your image asset (nullable)

  const BackgroundVideo({super.key, this.videoAsset, this.imageAsset});

  @override
  State<BackgroundVideo> createState() => _BackgroundVideoState();
}

class _BackgroundVideoState extends State<BackgroundVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    // If a video path is provided, initialize the video player
    if (widget.videoAsset != null) {
      _controller = VideoPlayerController.asset(
        widget.videoAsset!,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      )
        ..initialize().then((_) {
          setState(() {}); // When initialization is done
          _controller.play();
          _controller.setVolume(0); // Mute video if needed
          _controller.setLooping(true); // Loop playback
        });
    }
  }

  @override
  void dispose() {
    if (widget.videoAsset != null) {
      _controller.dispose();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    if (widget.videoAsset != null) {
      // If a video is provided
      return _controller.value.isInitialized
          ? Stack(
        children: [
          // Background video
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: screenSize.width,
                height: screenSize.height,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
        ],
      )
          : const SizedBox(); // Show nothing until video loads
    } else if (widget.imageAsset != null) {
      // If an image is provided
      return Positioned.fill(
        child: Image.asset(
          widget.imageAsset!,
          fit: BoxFit.cover,
        ),
      );
    } else {
      // If neither a video nor an image is provided
      return const SizedBox(); // Show nothing if neither is provided
    }
  }
}
