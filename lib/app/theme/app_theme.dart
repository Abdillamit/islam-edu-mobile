import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData lightTheme() {
    const baseColor = Color(0xFF1E6F5C);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: baseColor,
      brightness: Brightness.light,
      surface: const Color(0xFFFFFCF3),
      primaryContainer: const Color(0xFFD8EEE6),
      secondaryContainer: const Color(0xFFF4E8D2),
    );

    final textTheme = GoogleFonts.notoSansTextTheme().copyWith(
      headlineMedium: GoogleFonts.notoSans(
        fontSize: 28,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: GoogleFonts.notoSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: GoogleFonts.notoSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: GoogleFonts.notoSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: GoogleFonts.notoSans(
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
      labelMedium: GoogleFonts.notoSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );

    return ThemeData(
      colorScheme: colorScheme,
      textTheme: textTheme,
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF8F6EF),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
