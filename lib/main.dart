import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myflutterproject/component/themeNotifier.dart';
import 'package:myflutterproject/firebase_options.dart';
import 'package:myflutterproject/pages/HomePage.dart';
import 'package:myflutterproject/pages/settings.dart';
import 'package:myflutterproject/pages/signup.dart';
import 'package:myflutterproject/pages/ytPlayer.dart';
import 'package:myflutterproject/services/socket.dart';
import 'package:myflutterproject/services/songService.dart';
import 'package:myflutterproject/component/notification.dart';
import 'package:myflutterproject/mainScaffold.dart';
import 'package:stac/stac.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_dynamic_widget_plugin_lottie/json_dynamic_widget_plugin_lottie.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize socket connection
  await SocketManager().initSocket();

  // Initialize background service
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      autoStart: true,
      onStart: onStart,
      isForegroundMode: true,
      autoStartOnBoot: true,
    ),
  );
  service.startService();

  // Request notification permission
  requestNotificationPermission();
  await Stac.initialize();






  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => YTMusicService()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Important
      ],
      child: const MyApp(),
    ),
  );
}


@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  print("[SERVICE] onStart called");

  if (service is AndroidServiceInstance) {
    await service.setForegroundNotificationInfo(
      title: "YT Music Background Service",
      content: "Service is running...",
    );
  }

  service.on("stop").listen((event) {
    print("[SERVICE] Stopping service");
    service.stopSelf();
  });

  // Timer.periodic(const Duration(seconds: 1), (timer) {
  //   print('Background service running...');
  // });
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getLandingPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    return isLoggedIn ? const YTMusicStylePlayer() : const SignupPage();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getLandingPage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            home: const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Auth Demo',
              theme: themeProvider.themeData, // ⬅️ dynamic theme based on mood
              home: MainScaffold(child: snapshot.data!),
            );
          },
        );
      },
    );
  }
}
