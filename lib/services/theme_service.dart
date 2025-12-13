import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Key for SharedPreferences
const String THEME_KEY = 'themeMode';

class ThemeNotifier with ChangeNotifier {
  ThemeData _currentTheme;
  final ThemeData _lightTheme = ThemeData.light().copyWith(
    // Customize your light theme colors here
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.grey[100],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
      titleLarge: TextStyle(color: Colors.black),
      // ... other text styles
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.grey[700]),
      hintStyle: TextStyle(color: Colors.grey[500]),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[500]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[500]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue),
      ),
    ),
  );

  final ThemeData _darkTheme = ThemeData.dark().copyWith(
    // Your existing dark theme from main.dart
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    cardColor: Colors.grey[900],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
      foregroundColor: Colors.white,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
      titleSmall: TextStyle(color: Colors.white),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.white70),
      hintStyle: TextStyle(color: Colors.white54),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white54),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white54),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue),
      ),
    ),
     dialogTheme: DialogThemeData(backgroundColor: Colors.grey[900]), // DialogThemeData does not exist, use DialogTheme
    //dialogTheme: DialogTheme(backgroundColor: Colors.grey[900]),
  );

  ThemeNotifier() : _currentTheme = ThemeData.dark() {
    _loadTheme();
  }

  ThemeData getTheme() => _currentTheme;
  bool get isDarkMode => _currentTheme.brightness == Brightness.dark;

  // Load saved theme preference
  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(THEME_KEY) ?? true; // Default to dark theme
    _currentTheme = isDark ? _darkTheme : _lightTheme;
    notifyListeners();
  }

  // Save and switch theme
  void setDarkMode(bool isDark) async {
    if (isDark == isDarkMode) return; // No change needed

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(THEME_KEY, isDark);
    _currentTheme = isDark ? _darkTheme : _lightTheme;
    notifyListeners();
  }
}