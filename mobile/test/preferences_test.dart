import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('local profile ID is generated once and survives reloads', () async {
    SharedPreferences.setMockInitialValues({});
    final shared = await SharedPreferences.getInstance();
    final preferences = AppPreferences(shared);
    final first = await preferences.getOrCreateLocalProfileId();
    final second = await preferences.getOrCreateLocalProfileId();
    expect(first, isNotEmpty);
    expect(second, first);
    final reloaded = AppPreferences(await SharedPreferences.getInstance());
    expect(await reloaded.getOrCreateLocalProfileId(), first);
  });

  test('obsolete telemetry preferences are removed and cannot block startup',
      () async {
    SharedPreferences.setMockInitialValues({
      'analytics_allowed': false,
      'diagnostics_allowed': false,
    });
    final shared = await SharedPreferences.getInstance();
    final preferences = AppPreferences(shared);

    await preferences.migrateAutomaticTelemetryPreferences();

    expect(shared.containsKey('analytics_allowed'), isFalse);
    expect(shared.containsKey('diagnostics_allowed'), isFalse);
  });

  test('dashboard tutorial completion is versioned and persisted', () async {
    SharedPreferences.setMockInitialValues({});
    final shared = await SharedPreferences.getInstance();
    final preferences = AppPreferences(shared);

    expect(preferences.dashboardTutorialCompletedV1, isFalse);
    await preferences.setDashboardTutorialCompletedV1(true);

    final reloaded = AppPreferences(await SharedPreferences.getInstance());
    expect(reloaded.dashboardTutorialCompletedV1, isTrue);
  });
}
