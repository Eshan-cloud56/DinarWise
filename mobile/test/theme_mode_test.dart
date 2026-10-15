import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:dinarwise/core/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeMode persistence and provider tests', () {
    test('Default/empty preference returns ThemeMode.system', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final appPrefs = AppPreferences(prefs);

      expect(appPrefs.themeMode, equals(ThemeMode.system));
    });

    test('Unknown/legacy preference string safely falls back to ThemeMode.system', () async {
      SharedPreferences.setMockInitialValues({'app_theme_mode': 'custom_oled_mode'});
      final prefs = await SharedPreferences.getInstance();
      final appPrefs = AppPreferences(prefs);

      expect(appPrefs.themeMode, equals(ThemeMode.system));
    });

    test('Persisted light and dark values map correctly to ThemeMode', () async {
      SharedPreferences.setMockInitialValues({'app_theme_mode': 'light'});
      var prefs = await SharedPreferences.getInstance();
      var appPrefs = AppPreferences(prefs);
      expect(appPrefs.themeMode, equals(ThemeMode.light));

      SharedPreferences.setMockInitialValues({'app_theme_mode': 'dark'});
      prefs = await SharedPreferences.getInstance();
      appPrefs = AppPreferences(prefs);
      expect(appPrefs.themeMode, equals(ThemeMode.dark));
    });

    test('Setting themeMode persists string and survives AppPreferences recreation', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final appPrefs = AppPreferences(prefs);

      await appPrefs.setThemeMode(ThemeMode.dark);
      expect(prefs.getString('app_theme_mode'), equals('dark'));

      // Recreate AppPreferences instance
      final reloadedPrefs = AppPreferences(prefs);
      expect(reloadedPrefs.themeMode, equals(ThemeMode.dark));

      await reloadedPrefs.setThemeMode(ThemeMode.light);
      expect(prefs.getString('app_theme_mode'), equals('light'));

      final secondReload = AppPreferences(prefs);
      expect(secondReload.themeMode, equals(ThemeMode.light));

      await secondReload.setThemeMode(ThemeMode.system);
      expect(prefs.getString('app_theme_mode'), equals('system'));
      expect(AppPreferences(prefs).themeMode, equals(ThemeMode.system));
    });

    test('themeModeProvider updates state and writes to persistent storage', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(themeModeProvider), equals(ThemeMode.system));

      await container.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
      expect(container.read(themeModeProvider), equals(ThemeMode.dark));
      expect(prefs.getString('app_theme_mode'), equals('dark'));

      await container.read(themeModeProvider.notifier).setThemeMode(ThemeMode.light);
      expect(container.read(themeModeProvider), equals(ThemeMode.light));
      expect(prefs.getString('app_theme_mode'), equals('light'));

      // In a new container with the same SharedPreferences, state initializes as light
      final container2 = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container2.dispose);

      expect(container2.read(themeModeProvider), equals(ThemeMode.light));
    });
  });
}
