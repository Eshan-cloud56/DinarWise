import 'package:dinarwise/core/constants.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyConsentScreen extends ConsumerStatefulWidget {
  const PrivacyConsentScreen({super.key});

  @override
  ConsumerState<PrivacyConsentScreen> createState() =>
      _PrivacyConsentScreenState();
}

class _PrivacyConsentScreenState extends ConsumerState<PrivacyConsentScreen> {
  bool _accepted = false;
  bool _submitting = false;

  Future<void> _openPolicy() async {
    var opened = false;
    try {
      opened = await launchUrl(
        Uri.parse(privacyPolicyUrl),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      opened = false;
    }
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.privacyOpenError)),
      );
    }
  }

  Future<void> _continue() async {
    if (!_accepted || _submitting) return;
    setState(() => _submitting = true);
    await ref.read(onboardingControllerProvider.notifier).acceptPrivacyPolicy();
    if (mounted) context.go('/currency');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final linkStyle = TextStyle(
      color: Theme.of(context).colorScheme.primary,
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w700,
    );
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.account_balance_wallet_rounded,
                    size: 68,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.appName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.welcomeTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.welcomeSubtitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Card(
                    child: CheckboxListTile(
                      value: _accepted,
                      onChanged: (value) =>
                          setState(() => _accepted = value ?? false),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: const EdgeInsets.all(16),
                      title: Text.rich(
                        TextSpan(
                          style: Theme.of(context).textTheme.bodyLarge,
                          children: [
                            TextSpan(text: l10n.privacyConsentPrefix),
                            TextSpan(
                              text: l10n.privacyPolicy,
                              style: linkStyle,
                              recognizer: TapGestureRecognizer()
                                ..onTap = _openPolicy,
                            ),
                            TextSpan(text: l10n.privacyConsentSuffix),
                          ],
                        ),
                        key: const ValueKey('privacyPolicyConsentText'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.privacyVersion(currentPrivacyPolicyVersion),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _accepted && !_submitting ? _continue : null,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: _submitting
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.getStarted),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
