import 'package:dinarwise/core/analytics/analytics_service.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  Future<void> _select(
    BuildContext context,
    WidgetRef ref,
    String languageCode,
  ) async {
    ref.read(analyticsServiceProvider).onboardingStarted(languageCode);
    await ref
        .read(onboardingControllerProvider.notifier)
        .selectLanguage(languageCode);
    if (context.mounted) context.go('/privacy');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.account_balance_wallet_rounded,
                    size: 72,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 28),
                  Text(
                    l10n.languageSelectionTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.languageSelectionSubtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 36),
                  _LanguageCard(
                    languageName: 'English',
                    nativeHint: 'English',
                    icon: Icons.language,
                    onTap: () => _select(context, ref, 'en'),
                  ),
                  const SizedBox(height: 14),
                  _LanguageCard(
                    languageName: 'العربية',
                    nativeHint: 'Arabic',
                    icon: Icons.translate,
                    onTap: () => _select(context, ref, 'ar'),
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

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.languageName,
    required this.nativeHint,
    required this.icon,
    required this.onTap,
  });

  final String languageName;
  final String nativeHint;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          child: Row(
            children: [
              CircleAvatar(child: Icon(icon)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      languageName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    Text(nativeHint),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
