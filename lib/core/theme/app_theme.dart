import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Premium Color Palette
  static const Color primaryBlack = Color(0xFF0A0A0A);
  static const Color surfaceBlack = Color(0xFF1A1A1A);
  static const Color cardBlack = Color(0xFF242424);
  static const Color goldAccent = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFF4E4BC);
  static const Color textPrimary = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFFB0B0B0);
  
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    // Color Scheme
    colorScheme: const ColorScheme.dark(
      primary: goldAccent,
      secondary: goldLight,
      surface: surfaceBlack,
      error: Color(0xFFCF6679),
    ),
    
    // Scaffold
    scaffoldBackgroundColor: primaryBlack,
    
    // App Bar
    appBarTheme: AppBarTheme(
      backgroundColor: primaryBlack,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: goldAccent),
    ),
    
    // Card Theme
    cardTheme: CardThemeData(
      color: cardBlack,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: goldAccent.withOpacity(0.1),
          width: 1,
        ),
      ),
    ),
    
    // Text Theme
    textTheme: GoogleFonts.interTextTheme(
      const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: textPrimary,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textSecondary,
          height: 1.4,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: goldAccent,
          letterSpacing: 0.5,
        ),
      ),
    ),
    
    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceBlack,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: goldAccent, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      hintStyle: const TextStyle(color: textSecondary),
    ),
    
    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: goldAccent,
        foregroundColor: primaryBlack,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    // Divider
    dividerTheme: DividerThemeData(
      color: goldAccent.withOpacity(0.1),
      thickness: 1,
      space: 1,
    ),
  );
  
  // Light theme (optional)
  static ThemeData lightTheme = ThemeData(
    // Similar structure but with light colors
    // Keep gold accents for brand consistency
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFB8860B),
      secondary: Color(0xFFDAA520),
    ),
    // ... similar configuration for light mode
  );
}