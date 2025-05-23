import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myflutterproject/component/BackgroundVideo.dart';
import 'package:myflutterproject/pages/stac.dart';
import 'package:provider/provider.dart';

import 'package:myflutterproject/chatPage/chat_page.dart';
import 'package:myflutterproject/component/UserTile.dart';
import 'package:myflutterproject/component/customNavBar.dart';
import 'package:myflutterproject/component/drawer.dart';
import 'package:myflutterproject/mainScaffold.dart';
import 'package:myflutterproject/services/chat_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../component/themeNotifier.dart';
import 'signup.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatServices _chatService = ChatServices();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool showCard=true;
  String? selectedVideoPath; // nullable


  final List<String> videoPaths = [
    'assets/sadrain.mp4',      // Sad
    'assets/angryHome.mp4',     // Angry
    'assets/balloonfly.mp4',   // Happy
    'assets/LoveHome.mp4',  // Love
  ];


  Future<void> _deleteAndLogout(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.delete();
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignupPage()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account deleted and logged out.")),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please log in again to delete your account."),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.message}")),
        );
      }
    }
  }
  @override
  void initState() {
    super.initState();
    _loadSelectedVideoPath();
  }

  void _loadSelectedVideoPath() async {
    final prefs = await SharedPreferences.getInstance();
    int index = prefs.getInt('selectedIndex') ?? 0;
    print("index $index");

    setState(() {
      selectedVideoPath = videoPaths[index];
    });
  }


  Future<void> _handleRefresh() async {
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();


    return Theme(
      data: themeProvider.themeData,
      child: MainScaffold(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Home Page"),
            actions: [
              IconButton(
                onPressed: () => _deleteAndLogout(context),
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          drawer: MyDrawer(),
          body: Stack(
            children: [
              if (selectedVideoPath != null)
                BackgroundVideo(videoAsset: selectedVideoPath!) // safely unwrapped
              else
                SizedBox(), // Fallback asset
             // Background Animation
              LiquidPullToRefresh(
                color: Theme.of(context).colorScheme.inversePrimary,
                springAnimationDurationInMilliseconds: 300,
                height: 50,
                borderWidth: 10,
                onRefresh: _handleRefresh,
                showChildOpacityTransition: false,
                child: _buildUserList(),
              ),
              showCard? InkWell(
                child: StacJsonWidget(jsonPath: "https://raw.githubusercontent.com/pratiksingh1702/uijson/refs/heads/main/ui.json"),
                onTap: (){

                  setState(() {
                    showCard=false;
                  });
                },
              ): SizedBox(),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: SwipeNavbarExample(),
              ),
            ],
          ),
          // bottomNavigationBar: CurvedNavigationBar(
          //   backgroundColor: themeProvider.themeData.colorScheme.inversePrimary,
          //   color: themeProvider.themeData.colorScheme.surface,
          //   index: 2, // Happy mood as default
          //   items: const [
          //     Icon(Icons.cloud, size: 30),   // Sad
          //     Icon(Icons.whatshot, size: 30), // Angry
          //     Icon(Icons.wb_sunny, size: 30), // Happy
          //     Icon(Icons.favorite, size: 30), // Love
          //   ],
          //   onTap: (index) {
          //  // Change mood-based theme
          //   },
          // ),
        ),
      ),
    );
  }
  // Future<Widget> loadBG() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return Container();
  //
  // }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final users = snapshot.data!;
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: users
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    if (userData['email'] != _auth.currentUser?.email) {
      return UserTile(
        username: userData['username'],
        email: userData["email"],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                reciversEmail: userData['email'],
                reciverID: userData['uid'],
                username: userData['username'],
              ),
            ),
          );
        },
      );
    } else {
      return const SizedBox();
    }
  }
}
