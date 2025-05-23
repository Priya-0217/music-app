import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'component/BackgroundVideo.dart';
import 'component/themeNotifier.dart'; // ✅ import it

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: BackgroundVideo(videoAsset: 'assets/angryHome.mp4'), // 🔥
          ),
          Positioned.fill(
            child: child,
          ),
        ],
      ),
    );
  }
}
