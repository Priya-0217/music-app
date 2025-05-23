import 'package:just_audio/just_audio.dart';
import 'package:myflutterproject/services/socket.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';
import '../models/songModel.dart';

class YTMusicService with ChangeNotifier {
  final YoutubeExplode _yt = YoutubeExplode();
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Song> relatedSongs = [];
  String? _targetUserId;
  Color? dominantColor;
  Timer? _throttleTimer;

  Song? currentSong;
  Duration currentPosition = Duration.zero;
  Duration currentDuration = Duration.zero;
  List<Song> drawerSearchResults = [];
  bool _isSyncEnabled = false;
  late IO.Socket socket;
  bool get isSyncEnabled => _isSyncEnabled;
  String? get targetUserID => _targetUserId;

  void updateSyncStatus(bool isEnabled, String targetUID) {
    _isSyncEnabled = isEnabled;
    _targetUserId = isEnabled ? targetUID : null;
    print(_isSyncEnabled);
    print(_targetUserId);
    _setupSocketListeners();
    notifyListeners();}

  YTMusicService() {
    // Initialize socket
    _initialize();



    // Sync position locally and broadcast every 1s (throttled)
    _audioPlayer.positionStream.listen((position) {
      currentPosition = position;
      if (currentSong != null) {
        if (_throttleTimer == null || !_throttleTimer!.isActive) {
          _throttleTimer = Timer(Duration(seconds: 1), () {
            if (isSyncEnabled) {  // Emit only if sync is enabled
              socket.emit('sync_position', {
                'toUser':_targetUserId,
                'audioUrl': currentSong!.audioUrl,
                'position': currentPosition.inSeconds,
                'timestamp': DateTime.now().millisecondsSinceEpoch,
              });
            }
          });
        }
      }
      notifyListeners();
    });

    _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        currentDuration = duration;
        notifyListeners();
      }
    });

    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed &&
          currentSong != null &&
          relatedSongs.isNotEmpty) {
        nextAudio(relatedSongs, currentSong!);
      }
    });

    updateSyncStatus(isSyncEnabled, '');

  }
  // void setTargetUserId(String id) {
  //   targetUserId = id;
  // }
  Future<void> _initialize() async {
    if (SocketManager().socket == null) {
      await SocketManager().initSocket();
    }
    socket = SocketManager().socket!;

    if (socket == null) {      throw Exception("Socket still not initialized");
    }

    socket!.on('message', (data) {
      print("YTMusicService received: $data");
    });

    // Notify listeners or continue setup
    notifyListeners();
  }

  // Method to toggle sync status
  // void updateSyncStatus(bool value,String reciverId) {
  //   print(targetUserId);
  //   isSyncEnabled = value;
  //   print("dkjhsdhsdgdg $isSyncEnabled");
  //   if(isSyncEnabled){
  //     _setupSocketListeners();
  //     targetUserId=reciverId;
  //   }else{
  //     targetUserId=null;
  //   }
  //   notifyListeners();
  // }

  void _setupSocketListeners() {
    socket.on('play_audio', (data) async {
      final audioUrl = data['audioUrl'];
      final position = Duration(seconds: data['position']);
      final title = data['title'];
      final videoId = data['videoId'];

      if (currentSong == null || currentSong!.audioUrl != audioUrl) {
        Song syncedSong = Song(
          title: title,
          videoId: videoId,
          thumbnailUrl: "https://i.ytimg.com/vi/$videoId/hqdefault.jpg",
          audioUrl: audioUrl,
        );

        currentSong = syncedSong;

        await _audioPlayer.seek(position);
        syncedSong.isPlaying = true;
        _audioPlayer.play();
        _extractDominantColor(syncedSong.thumbnailUrl);
        fetchRelatedSongs();
        notifyListeners();
      } else if (currentSong!.isPlaying == false) {
        currentSong!.isPlaying = true;
        _audioPlayer.play();
        socket.emit('resume_audio', {
          'toUser':_targetUserId,
          'audioUrl': currentSong!.audioUrl,
          'position': currentPosition.inSeconds,
          'title': currentSong!.title,
          'videoId': currentSong!.videoId,
        });
        notifyListeners();
      }
    });

    socket.on('resume_audio', (data) async {
      final position = Duration(seconds: data['position']);
      if (currentSong != null && !currentSong!.isPlaying) {
        await _audioPlayer.seek(position);
        currentSong!.isPlaying = true;
        resumeAudio(currentSong!, position);
        notifyListeners();
      }
    });

    socket.on('pause_audio', (data) async {
      if (currentSong != null && currentSong!.isPlaying) {
        currentSong!.isPlaying = false;
        await _audioPlayer.pause();
        // socket.emit('pause_audio', {
        //   'audioUrl': currentSong!.audioUrl,
        //   'position': currentPosition.inSeconds,
        //   'timestamp': DateTime.now().millisecondsSinceEpoch,
        // });
        notifyListeners();
      }
    });

    socket.on('sync_position', (data) async {
      final audioUrl = data['audioUrl'];
      final incomingPosition = Duration(seconds: data['position']);
      final timestamp = data['timestamp'];
      final now = DateTime.now().millisecondsSinceEpoch;
      final delay = Duration(milliseconds: (now - timestamp).toInt());
      final expectedPosition = incomingPosition + delay;

      if (audioUrl == currentSong?.audioUrl) {
        final drift = (expectedPosition - currentPosition).inSeconds;
        if (drift.abs() > 2 && currentSong!.isPlaying) {
          await seekTo(currentSong!, expectedPosition.inSeconds);
        }
      }
    });
  }

  Future<void> playAudio(Song song) async {
    if (song.isPlaying) return;
    if (song.audioUrl == null) {
      final manifest =
      await _yt.videos.streamsClient.getManifest(VideoId(song.videoId));
      final audioStream = manifest.audioOnly.withHighestBitrate();
      song.audioUrl = audioStream.url.toString();

      await _audioPlayer.setUrl(song.audioUrl!);
    }

    song.isPlaying = true;
    currentSong = song;
    print("Playing audio on screen XYZ: ${song.title}");


    // await _setAudioUrlWithRetry(song);

    socket.emit('play_audio', {
      'toUser':_targetUserId,
      'audioUrl': song.audioUrl,
      'position': 0,
      'title': song.title,
      'videoId': song.videoId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    _audioPlayer.play();
    _extractDominantColor(song.thumbnailUrl);
    fetchRelatedSongs();
    notifyListeners();
  }

  Future<void> pauseAudio(Song song) async {
    if (!song.isPlaying) return;
    song.isPlaying = false;
    socket.emit('pause_audio', {
      'toUser':_targetUserId,
      'audioUrl': song.audioUrl,
      'position': currentPosition.inSeconds,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
    await _audioPlayer.pause();
    notifyListeners();
  }

  Future<void> resumeAudio(Song song, Duration position) async {
    if (song.audioUrl == null) return;
    if (!song.isPlaying) {
      await _audioPlayer.seek(position);
      song.isPlaying = true;
      socket.emit('resume_audio', {
        'toUser':_targetUserId,
        'audioUrl': song.audioUrl,
        'position': position.inSeconds,
        'title': song.title,
        'videoId': song.videoId,
      });
      await _audioPlayer.play();
      notifyListeners();
    }
  }

  Future<void> stopAudio(Song song) async {
    song.isPlaying = false;
    await _audioPlayer.stop();
    notifyListeners();
  }

  Future<void> nextAudio(List<Song> relatedSongs, Song currentSong) async {
    if (relatedSongs.isEmpty) return;
    final currentIndex = relatedSongs.indexOf(currentSong);
    final nextSong = relatedSongs[(currentIndex + 1) % relatedSongs.length];
    await playAudio(nextSong);
  }

  Future<void> previousAudio(List<Song> relatedSongs, Song currentSong) async {
    if (relatedSongs.isEmpty) return;
    final currentIndex = relatedSongs.indexOf(currentSong);
    final prevSong =
    relatedSongs[(currentIndex - 1 + relatedSongs.length) % relatedSongs.length];
    await playAudio(prevSong);
  }

  Future<void> seekTo(Song song, int positionInSeconds) async {
    if (song.audioUrl == null || !song.isPlaying) return;
    await _audioPlayer.seek(Duration(seconds: positionInSeconds));
  }

  Future<void> fetchRelatedSongs() async {
    if (currentSong == null) return;
    final related = await getRelatedVideos(currentSong!);
    if (related != null) {
      relatedSongs =
          related.where((song) => song.videoId != currentSong!.videoId).toList();
      notifyListeners();
    }
  }

  Future<List<Song>?> getRelatedVideos(Song song) async {
    final video = await _yt.videos.get(VideoId(song.videoId));
    final relatedVideosList = await _yt.videos.getRelatedVideos(video);
    return relatedVideosList
        ?.whereType<Video>()
        .map((v) => Song.fromVideo(v))
        .toList();
  }

  Future<void> _extractDominantColor(String url) async {
    final PaletteGenerator palette =
    await PaletteGenerator.fromImageProvider(NetworkImage(url));
    dominantColor = palette.dominantColor?.color ?? Colors.black;
  }

  Future<void> _setAudioUrlWithRetry(Song song) async {
    try {
      await _audioPlayer.setUrl(song.audioUrl!);
    } catch (_) {
      final manifest =
      await _yt.videos.streamsClient.getManifest(VideoId(song.videoId));
      final audioStream = manifest.audioOnly.withHighestBitrate();
      song.audioUrl = audioStream.url.toString();
      await _audioPlayer.setUrl(song.audioUrl!);
    }
  }

  Future<void> searchInDrawer(String query) async {
    drawerSearchResults = await searchYouTube(query);
    notifyListeners();
  }

  Future<List<Song>> searchYouTube(String query) async {
    final searchList = await _yt.search.search(query);
    final results = searchList.whereType<Video>().take(10).toList();
    final songFutures =
    results.map((video) async => Song.fromVideo(video)).toList();
    return await Future.wait(songFutures);
  }

  AudioPlayer get audioPlayer => _audioPlayer;
  Duration get currentPositionInSec => currentPosition;
  Duration get currentDurationInSec => currentDuration;
}
