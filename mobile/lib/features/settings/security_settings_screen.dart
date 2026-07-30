import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/features/security/security_providers.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SecuritySettingsScreen extends ConsumerWidget {
  const SecuritySettingsScreen({super.key});

  Future<String?> _pinDialog(BuildContext context, String title) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          obscureText: true,
          keyboardType: TextInputType.number,
          maxLength: 8,
          decoration: InputDecoration(labelText: context.l10n.applicationPin),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(context.l10n.confirm),
          ),
        ],
      ),
    );
    controller.dispose();
    return result;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(securitySettingsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.applicationSecurity)),
      body: settings.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(context.l10n.unknownError)),
        data: (value) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SwitchListTile(
              title: Text(context.l10n.applicationPin),
              subtitle: Text(context.l10n.pinStoredSecurely),
              value: value.hasPin,
              onChanged: (enabled) async {
                final profile =
                    (await ref.read(onboardingControllerProvider.future))
                        .localProfileId;
                if (!context.mounted) return;
                if (enabled) {
                  final pin = await _pinDialog(context, context.l10n.createPin);
                  if (pin == null) return;
                  try {
                    await ref
                        .read(securityRepositoryProvider)
                        .setPin(profile, pin);
                  } catch (_) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(context.l10n.pinRequirements)),
                      );
                    }
                  }
                } else {
                  final pin =
                      await _pinDialog(context, context.l10n.verifyCurrentPin);
                  if (pin == null) return;
                  if (await ref
                      .read(securityRepositoryProvider)
                      .verifyPin(profile, pin)) {
                    await ref
                        .read(securityRepositoryProvider)
                        .disablePin(profile);
                  }
                }
              },
            ),
            if (value.hasPin) ...[
              ListTile(
                leading: const Icon(Icons.password),
                title: Text(context.l10n.changePin),
                onTap: () async {
                  final profile =
                      (await ref.read(onboardingControllerProvider.future))
                          .localProfileId;
                  if (!context.mounted) return;
                  final current =
                      await _pinDialog(context, context.l10n.verifyCurrentPin);
                  if (current == null ||
                      !await ref
                          .read(securityRepositoryProvider)
                          .verifyPin(profile, current)) {
                    return;
                  }
                  if (!context.mounted) return;
                  final replacement =
                      await _pinDialog(context, context.l10n.createPin);
                  if (replacement != null) {
                    await ref
                        .read(securityRepositoryProvider)
                        .setPin(profile, replacement);
                  }
                },
              ),
              SwitchListTile(
                title: Text(context.l10n.useBiometrics),
                subtitle: Text(context.l10n.fingerprintOrFace),
                value: value.biometricEnabled,
                onChanged: (enabled) async {
                  final repository = ref.read(securityRepositoryProvider);
                  if (enabled && !await repository.biometricAvailable()) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(context.l10n.biometricsUnavailable)),
                      );
                    }
                    return;
                  }
                  final profile =
                      (await ref.read(onboardingControllerProvider.future))
                          .localProfileId;
                  await repository.updateOptions(
                    profile,
                    biometricEnabled: enabled,
                    lockOnBackground: value.lockOnBackground,
                    autoLockSeconds: value.autoLockSeconds,
                  );
                },
              ),
              SwitchListTile(
                title: Text(context.l10n.lockInBackground),
                value: value.lockOnBackground,
                onChanged: (enabled) async {
                  final profile =
                      (await ref.read(onboardingControllerProvider.future))
                          .localProfileId;
                  await ref.read(securityRepositoryProvider).updateOptions(
                        profile,
                        biometricEnabled: value.biometricEnabled,
                        lockOnBackground: enabled,
                        autoLockSeconds: value.autoLockSeconds,
                      );
                },
              ),
              ListTile(
                title: Text(context.l10n.autoLockTimeout),
                trailing: DropdownButton<int>(
                  value: value.autoLockSeconds,
                  items: [
                    DropdownMenuItem(
                        value: 0, child: Text(context.l10n.immediately)),
                    DropdownMenuItem(
                        value: 30, child: Text(context.l10n.seconds30)),
                    DropdownMenuItem(
                        value: 60, child: Text(context.l10n.minute1)),
                    DropdownMenuItem(
                        value: 300, child: Text(context.l10n.minutes5)),
                  ],
                  onChanged: (seconds) async {
                    if (seconds == null) return;
                    final profile =
                        (await ref.read(onboardingControllerProvider.future))
                            .localProfileId;
                    await ref.read(securityRepositoryProvider).updateOptions(
                          profile,
                          biometricEnabled: value.biometricEnabled,
                          lockOnBackground: value.lockOnBackground,
                          autoLockSeconds: seconds,
                        );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
