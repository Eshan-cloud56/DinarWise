import 'package:dinarwise/core/constants.dart';
import 'package:dinarwise/core/analytics/analytics_service.dart';
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
    if (_submitting) return;
    setState(() => _submitting = true);
    await ref.read(onboardingControllerProvider.notifier).acceptPrivacyPolicy();
    final analytics = ref.read(analyticsServiceProvider);
    analytics.privacyPolicyAccepted();
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
                  Image.asset('assets/branding/stitch-logo.png',
                      height: 72, semanticLabel: 'DinarWise'),
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
                  Text(
                    l10n.privacyAtGlance,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _PrivacyPoint(
                            icon: Icons.phone_android_outlined,
                            text: l10n.privacyLocalRecords,
                          ),
                          const SizedBox(height: 14),
                          _PrivacyPoint(
                            icon: Icons.insights_outlined,
                            text: l10n.privacySafeTelemetry,
                          ),
                          const SizedBox(height: 14),
                          _PrivacyPoint(
                            icon: Icons.lock_outline,
                            text: l10n.privacyNeverSent,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(l10n.firebasePrivacyExplanation),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton.icon(
                      onPressed: _openPolicy,
                      icon: const Icon(Icons.open_in_new, size: 18),
                      label: Text(l10n.readFullPrivacyPolicy),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(text: l10n.privacyAcknowledgementPrefix),
                        TextSpan(
                          text: l10n.privacyPolicy,
                          style: linkStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = _openPolicy,
                        ),
                        TextSpan(text: l10n.privacyAcknowledgementSuffix),
                      ],
                    ),
                    key: const ValueKey('privacyPolicyAcknowledgementText'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.privacyVersion(currentPrivacyPolicyVersion),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: !_submitting ? _continue : null,
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

class _PrivacyPoint extends StatelessWidget {
  const _PrivacyPoint({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(child: Text(text)),
      ],
    );
  }
}
