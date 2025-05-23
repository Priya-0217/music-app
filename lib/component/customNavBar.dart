import 'package:flutter/material.dart';
import 'package:myflutterproject/pages/HomePage.dart';
import 'package:myflutterproject/pages/settings.dart';
import 'package:myflutterproject/test.dart';
import 'package:myflutterproject/pages/ytPlayer.dart';
import 'package:provider/provider.dart';
import 'package:swipe/swipe.dart';

import '../pages/stac.dart';
import '../services/songService.dart';

class SwipeNavbarExample extends StatefulWidget {
  const SwipeNavbarExample({super.key});

  @override
  _SwipeNavbarExampleState createState() => _SwipeNavbarExampleState();
}

class _SwipeNavbarExampleState extends State<SwipeNavbarExample> {
  bool _isNavbarVisible = true;
  bool _isMusicDoubleTapped = false; // To track double tap on the music icon

  void _toggleNavbar(bool show) {
    if (_isNavbarVisible != show) {
      setState(() {
        _isNavbarVisible = show;
      });
    }
  }

  void _toggleMusicState() {
    setState(() {
      _isMusicDoubleTapped = !_isMusicDoubleTapped;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ytMusicService = Provider.of<YTMusicService>(context);
    final currentSong = ytMusicService.currentSong;
    return Swipe(
      verticalMinDisplacement: 10,
      verticalMinVelocity: 10,
      onSwipeUp: () => _toggleNavbar(false),
      onSwipeDown: () => _toggleNavbar(true),
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 100),
        opacity: _isNavbarVisible ? 1.0 : 0.2,
        child: Container(
          height: 60,
          margin: EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Show this only if music is not double-tapped
              if (!_isMusicDoubleTapped) ...[
                IconButton(
                  icon: Icon(Icons.home, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.settings, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Settings()));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.person, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>StacJsonWidget(jsonPath: "assets/ui.json",)));
                  },
                ),
              ],

              // Music button (double tap to toggle)
              IconButton(
                icon: Icon(Icons.music_note_rounded, color: Colors.white),
                onLongPress: _toggleMusicState, onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context)=>YTMusicStylePlayer())); },
              ),

              // Show this only if music is double-tapped
              if (_isMusicDoubleTapped) ...[
                CircleAvatar(
                  radius: 20,
                  backgroundImage: currentSong != null
                      ? NetworkImage(currentSong.thumbnailUrl) // NetworkImage for online thumbnail
                      : AssetImage('assets/thumbnail.jpg') as ImageProvider, // AssetImage for fallback
                ),
                Slider(


                  activeColor: Colors.white,
                  inactiveColor: Colors.grey,
                  value: ytMusicService.currentPosition.inSeconds.toDouble(),
                  min: 0,
                  max: ytMusicService.currentDuration.inSeconds.toDouble(),
                  onChanged: (value) {
                    ytMusicService.seekTo(ytMusicService.currentSong!, value.toInt());
                  },
                )
              ],
            ],
          ),
        ),
      ),
    );
  }
}
