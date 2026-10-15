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

ThemeData buildDinarWiseTheme() => buildDinarWiseLightTheme();

ThemeData buildDinarWiseLightTheme() {
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
      errorMaxLines: 3,
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

/// Centralized dark theme design tokens for DinarWise.
abstract final class DinarDarkColors {
  static const green = Color(0xFF10B981);
  static const forest = Color(0xFF042F22);
  static const gold = Color(0xFFE5C07B);
  static const canvas = Color(0xFF0B1411);
  static const card = Color(0xFF14221E);
  static const inset = Color(0xFF182A25);
  static const mint = Color(0xFF064E3B);
  static const ink = Color(0xFFF1F5F3);
  static const muted = Color(0xFF94A89F);
  static const border = Color(0xFF233B33);
  static const positive = Color(0xFF34D399);
}

ThemeData buildDinarWiseDarkTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Inter',
    fontFamilyFallback: const ['NotoSansArabic'],
    colorScheme: const ColorScheme.dark().copyWith(
      primary: DinarDarkColors.green,
      onPrimary: const Color(0xFF042F22),
      secondary: DinarDarkColors.muted,
      secondaryContainer: DinarDarkColors.mint,
      onSecondaryContainer: const Color(0xFFA7F3D0),
      tertiary: DinarDarkColors.gold,
      surface: DinarDarkColors.canvas,
      surfaceContainerLowest: const Color(0xFF080F0D),
      surfaceContainerLow: DinarDarkColors.card,
      surfaceContainer: DinarDarkColors.card,
      surfaceContainerHighest: DinarDarkColors.inset,
      onSurface: DinarDarkColors.ink,
      onSurfaceVariant: DinarDarkColors.muted,
      outlineVariant: DinarDarkColors.border,
    ),
    scaffoldBackgroundColor: DinarDarkColors.canvas,
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
      backgroundColor: DinarDarkColors.canvas,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontFamilyFallback: ['NotoSansArabic'],
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: DinarDarkColors.ink),
    ),
    cardTheme: CardThemeData(
      color: DinarDarkColors.card,
      surfaceTintColor: Colors.transparent,
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: DinarDarkColors.border)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      errorMaxLines: 3,
      filled: true,
      fillColor: DinarDarkColors.inset,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: DinarDarkColors.green, width: 1.5)),
    ),
    filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
            backgroundColor: DinarDarkColors.green,
            foregroundColor: const Color(0xFF042F22),
            minimumSize: const Size(48, 52),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)))),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
            foregroundColor: DinarDarkColors.ink,
            minimumSize: const Size(48, 48),
            side: const BorderSide(color: DinarDarkColors.border),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)))),
    chipTheme: base.chipTheme.copyWith(
        side: BorderSide.none,
        backgroundColor: DinarDarkColors.inset,
        selectedColor: DinarDarkColors.mint,
        shape: const StadiumBorder()),
    dividerTheme:
        const DividerThemeData(color: DinarDarkColors.border, thickness: 1),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: DinarDarkColors.green,
        foregroundColor: Color(0xFF042F22),
        elevation: 2),
    bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: DinarDarkColors.card, showDragHandle: true),
    dialogTheme: DialogThemeData(
        backgroundColor: DinarDarkColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
    listTileTheme: const ListTileThemeData(
        iconColor: DinarDarkColors.green,
        textColor: DinarDarkColors.ink,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4)),
  );
}
