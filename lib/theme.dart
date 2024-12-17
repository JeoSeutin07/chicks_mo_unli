import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      primaryColor: Color(0xFFFFF3CB),
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Roboto',
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.14,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          letterSpacing: 0.16,
        ),
        titleLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.24,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Color(0xFFFFF3CB),
        secondary: Color(0xFFFFC107),
      ),
    );
  }
}
