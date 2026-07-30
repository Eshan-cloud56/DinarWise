import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/features/security/security_providers.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppLockLifecycle extends ConsumerStatefulWidget {
  const AppLockLifecycle({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<AppLockLifecycle> createState() => _AppLockLifecycleState();
}

class _AppLockLifecycleState extends ConsumerState<AppLockLifecycle>
    with WidgetsBindingObserver {
  bool _locked = false;
  DateTime? _backgroundedAt;
  final _pin = TextEditingController();
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final settings = ref.read(securitySettingsProvider).valueOrNull;
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _backgroundedAt ??= DateTime.now();
      if (settings?.hasPin == true && settings?.lockOnBackground == true) {
        setState(() => _locked = true);
      }
    } else if (state == AppLifecycleState.resumed &&
        settings?.hasPin == true &&
        _backgroundedAt != null &&
        DateTime.now().difference(_backgroundedAt!).inSeconds >=
            (settings?.autoLockSeconds ?? 0)) {
      setState(() => _locked = true);
      _backgroundedAt = null;
    }
  }

  Future<void> _unlockPin() async {
    final state = await ref.read(onboardingControllerProvider.future);
    final valid = await ref
        .read(securityRepositoryProvider)
        .verifyPin(state.localProfileId, _pin.text);
    if (valid && mounted) {
      setState(() {
        _locked = false;
        _error = null;
        _pin.clear();
      });
    } else if (mounted) {
      setState(() => _error = context.l10n.incorrectPin);
    }
  }

  Future<void> _unlockBiometric() async {
    final valid = await ref
        .read(securityRepositoryProvider)
        .authenticateBiometric(context.l10n.unlockDinarWise);
    if (valid && mounted) setState(() => _locked = false);
  }

  @override
  Widget build(BuildContext context) {
    final onboarding = ref.watch(onboardingControllerProvider).valueOrNull;
    final settings = ref.watch(securitySettingsProvider).valueOrNull;
    if (onboarding?.destination != StartupDestination.dashboard ||
        settings?.hasPin != true ||
        !_locked) {
      return widget.child;
    }
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 64),
                const SizedBox(height: 16),
                Text(
                  context.l10n.appLocked,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _pin,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 8,
                  onSubmitted: (_) => _unlockPin(),
                  decoration: InputDecoration(
                    labelText: context.l10n.applicationPin,
                    errorText: _error,
                  ),
                ),
                FilledButton(
                  onPressed: _unlockPin,
                  child: Text(context.l10n.unlock),
                ),
                if (settings?.biometricEnabled == true)
                  TextButton.icon(
                    onPressed: _unlockBiometric,
                    icon: const Icon(Icons.fingerprint),
                    label: Text(context.l10n.useBiometrics),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pin.dispose();
    super.dispose();
  }
}
