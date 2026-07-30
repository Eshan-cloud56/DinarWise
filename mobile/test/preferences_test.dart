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
}
