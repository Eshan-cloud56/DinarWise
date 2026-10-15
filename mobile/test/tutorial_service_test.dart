import 'package:dinarwise/features/tutorial/tutorial_keys.dart';
import 'package:dinarwise/features/tutorial/tutorial_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('TutorialService', () {
    late SharedPreferences prefs;
    late TutorialService service;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      service = TutorialService(prefs);
    });

    test('isTutorialCompleted returns false for fresh tutorial', () {
      expect(service.isTutorialCompleted(TutorialKeys.home), isFalse);
      expect(service.isTutorialCompleted(TutorialKeys.voiceExpense), isFalse);
      expect(service.isTutorialCompleted(TutorialKeys.homeWidget), isFalse);
    });

    test('markTutorialCompleted sets key to true', () async {
      await service.markTutorialCompleted(TutorialKeys.home);
      expect(service.isTutorialCompleted(TutorialKeys.home), isTrue);
    });

    test('resetTutorial clears a single tutorial', () async {
      await service.markTutorialCompleted(TutorialKeys.home);
      expect(service.isTutorialCompleted(TutorialKeys.home), isTrue);

      await service.resetTutorial(TutorialKeys.home);
      expect(service.isTutorialCompleted(TutorialKeys.home), isFalse);
    });

    test('resetAllTutorials clears all tutorial keys', () async {
      for (final key in TutorialKeys.all) {
        await service.markTutorialCompleted(key);
      }
      for (final key in TutorialKeys.all) {
        expect(service.isTutorialCompleted(key), isTrue,
            reason: '$key should be completed');
      }

      await service.resetAllTutorials();

      for (final key in TutorialKeys.all) {
        expect(service.isTutorialCompleted(key), isFalse,
            reason: '$key should be reset');
      }
    });

    test('resetAllTutorials does not touch non-tutorial keys', () async {
      // Set financial/onboarding prefs
      await prefs.setString('selected_currency', 'SAR');
      await prefs.setBool('onboarding_completed', true);
      await prefs.setString('local_profile_id', 'test-profile-123');
      await prefs.setString('selected_language', 'en');

      // Set tutorial prefs
      await service.markTutorialCompleted(TutorialKeys.home);
      await service.markTutorialCompleted(TutorialKeys.voiceExpense);

      // Reset all tutorials
      await service.resetAllTutorials();

      // Tutorials should be cleared
      expect(service.isTutorialCompleted(TutorialKeys.home), isFalse);
      expect(service.isTutorialCompleted(TutorialKeys.voiceExpense), isFalse);

      // Financial data and onboarding should be untouched
      expect(prefs.getString('selected_currency'), 'SAR');
      expect(prefs.getBool('onboarding_completed'), isTrue);
      expect(prefs.getString('local_profile_id'), 'test-profile-123');
      expect(prefs.getString('selected_language'), 'en');
    });

    test('Replay single tutorial preserves others', () async {
      await service.markTutorialCompleted(TutorialKeys.home);
      await service.markTutorialCompleted(TutorialKeys.voiceExpense);
      await service.markTutorialCompleted(TutorialKeys.smartSearch);

      await service.resetTutorial(TutorialKeys.voiceExpense);

      expect(service.isTutorialCompleted(TutorialKeys.home), isTrue);
      expect(service.isTutorialCompleted(TutorialKeys.voiceExpense), isFalse);
      expect(service.isTutorialCompleted(TutorialKeys.smartSearch), isTrue);
    });
  });
}
