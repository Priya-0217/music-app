import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:myflutterproject/component/customNavBar.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/src/videos/video.dart';
import '../models/songModel.dart';
import '../services/songService.dart';

class YTMusicStylePlayer extends StatefulWidget {
  const YTMusicStylePlayer({super.key});

  @override
  State<YTMusicStylePlayer> createState() => _YTMusicStylePlayerState();
}

class _YTMusicStylePlayerState extends State<YTMusicStylePlayer> {



  final TextEditingController _searchController = TextEditingController();



  late YTMusicService _ytMusicService;

  var index=0;

  bool _isBottomDrawerOpen = false;

  @override
  void initState() {
    super.initState();
  _ytMusicService = Provider.of<YTMusicService>(context, listen: false);

  }


  //
  // void _startProgressTimer() {
  //   _progressTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     if (_currentSong == null) return;
  //     final max = _currentSong!.duration.inSeconds;
  //
  //     setState(() {
  //       if (_currentPosition < max) {
  //         _currentPosition++;
  //         _sliderValue = _currentPosition.toDouble();
  //       } else {
  //         _progressTimer?.cancel();
  //         _isPlaying = false;
  //       }
  //     });
  //   });
  // }
  // Future<void> _relatedSongs() async {
  //   if (_currentSong == null) return;
  //
  //   final songs = await _ytMusicService.getRelatedVideos(_currentSong!);
  //
  //   setState(() {
  //     _relatedSong = songs!;
  //   });
  // }


  // void _stopProgressTimer() {
  //   _progressTimer?.cancel();
  //   _progressTimer = null;
  // }

