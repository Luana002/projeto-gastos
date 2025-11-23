import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',

        // Cor base do tema
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark, 
        ),

        // Fundo do app
        scaffoldBackgroundColor: const Color.fromARGB(255, 29, 29, 29),

        // AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 255, 124, 205),
          foregroundColor: Colors.white,
        ),

        // Floating Action Button
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),

        // Botões principais
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 152, 81, 161),
            foregroundColor: Colors.white,
          ),
        ),

        // Botões com borda
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.teal,
          ),
        ),

        // Botões de texto
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.teal,
          ),
        ),
      );
}
