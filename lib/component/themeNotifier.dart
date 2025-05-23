import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Mood { sad, angry, happy, love } // ✅ ADD THIS!

class ThemeProvider with ChangeNotifier {
  ThemeData _currentTheme = ThemeData.light(); // Default theme
  Mood _currentMood = Mood.happy; // Default mood

  ThemeData get themeData => _currentTheme;
  Mood get currentMood => _currentMood;

  // Load saved theme at app start
  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? index = prefs.getInt('selectedIndex'); // Get saved theme index
    if (index == null) {
      // No saved theme, use default (happy) theme
      _currentTheme = _happyTheme();
      _currentMood = Mood.happy;
    } else {
      // Apply saved theme
     setTheme(index);
    }
    notifyListeners();
  }

  // Set a new theme based on the selected index
  Future<void> setTheme(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedIndex', index); // Save selected index
    _applyTheme(index);
    notifyListeners();
  }

  // Apply theme and mood based on index
  void _applyTheme(int index) {
    switch (index) {
      case 0:
        _currentTheme = _sadTheme();
        _currentMood = Mood.sad;
        break;
      case 1:
        _currentTheme = _angryTheme();
        _currentMood = Mood.angry;
        break;
      case 2:
        _currentTheme = _happyTheme();
        _currentMood = Mood.happy;
        break;
      case 3:
        _currentTheme = _loveTheme();
        _currentMood = Mood.love;
        break;
      default:
        _currentTheme = _happyTheme();
        _currentMood = Mood.happy;
    }
  }

  // 🔥 This returns correct background animation based on mood
  Widget getBackgroundAnimation() {
    switch (_currentMood) {
      case Mood.sad:
        return Lottie.asset('assets/sad.json', fit: BoxFit.cover);
      case Mood.angry:
        return Lottie.asset('assets/angry.json', fit: BoxFit.cover);
      case Mood.happy:
        return Lottie.asset('assets/happy.json', fit: BoxFit.cover);
      case Mood.love:
        return Lottie.asset('assets/love.json', fit: BoxFit.cover);
      default:
        return const SizedBox.shrink();
    }
  }

  // Sad Theme
  ThemeData _sadTheme() {
    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: Color(0xFF4C5567),
        secondary: Colors.grey,
      ),

      scaffoldBackgroundColor: Colors.blue.shade50,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 18,
          color: Color(0xFF4C5567),
          fontStyle: FontStyle.italic,
        ),
      ),
      appBarTheme: AppBarTheme(
        color: Color(0xFF4C5567),
        titleTextStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 20,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  // Angry Theme
  ThemeData _angryTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red).copyWith(
        secondary: Colors.black,
      ),
      scaffoldBackgroundColor: Colors.red.shade50,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 18,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      appBarTheme: AppBarTheme(
        color: Colors.red.shade700,
        titleTextStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Happy Theme
  ThemeData _happyTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.yellow).copyWith(
        secondary: Colors.green,
      ),
      scaffoldBackgroundColor: Colors.yellow.shade100,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontFamily: 'Comic Sans MS',
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      appBarTheme: AppBarTheme(
        color: Colors.yellow.shade700,
        titleTextStyle: const TextStyle(
          fontFamily: 'Comic Sans MS',
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Love Theme
  ThemeData _loveTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink).copyWith(
        secondary: Colors.purple.shade400,
      ),
      scaffoldBackgroundColor: Colors.pink.shade50,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontFamily: 'Dancing Script',
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      appBarTheme: AppBarTheme(
        color: Colors.pink.shade600,
        titleTextStyle: const TextStyle(
          fontFamily: 'Dancing Script',
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
