import 'package:flutter/material.dart';

/// Shared Stitch design tokens; no financial or persistence behavior.
abstract final class DinarColors {
  static const green = Color(0xFF0E4D3E);
  static const forest = Color(0xFF07221C);
  static const gold = Color(0xFFC5A059);
  static const canvas = Color(0xFFF9F9F6);
  static const inset = Color(0xFFF1F3EF);
  static const mint = Color(0xFFC9E6DC);
  static const ink = Color(0xFF0F172A);
  static const muted = Color(0xFF58665F);
  static const border = Color(0xFFE5EAE4);
  static const positive = Color(0xFF059669);
}

ThemeData buildDinarWiseTheme() {
  final base = ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    fontFamilyFallback: const ['NotoSansArabic'],
    colorScheme: ColorScheme.fromSeed(seedColor: DinarColors.green).copyWith(
      primary: DinarColors.green,
      onPrimary: Colors.white,
      secondary: DinarColors.muted,
      secondaryContainer: DinarColors.mint,
      onSecondaryContainer: DinarColors.green,
      tertiary: DinarColors.gold,
      surface: DinarColors.canvas,
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: DinarColors.inset,
      surfaceContainerHighest: DinarColors.inset,
      onSurface: DinarColors.ink,
      onSurfaceVariant: DinarColors.muted,
      outlineVariant: DinarColors.border,
    ),
    scaffoldBackgroundColor: DinarColors.canvas,
  );
  TextStyle heading(TextStyle? style) => (style ?? const TextStyle()).copyWith(
        fontFamily: 'PlusJakartaSans',
        fontFamilyFallback: const ['NotoSansArabic'],
        fontWeight: FontWeight.w700,
        fontFeatures: const [FontFeature.tabularFigures()],
      );
  return base.copyWith(
    textTheme: base.textTheme.copyWith(
      displaySmall: heading(base.textTheme.displaySmall),
      headlineSmall: heading(base.textTheme.headlineSmall),
      headlineMedium: heading(base.textTheme.headlineMedium),
      titleLarge: heading(base.textTheme.titleLarge),
      titleMedium: heading(base.textTheme.titleMedium),
      titleSmall: heading(base.textTheme.titleSmall),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: DinarColors.canvas,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontFamilyFallback: ['NotoSansArabic'],
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: DinarColors.ink),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: DinarColors.border)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DinarColors.inset,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: DinarColors.green, width: 1.5)),
    ),
    filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
            minimumSize: const Size(48, 52),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)))),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
            minimumSize: const Size(48, 48),
            side: const BorderSide(color: DinarColors.border),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)))),
    chipTheme: base.chipTheme.copyWith(
        side: BorderSide.none,
        backgroundColor: DinarColors.inset,
        selectedColor: DinarColors.mint,
        shape: const StadiumBorder()),
    dividerTheme:
        const DividerThemeData(color: DinarColors.border, thickness: 1),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: DinarColors.green,
        foregroundColor: DinarColors.gold,
        elevation: 2),
    bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white, showDragHandle: true),
    dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
    listTileTheme: const ListTileThemeData(
        iconColor: DinarColors.green,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4)),
  );
}
