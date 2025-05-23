import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart'; // For audio player

class ExpandableDynamicIsland extends StatefulWidget {
  final String songTitle;
  final Duration currentPosition;
  final Duration totalDuration;
  final bool isPlaying;
  final Function onPlayPause;
  final Function onNext;
  final Function onPrevious;

  const ExpandableDynamicIsland({
    required this.songTitle,
    required this.currentPosition,
    required this.totalDuration,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  _ExpandableDynamicIslandState createState() => _ExpandableDynamicIslandState();
}

class _ExpandableDynamicIslandState extends State<ExpandableDynamicIsland> {
  bool _isExpanded = false; // To track whether the dynamic island is expanded

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded; // Toggle expansion
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(30),
          ),
          child: _isExpanded
              ? _buildExpandedView()
              : _buildCollapsedView(),
        ),
      ),
    );
  }

  // Collapsed view: Shows the song title and play/pause icon
  Widget _buildCollapsedView() {
    return Row(
      children: [
        Icon(
          widget.isPlaying ? Icons.music_note : Icons.pause,
          color: Colors.white,
          size: 24,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            widget.songTitle,
            style: TextStyle(color: Colors.white, fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: SizedBox(
            width: 50,
            child: Text(
              "${(widget.currentPosition.inSeconds ~/ 60).toString().padLeft(2, '0')}:${(widget.currentPosition.inSeconds % 60).toString().padLeft(2, '0')}",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  // Expanded view: Shows controls like play/pause, next, previous, and progress bar
  Widget _buildExpandedView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Song title and play/pause button
        Row(
          children: [
            Icon(
              widget.isPlaying ? Icons.music_note : Icons.pause,
              color: Colors.white,
              size: 24,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.songTitle,
                style: TextStyle(color: Colors.white, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              onPressed: () => widget.onPlayPause(),
              icon: Icon(
                widget.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
            ),
          ],
        ),
        // Progress bar
        Slider(
          value: widget.currentPosition.inSeconds.toDouble(),
          min: 0,
          max: widget.totalDuration.inSeconds.toDouble(),
          onChanged: (value) {
            // Seek to the new position
            widget.onPlayPause(); // Can also call seek function here
          },
        ),
        // Control buttons for next and previous
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => widget.onPrevious(),
              icon: Icon(Icons.skip_previous, color: Colors.white),
            ),
            IconButton(
              onPressed: () => widget.onNext(),
              icon: Icon(Icons.skip_next, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
