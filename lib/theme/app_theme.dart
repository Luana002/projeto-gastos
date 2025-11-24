import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
      scaffoldBackgroundColor: const Color.fromARGB(255, 233, 243, 255),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 13, 33, 12),
        foregroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 22, 105, 14),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF1E88E5),
          side: const BorderSide(color: Color(0xFF1E88E5)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFFFC107),
        foregroundColor: Colors.white,
      ),
      // cardTheme removed to avoid SDK-specific type mismatch
    );
  }
}