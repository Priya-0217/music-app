import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart'; // Carousel Slider

import 'package:myflutterproject/component/customNavBar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../component/themeNotifier.dart'; // SharedPreferences for saving index

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int? selectedIndex;  // Store the selected index
  bool showCarousel = false;  // Flag to show/hide carousel
  bool isServiceRunning=false;



  final CarouselSliderController buttonCarouselController = CarouselSliderController();

  // Demo data associated with each animation
  final List<Map<String, String>> demoData = [
    {
      'name': 'Sad Puppy',
      'description': 'Feeling lonely today',
      'animation': 'assets/sad.json'
    },
    {
      'name': 'Broken Bot',
      'description': 'AI with a broken heart',
      'animation': 'assets/angry.json'
    },
    {
      'name': 'Blue Balloon',
      'description': 'Floated away alone',
      'animation': 'assets/happy.json'
    },
    {
      'name': 'Crying Cloud',
      'description': 'Rain of emotions',
      'animation': 'assets/love.json'
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadSelectedIndex();  // Load selected index from SharedPreferences

  }

  // Load the last selected index from SharedPreferences
  _loadSelectedIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? index = prefs.getInt('selectedIndex');
    if (index != null) {
      setState(() {
        selectedIndex = index;
        context.read<ThemeProvider>().setTheme(index);
        showCarousel = false;  // Hide carousel once index is loaded
      });
    }
  }

  // Save the selected index to SharedPreferences
  _saveSelectedIndex(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedIndex', index);
    print("saved $selectedIndex");
  }





  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: SingleChildScrollView(
        child: Center(
          child: GestureDetector(
            onTap: () {
              // Only toggle carousel if no selection is made
              if (selectedIndex == null) {
                setState(() {

                  showCarousel = true;  // Show carousel on tap
                });
              }
            },
            child: showCarousel
                ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CarouselSlider(
                        items: List.generate(demoData.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                                themeProvider.setTheme(index);
                                // Save selected index
                                showCarousel = false;  // Hide carousel after selection
                              });
                              _saveSelectedIndex(index);  // Save selected index
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                  demoData[index]['animation']!,
                                  height: 100,
                                  repeat: true,
                                  animate: true,
                                  fit: BoxFit.contain,
                                ),
                                Text(
                                  demoData[index]['name'] ?? '',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  demoData[index]['description'] ?? '',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          );
                        }),
                        controller: buttonCarouselController,
                        options: CarouselOptions(
                          enlargeCenterPage: true,
                          enableInfiniteScroll: false,
                          autoPlay: false,
                          scrollDirection: Axis.horizontal,
                          viewportFraction: 0.8,
                        ),
                      ),
                      Positioned(
                        left: 10,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            buttonCarouselController.previousPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          },
                        ),
                      ),
                      Positioned(
                        right: 10,
                        child: IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          onPressed: () {
                            buttonCarouselController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (selectedIndex != null) // Check if selectedIndex is not null
                  SizedBox(
                    height: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: (){
                            showCarousel=true;
                            setState(() {

                            });
                          },
                          child: Container(
                            child: Lottie.asset(
                              demoData[selectedIndex!]['animation']!,
                              repeat: true,
                              animate: true,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                demoData[selectedIndex!]['name'] ?? '',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                demoData[selectedIndex!]['description'] ?? '',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 12),
                              Text(
                                "(Tap anywhere to re-select)",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                else
                  Container(), // Avoid rendering if selectedIndex is null
                // Settings and Options with Rounded Container
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'App Settings',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Profile Settings',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Manage your profile details',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 8),
                            Divider(color: Colors.grey.shade400),
                            ListTile(
                              leading: Icon(Icons.account_circle),
                              title: Text("Edit Profile"),
                              onTap: () {
                                // Navigate to Profile Settings
                              },
                            ),
                         
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Wallpapers',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Choose your wallpaper for the app',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 8),
                            Divider(color: Colors.grey.shade400),
                            ListTile(
                              leading: Icon(Icons.wallpaper),
                              title: Text("Change Wallpaper"),
                              onTap: () {
                                // Navigate to Wallpapers
                              },
                            ),
                          ],
                        ),
                      ),
                      // Other settings items here...
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding:  EdgeInsets.all(8.0),
        child: SwipeNavbarExample(),
      ),
    );
  }
}