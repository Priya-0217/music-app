import 'package:flutter/material.dart';
import 'package:myflutterproject/component/customNavBar.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../services/songService.dart';

class UserPage extends StatefulWidget {
  final String username;
  final String reciverUID;

  const UserPage({required this.username, required this.reciverUID});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with SingleTickerProviderStateMixin {
  bool isSyncExpanded = false;
  bool isButtonExpanded = false;
  bool isSyncEnabled = false;

  void _giveHapticFeedback() {
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade400, Colors.indigo.shade800],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),

                // Avatar and Name
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 55,
                    backgroundImage: AssetImage('assets/img.png'),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  widget.username,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),

                SizedBox(height: 40),

                // Sync Expandable Tile
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isSyncExpanded = !isSyncExpanded;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    height: isSyncExpanded ? 180 : 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Sync Playback",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              Switch.adaptive(
                                activeColor: Colors.white,
                                activeTrackColor: Colors.deepPurple.shade300,
                                value: context.watch<YTMusicService>().isSyncEnabled,
                                onChanged: (bool value) {
                                  context.read<YTMusicService>().updateSyncStatus(value, widget.reciverUID);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(value ? "Sync enabled" : "Sync disabled"),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          if (isSyncExpanded) ...[
                            SizedBox(height: 15),
                            Text(
                              "Sync ensures both users listen to the same song at the same time.",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40),

                // Expandable Button
                GestureDetector(
                  onTap: () {
                    _giveHapticFeedback();
                    setState(() {
                      isButtonExpanded = !isButtonExpanded;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    height: isButtonExpanded ? 150 : 70,
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 12,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Click Me",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                              color: Colors.white,
                            ),
                          ),
                          if (isButtonExpanded) ...[
                            SizedBox(height: 12),
                            Text(
                              "You tapped the button!\nMore options can be added here.",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                                height: 1.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SwipeNavbarExample(),
      ),
    );
  }
}
