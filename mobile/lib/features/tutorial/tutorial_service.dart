import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:dinarwise/features/tutorial/tutorial_keys.dart';

/// Manages contextual tutorial completion state using [SharedPreferences].
///
/// Tutorial keys are strictly scoped to `tutorial_*` prefixes and never
/// touch financial data, onboarding, or user settings.
class TutorialService {
  TutorialService(this._preferences);

  final SharedPreferences _preferences;

  /// Returns `true` if the tutorial identified by [key] has been completed.
  bool isTutorialCompleted(String key) {
    return _preferences.getBool(key) ?? false;
  }

  /// Marks the tutorial identified by [key] as completed.
  Future<void> markTutorialCompleted(String key) {
    return _preferences.setBool(key, true);
  }

  /// Alias for markTutorialCompleted.
  Future<void> completeTutorial(String key) => markTutorialCompleted(key);

  /// Resets a single tutorial so it will show again.
  Future<void> resetTutorial(String key) {
    return _preferences.remove(key);
  }

  /// Resets all feature tutorials.
  ///
  /// Only clears keys from [TutorialKeys.all] — never touches
  /// transactions, budgets, onboarding, or user preferences.
  Future<void> resetAllTutorials() async {
    for (final key in TutorialKeys.all) {
      await _preferences.remove(key);
    }
  }
}

final tutorialServiceProvider = Provider<TutorialService>(
  (ref) => TutorialService(ref.watch(sharedPreferencesProvider)),
);
