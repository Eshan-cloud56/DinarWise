import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:dinarwise/core/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:local_auth/local_auth.dart';

class SecuritySettings {
  const SecuritySettings({
    required this.hasPin,
    required this.biometricEnabled,
    required this.autoLockSeconds,
    required this.lockOnBackground,
  });

  final bool hasPin;
  final bool biometricEnabled;
  final int autoLockSeconds;
  final bool lockOnBackground;
}

class SecurityRepository {
  SecurityRepository(this._database);

  final AppDatabase _database;
  final LocalAuthentication _authentication = LocalAuthentication();

  Stream<SecuritySettings> watch(String profileId) {
    final query = _database.select(_database.securityPreferences)
      ..where((row) => row.profileId.equals(profileId));
    return query.watchSingleOrNull().map(
          (row) => SecuritySettings(
            hasPin: row?.pinHash != null,
            biometricEnabled: row?.biometricEnabled ?? false,
            autoLockSeconds: row?.autoLockSeconds ?? 0,
            lockOnBackground: row?.lockOnBackground ?? false,
          ),
        );
  }

  Future<void> setPin(String profileId, String pin) async {
    if (!RegExp(r'^\d{4,8}$').hasMatch(pin)) {
      throw const FormatException('PIN must be 4 to 8 digits.');
    }
    final random = Random.secure();
    final salt = List<int>.generate(16, (_) => random.nextInt(256));
    final hash = await _hash(pin, salt);
    await _database.into(_database.securityPreferences).insertOnConflictUpdate(
          SecurityPreferencesCompanion.insert(
            profileId: profileId,
            pinHash: Value(base64Encode(hash)),
            pinSalt: Value(base64Encode(salt)),
            lockOnBackground: const Value(true),
            autoLockSeconds: const Value(30),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  Future<bool> verifyPin(String profileId, String pin) async {
    final row = await (_database.select(_database.securityPreferences)
          ..where((item) => item.profileId.equals(profileId)))
        .getSingleOrNull();
    if (row?.pinHash == null || row?.pinSalt == null) return false;
    final actual = await _hash(pin, base64Decode(row!.pinSalt!));
    final expected = base64Decode(row.pinHash!);
    if (actual.length != expected.length) return false;
    var difference = 0;
    for (var index = 0; index < actual.length; index++) {
      difference |= actual[index] ^ expected[index];
    }
    return difference == 0;
  }

  Future<void> disablePin(String profileId) async {
    await (_database.update(_database.securityPreferences)
          ..where((row) => row.profileId.equals(profileId)))
        .write(
      SecurityPreferencesCompanion(
        pinHash: const Value(null),
        pinSalt: const Value(null),
        biometricEnabled: const Value(false),
        lockOnBackground: const Value(false),
        autoLockSeconds: const Value(0),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<bool> biometricAvailable() async =>
      await _authentication.isDeviceSupported() &&
      await _authentication.canCheckBiometrics;

  Future<bool> authenticateBiometric(String reason) =>
      _authentication.authenticate(
        localizedReason: reason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );

  Future<void> updateOptions(
    String profileId, {
    bool? biometricEnabled,
    bool? lockOnBackground,
    int? autoLockSeconds,
  }) async {
    await _database.into(_database.securityPreferences).insertOnConflictUpdate(
          SecurityPreferencesCompanion.insert(
            profileId: profileId,
            biometricEnabled: Value(biometricEnabled ?? false),
            lockOnBackground: Value(lockOnBackground ?? false),
            autoLockSeconds: Value(autoLockSeconds ?? 0),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  Future<List<int>> _hash(String pin, List<int> salt) async {
    final key = await Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 210000,
      bits: 256,
    ).deriveKey(
      secretKey: SecretKey(utf8.encode(pin)),
      nonce: salt,
    );
    return key.extractBytes();
  }
}
