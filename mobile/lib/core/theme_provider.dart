import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(appPreferencesProvider);
  return ThemeModeNotifier(prefs);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._prefs) : super(_prefs.themeMode);

  final AppPreferences _prefs;

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _prefs.setThemeMode(mode);
  }
}
