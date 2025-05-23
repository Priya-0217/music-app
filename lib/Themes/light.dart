import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    surface: Colors.white,
    onSurface: Colors.black,
    onPrimary: Colors.grey.shade500,
    primary: Colors.black,
    secondary: Colors.grey.shade300,
    onSecondary: Colors.black,
    error: Colors.red,
    onError: Colors.white,
    tertiary: Colors.white,
    onTertiary: Colors.black,
    inversePrimary:Colors.black
  ),
  scaffoldBackgroundColor: Colors.white,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    titleLarge: TextStyle(color: Colors.black),
    labelLarge: TextStyle(color: Colors.black),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.grey,
    foregroundColor: Colors.black,
  ),

  // Add border to all buttons
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      side: const BorderSide(color: Colors.black),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(color: Colors.black),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      side: const BorderSide(color: Colors.black),
    ),
  ),
);
