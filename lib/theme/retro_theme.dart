import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

///

class RetroColors {
  RetroColors._();

  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF1A1A2E);
  static const Color surfaceLight = Color(0xFF16213E);
  static const Color surfaceBorder = Color(0xFF0F3460);

  static const Color neonGreen = Color(0xFF39FF14);
  static const Color neonCyan = Color(0xFF00FFFF);
  static const Color neonMagenta = Color(0xFFFF00FF);
  static const Color neonYellow = Color(0xFFFFFF00);
  static const Color neonOrange = Color(0xFFFF6600);
  static const Color neonRed = Color(0xFFFF0040);

  static const Color textPrimary = Color(0xFF39FF14);
  static const Color textSecondary = Color(0xFF00FFFF);
  static const Color textMuted = Color(0xFF4A7C59);
  static const Color textDim = Color(0xFF3A3A5C);

  static const Color success = Color(0xFF39FF14);
  static const Color error = Color(0xFFFF0040);
  static const Color warning = Color(0xFFFFFF00);
  static const Color info = Color(0xFF00FFFF);

  static const LinearGradient titleBarGradient = LinearGradient(
    colors: [Color(0xFF000080), Color(0xFF1084d0)],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: .topCenter,
    end: .bottomCenter,
    colors: [Color(0xFF2A2A4E), Color(0xFF1A1A2E), Color(0xFF0A0A1E)],
  );
}

class RetroTheme {
  RetroTheme._();

  static TextStyle get _monoStyle =>
      GoogleFonts.vt323(color: RetroColors.textPrimary);

  static TextStyle get _monoStyleSmall =>
      GoogleFonts.shareTechMono(color: RetroColors.textPrimary);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: .dark,
      scaffoldBackgroundColor: RetroColors.background,
      canvasColor: RetroColors.surface,

      colorScheme: const ColorScheme.dark(
        primary: RetroColors.neonGreen,
        secondary: RetroColors.neonCyan,
        tertiary: RetroColors.neonMagenta,
        surface: RetroColors.surface,
        error: RetroColors.error,
        onPrimary: RetroColors.background,
        onSecondary: RetroColors.background,
        onSurface: RetroColors.textPrimary,
        onError: RetroColors.background,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: RetroColors.surface,
        foregroundColor: RetroColors.neonGreen,
        elevation: 0,
        titleTextStyle: _monoStyle.copyWith(fontSize: 22),
        iconTheme: const IconThemeData(color: RetroColors.neonCyan),
      ),

      textTheme: TextTheme(
        displayLarge: _monoStyle.copyWith(fontSize: 36),
        displayMedium: _monoStyle.copyWith(fontSize: 28),
        displaySmall: _monoStyle.copyWith(fontSize: 24),
        headlineLarge: _monoStyle.copyWith(fontSize: 22),
        headlineMedium: _monoStyle.copyWith(fontSize: 20),
        headlineSmall: _monoStyle.copyWith(fontSize: 18),
        titleLarge: _monoStyle.copyWith(fontSize: 18),
        titleMedium: _monoStyleSmall.copyWith(fontSize: 16),
        titleSmall: _monoStyleSmall.copyWith(fontSize: 14),
        bodyLarge: _monoStyleSmall.copyWith(fontSize: 16),
        bodyMedium: _monoStyleSmall.copyWith(fontSize: 14),
        bodySmall: _monoStyleSmall.copyWith(
          fontSize: 12,
          color: RetroColors.textMuted,
        ),
        labelLarge: _monoStyleSmall.copyWith(
          fontSize: 14,
          color: RetroColors.neonCyan,
        ),
        labelMedium: _monoStyleSmall.copyWith(fontSize: 12),
        labelSmall: _monoStyleSmall.copyWith(
          fontSize: 10,
          color: RetroColors.textMuted,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF0D0D1A),
        labelStyle: _monoStyleSmall.copyWith(
          fontSize: 14,
          color: RetroColors.neonCyan,
        ),
        hintStyle: _monoStyleSmall.copyWith(
          fontSize: 14,
          color: RetroColors.textDim,
        ),
        prefixIconColor: RetroColors.neonCyan,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: RetroColors.surfaceBorder),
          borderRadius: BorderRadius.circular(2),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: RetroColors.surfaceBorder),
          borderRadius: BorderRadius.circular(2),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: RetroColors.neonGreen, width: 2),
          borderRadius: BorderRadius.circular(2),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: RetroColors.error),
          borderRadius: BorderRadius.circular(2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: RetroColors.surfaceLight,
          foregroundColor: RetroColors.neonGreen,
          side: const BorderSide(color: RetroColors.neonGreen),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          textStyle: _monoStyleSmall.copyWith(fontSize: 14, letterSpacing: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          elevation: 0,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: RetroColors.neonCyan,
          side: const BorderSide(color: RetroColors.neonCyan),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          textStyle: _monoStyleSmall.copyWith(fontSize: 14),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: RetroColors.neonCyan,
          textStyle: _monoStyleSmall.copyWith(fontSize: 14),
        ),
      ),

      cardTheme: CardThemeData(
        color: RetroColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: const BorderSide(color: RetroColors.surfaceBorder),
        ),
      ),

      dataTableTheme: DataTableThemeData(
        headingTextStyle: _monoStyleSmall.copyWith(
          fontSize: 13,
          color: RetroColors.neonCyan,
          fontWeight: FontWeight.bold,
        ),
        dataTextStyle: _monoStyleSmall.copyWith(
          fontSize: 13,
          color: RetroColors.neonGreen,
        ),
        headingRowColor: WidgetStateProperty.all(
          RetroColors.surface.withValues(alpha: 0.5),
        ),
        dataRowColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return RetroColors.surfaceLight.withValues(alpha: 0.7);
          }
          return Colors.transparent;
        }),
        dividerThickness: 1,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: RetroColors.surfaceBorder, width: 0.5),
          ),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: RetroColors.surfaceBorder,
        thickness: 1,
      ),

      iconTheme: const IconThemeData(color: RetroColors.neonCyan, size: 20),

      chipTheme: ChipThemeData(
        backgroundColor: RetroColors.surface,
        selectedColor: RetroColors.neonGreen.withValues(alpha: 0.2),
        side: const BorderSide(color: RetroColors.surfaceBorder),
        labelStyle: _monoStyleSmall.copyWith(fontSize: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: RetroColors.surface,
        contentTextStyle: _monoStyleSmall.copyWith(
          fontSize: 14,
          color: RetroColors.neonGreen,
        ),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: RetroColors.neonGreen),
          borderRadius: BorderRadius.circular(2),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: RetroColors.surface,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: RetroColors.neonCyan),
          borderRadius: BorderRadius.circular(2),
        ),
        titleTextStyle: _monoStyle.copyWith(
          fontSize: 20,
          color: RetroColors.neonCyan,
        ),
      ),

      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: _monoStyleSmall.copyWith(
          fontSize: 14,
          color: RetroColors.neonGreen,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF0D0D1A),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: RetroColors.surfaceBorder),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),

      tabBarTheme: TabBarThemeData(
        labelColor: RetroColors.neonGreen,
        unselectedLabelColor: RetroColors.textMuted,
        indicatorColor: RetroColors.neonGreen,
        labelStyle: _monoStyleSmall.copyWith(fontSize: 14),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: RetroColors.neonGreen,
        linearTrackColor: RetroColors.surfaceBorder,
      ),

      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(RetroColors.surfaceBorder),
        trackColor: WidgetStateProperty.all(RetroColors.background),
      ),
    );
  }
}
