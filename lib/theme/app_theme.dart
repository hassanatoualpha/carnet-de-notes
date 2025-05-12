import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6B4EFF),
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 2,
      shadowColor: Colors.black26,
    ),
    cardTheme: CardTheme(
      elevation: 3,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: const Color(0xFF6B4EFF),
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.5),
      titleMedium: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.25),
      bodyLarge: TextStyle(fontSize: 16, letterSpacing: 0.15),
      bodyMedium: TextStyle(fontSize: 14, letterSpacing: 0.1),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF6B4EFF), width: 2),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6B4EFF),
      brightness: Brightness.dark,
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.3),
    ),
    cardTheme: CardTheme(
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: const Color(0xFF6B4EFF),
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.5),
      titleMedium: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.25),
      bodyLarge: TextStyle(fontSize: 16, letterSpacing: 0.15),
      bodyMedium: TextStyle(fontSize: 14, letterSpacing: 0.1),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade900,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF6B4EFF), width: 2),
      ),
    ),
  );
}