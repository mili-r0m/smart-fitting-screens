import 'package:flutter/material.dart';

class BrandTheme {
  final Color primary;
  final Color background;
  final Color textOnBackground;
  final Color textOnPrimary;

  const BrandTheme({
    required this.primary,
    required this.background,
    required this.textOnBackground,
    required this.textOnPrimary,
  });

  ThemeData toThemeData() {
    final ColorScheme scheme = ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: textOnPrimary,
      secondary: primary,
      onSecondary: textOnPrimary,
      error: Colors.red,
      onError: Colors.white,
      surface: background,
      onSurface: textOnBackground,
      background: background,
      onBackground: textOnBackground,
    );

    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textOnBackground,
        elevation: 0,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: textOnBackground),
        bodyMedium: TextStyle(color: textOnBackground),
        titleLarge: TextStyle(color: textOnBackground),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: textOnPrimary,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