  // void _togglePlayPause() async {
  //   if (_currentSong == null) return;
  //
  //   final player = _ytMusicService.audioPlayer;
  //
  //   if (player.playing) {
  //     await _ytMusicService.pauseAudio(_currentSong!);
  //   } else {
  //     await _ytMusicService.resumeAudio(_currentSong!, _currentPosition);
  //   }
  // }
  //
  // void _searchSongs(String query) async {
  //   if (query.isEmpty) {
  //     setState(() => _searchResults = []);
  //     return;
  //   }
  //
  //   setState(() => _isSearching = true);
  //   final songs = await _ytMusicService.searchYouTube(query);
  //
  //   setState(() {
  //     _searchResults = songs;
  //     _isSearching = false;
  //   });
  // }
  //
  // void _playSelectedSong(Song song, {bool fetchRelated = false}) async {
  //   setState(() {
  //     _currentSong = song;
  //     _currentPosition = 0;
  //     _sliderValue = 0;
  //     _isPlaying = true;
  //   });
  //
  //   await _ytMusicService.playAudio(song);
  //   // _startProgressTimer();
  //
  //   if (fetchRelated) {
  //     await _relatedSongs();
  //   }
  // }


  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  // Drawer _buildSearchDrawer() {
  //   return Drawer(
  //     backgroundColor: const Color(0xFF1E1E1E),
  //     child: SafeArea(
  //       child: Column(
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.all(16.0),
  //             child: Column(
  //               children: [
  //                 Text(
  //                   "Search Music",
  //                   style: GoogleFonts.poppins(
  //                     fontSize: 22,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 20),
  //                 TextField(
  //                   controller: _searchController,
  //                   style: const TextStyle(color: Colors.white),
  //                   decoration: InputDecoration(
  //                     hintText: "Search...",
  //                     hintStyle: const TextStyle(color: Colors.white54),
  //                     filled: true,
  //                     fillColor: Colors.white12,
  //                     suffixIcon: IconButton(
  //                       icon: const Icon(Icons.search, color: Colors.white),
  //                       onPressed: () async {
  //                         await _ytMusicService.searchInDrawer(_searchController.text);
  //                       },
  //                     ),
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(12),
  //                       borderSide: BorderSide.none,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           const SizedBox(height: 10),
  //           Expanded(
  //             child: _ytMusicService.drawerSearchResults.isEmpty
  //                 ? const Center(
  //               child: Text(
  //                 "No results",
  //                 style: TextStyle(color: Colors.white70),
  //               ),
  //             )
  //                 : ListView(
  //               padding: const EdgeInsets.symmetric(horizontal: 16),
  //               children: _ytMusicService.drawerSearchResults.map((song) {
  //                 return ListTile(
  //                   leading: ClipRRect(
  //                     borderRadius: BorderRadius.circular(8),
  //                     child: Image.network(
  //                       song.thumbnailUrl,
  //                       width: 60,
  //                       height: 60,
  //                       fit: BoxFit.cover,
  //                     ),
  //                   ),
  //                   title: Text(
  //                     song.title,
  //                     maxLines: 1,
  //                     overflow: TextOverflow.ellipsis,
  //                     style: const TextStyle(color: Colors.white),
  //                   ),
  //                   subtitle: Text(
  //                     song.author,
  //                     maxLines: 1,
  //                     overflow: TextOverflow.ellipsis,
  //                     style: const TextStyle(color: Colors.white70),
  //                   ),
  //                   onTap: () {
  //                     _ytMusicService.getRelatedVideos(song);
  //
  //                     Navigator.of(context).pop();
  //                     Future.delayed(
  //                       const Duration(milliseconds: 100),
  //                           () => _ytMusicService.playAudio(song),
  //                     );
  //                   },
  //                 );
  //               }).toList(),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Timer? _debounce;
  Drawer _buildSearchDrawer() {
    return Drawer(
      elevation: 0,
      backgroundColor: Colors.transparent, // Transparent drawer
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    "Search Music",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search...",
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.2), // Slightly visible input box
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: () async {
                          await _ytMusicService.searchInDrawer(_searchController.text);
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      _debounce = Timer(const Duration(milliseconds: 400), () async {
                        await _ytMusicService.searchInDrawer(value);
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            /// Scroll with Fade Effect
            Expanded(
              child: _ytMusicService.drawerSearchResults.isEmpty
                  ? const Center(
                child: Text(
                  "No results",
                  style: TextStyle(color: Colors.white70),
                ),
              )
                  : ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.white,
                      Colors.white,
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.1, 0.9, 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _ytMusicService.drawerSearchResults.length,
                  itemBuilder: (context, index) {
                    final song = _ytMusicService.drawerSearchResults[index];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          song.thumbnailUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        song.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        song.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      onTap: () async {
                        Navigator.of(context).pop();
                      _ytMusicService.playAudio(song);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  // Widget _buildBottomDrawerContent() {
  //   return Container(
  //     decoration: const BoxDecoration(
  //         gradient: LinearGradient(
  //             begin: Alignment.topCenter,
  //             end: Alignment.topCenter,
  //             stops: const [0, 1.0],
  //             colors: [Colors.transparent, Colors.black])
  //
  //     ),
  //     padding: const EdgeInsets.all(16),
  //     child: Column(
  //       children: [
  //         // Optional: Add a small drag handle or title here
  //         Expanded(
  //           child: ListView(
  //             padding: const EdgeInsets.symmetric(horizontal: 16),
  //             children: _ytMusicService.relatedSongs.map((song) {
  //               return ListTile(
  //                 leading: ClipRRect(
  //                   borderRadius: BorderRadius.circular(8),
  //                   child: Image.network(
  //                     song.thumbnailUrl,
  //                     width: 60,
  //                     height: 60,
  //                     fit: BoxFit.cover,
  //                   ),
  //                 ),
  //                 title: Text(
  //                   song.title,
  //                   maxLines: 1,
  //                   overflow: TextOverflow.ellipsis,
  //                   style: const TextStyle(color: Colors.white),
  //                 ),
  //                 subtitle: Text(
  //                   song.author,
  //                   maxLines: 1,
  //                   overflow: TextOverflow.ellipsis,
  //                   style: const TextStyle(color: Colors.white70),
  //                 ),
  //                 onTap: () {
  //                   Navigator.of(context).pop();
  //                   Future.delayed(
  //                     const Duration(milliseconds: 100),
  //                         () => _ytMusicService.playAudio(song),
  //                   );
  //                 },
  //               );
  //             }).toList(),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // void playnext() {
  //   if (_relatedSong.isNotEmpty) {
  //     final nextIndex = (index + 1) % _relatedSong.length;
  //     final nextSong = _relatedSong[nextIndex];
  //     _playSelectedSong(nextSong,fetchRelated: false);
  //
  //     setState(() {
  //       index = nextIndex;
  //     });
  //
  //
  //   } else {
  //     print("No related songs found");
  //   }
  // }
  Widget _buildBottomDrawerContent() {
    final relatedSongs = _ytMusicService.relatedSongs;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.transparent, // Transparent background
      child: Stack(
        children: [
          // Song list with fade using ShaderMask
          relatedSongs.isEmpty
              ? const Center(
            child: CircularProgressIndicator(color: Colors.white),
          )
              : ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.white,
                  Colors.white,
                  Colors.transparent,
                ],
                stops: [0.0, 0.05, 0.95, 1.0],
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstIn,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: relatedSongs.length,
              itemBuilder: (context, index) {
                final song = relatedSongs[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      song.thumbnailUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    song.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    song.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  onTap: () {
                    Future.delayed(
                      const Duration(milliseconds: 100),
                          () => _ytMusicService.playAudio(song),
                    );
                  },
                );
              },
            ),
          ),

          // Optional: Top fade overlay (already handled by ShaderMask, but you can keep if you want a stronger fade)
          // Positioned(
          //   top: 0,
          //   left: 0,
          //   right: 0,
          //   height: 40,
          //   child: IgnorePointer(
          //     child: DecoratedBox(
          //       decoration: BoxDecoration(
          //         gradient: LinearGradient(
          //           begin: Alignment.topCenter,
          //           end: Alignment.bottomCenter,
          //           colors: [Colors.black, Colors.transparent],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }






  Widget _iconText(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(label,
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ytMusicService = Provider.of<YTMusicService>(context);
    final currentSong = ytMusicService.currentSong;
    final dominantColor = context.watch<YTMusicService>().dominantColor ?? Colors.red;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            stops: const [0.3 , 1.0],
            colors: [dominantColor, Colors.black]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        drawer: _buildSearchDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.queue_music, color: Colors.white),
              onPressed: (){

                setState(() {
                _isBottomDrawerOpen = !_isBottomDrawerOpen;
              });}
            ),
          ],
        ),
        body: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              top: _isBottomDrawerOpen ? 40 : 0,
              left: 0,
              right: 0,
              bottom: _isBottomDrawerOpen
                  ? MediaQuery.of(context).size.height * 0.4
                  : 0,
              child: _buildPlayerContent(),
            ),
            if (_isBottomDrawerOpen)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height * 0.6,
                child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: _isBottomDrawerOpen ? 1.0 : 0.0,
                    child: _buildBottomDrawerContent()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerContent() {
    final maxDuration = _ytMusicService.currentSong?.duration.inSeconds.toDouble() ?? 1;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: _isBottomDrawerOpen
          ? Column(
            children: [

              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 0, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: _ytMusicService.currentSong?.thumbnailUrl ?? 'assets/thumbnail.jpg',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _ytMusicService.currentSong != null
                                ? Transform.scale(
                              scale: 1.2, // Adjust this value to control zoom (1.0 = normal)
                              child: Image.network(
                                _ytMusicService.currentSong!.thumbnailUrl,
                                width: 180,
                                height: 180,
                                fit: BoxFit.cover, // use cover for better zoom appearance
                              ),
                            )
                                : Transform.scale(
                              scale: 1.2,
                              child: Image.asset(
                                'assets/thumbnail.jpg',
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              (_ytMusicService.currentSong!.title ?? "No Song").firstWords(2),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              (_ytMusicService.currentSong?.author ?? "").firstWords(2),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.skip_previous,
                                      size: 32, color: Colors.white),
                                  onPressed: () {},
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle, color: Colors.white),
                                  child: IconButton(
                                    icon: Icon(
                                        (_ytMusicService.currentSong?.isPlaying ?? false)


                                            ? Icons.pause_sharp
                                            : Icons.play_arrow_sharp,
                                        color: Colors.black),
                                    iconSize: 30,
                                    onPressed: () {
                                      print(_ytMusicService.currentSong!);
                                      print("asssssssssssssssssssssssssss");
                                      _ytMusicService.currentSong!.isPlaying
                                          ? _ytMusicService.pauseAudio(_ytMusicService.currentSong!)
                                          :_ytMusicService.resumeAudio(_ytMusicService.currentSong!,_ytMusicService.currentPosition);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                IconButton(
                                  icon: const Icon(Icons.skip_next,
                                      size: 32, color: Colors.white),
                                  onPressed: () {
                                    // playnext();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              // Slider(
              //   min: 0,
              //   max: maxDuration,
              //   value: _sliderValue.clamp(0.0, maxDuration),
              //   activeColor: Colors.white,
              //   inactiveColor: Colors.grey,
              //   onChanged: (value) {
              //     final clamped = value.clamp(0.0, maxDuration);
              //     setState(() {
              //       _sliderValue = clamped;
              //       _currentPosition = clamped.toInt();
              //     });
              //     _ytMusicService.seekTo(_currentSong!, _currentPosition);
              //   },
              // ),
              Slider(


                activeColor: Colors.white,
               inactiveColor: Colors.grey,
                value: _ytMusicService.currentPosition.inSeconds.toDouble(),
                min: 0,
                max: _ytMusicService.currentDuration.inSeconds.toDouble(),
                onChanged: (value) {
                  _ytMusicService.seekTo(_ytMusicService.currentSong!, value.toInt());
                },
              )
            ],
          )
          : Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                children: [
               ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _ytMusicService.currentSong != null
                        ? Transform.scale(
                      scale: 1.3, // Adjust this value to control zoom (1.0 = normal)
                      alignment: Alignment.bottomCenter,
                      child: Image.network(
                        _ytMusicService.currentSong!.thumbnailUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover, // use cover for better zoom appearance
                      ),
                    )
                        : Transform.scale(
                      scale: 1.2,
                      child: Image.asset(
                        'assets/thumbnail.jpg',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black, Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_ytMusicService.currentSong!= null)
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      children: [
                        Container(
                          height: 32,
                          alignment: Alignment.centerLeft,
                          child: Marquee(
                            text:
                            '${_ytMusicService.currentSong!.title}  •  ${_ytMusicService.currentSong!.author}',
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                            blankSpace: 60.0,
                            velocity: 30.0,
                          ),
                        ),
                        Slider(
                          activeColor: Colors.white,
                          inactiveColor: Colors.grey,
                          value: _ytMusicService.currentPosition.inSeconds.toDouble(),
                          min: 0,
                          max: _ytMusicService.currentDuration.inSeconds.toDouble(),
                          onChanged: (value) {
                            _ytMusicService.seekTo(_ytMusicService.currentSong!, value.toInt());
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                '${_ytMusicService.currentPosition.inMinutes}:${(_ytMusicService.currentPosition.inSeconds % 60).toString().padLeft(2, '0')} / '
                            ),
                            Text(
                                '${_ytMusicService.currentDuration.inMinutes}:${(_ytMusicService.currentDuration.inSeconds % 60).toString().padLeft(2, '0')}'
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_previous,
                          size: 32, color: Colors.white),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 30),
                    Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: IconButton(
                        icon: Icon(
                            (_ytMusicService.currentSong?.isPlaying ?? false)


                                ? Icons.pause_sharp
                                : Icons.play_arrow_sharp,
                            color: Colors.black),
                        iconSize: 30,
                        onPressed: () {
                          print(_ytMusicService.currentSong!);
                          print("asssssssssssssssssssssssssss");
                          _ytMusicService.currentSong!.isPlaying
                              ? _ytMusicService.pauseAudio(_ytMusicService.currentSong!)
                              :_ytMusicService.resumeAudio(_ytMusicService.currentSong!,_ytMusicService.currentPosition);
                        },
                      ),
                    ),
                    const SizedBox(width: 30),
                    IconButton(
                      icon: const Icon(Icons.skip_next,
                          size: 32, color: Colors.white),
                      onPressed: () {
                        // playnext();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _iconText(Icons.favorite_border, "332K"),
                    _iconText(Icons.share, "Share"),
                    _iconText(Icons.bookmark_border, "Save"),
                    _iconText(Icons.video_library, "Video"),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

extension StringShortener on String {
  String firstWords(int count) {
    final words = trim().split(RegExp(r'\s+'));
    return words.take(count).join(' ');
  }
}


