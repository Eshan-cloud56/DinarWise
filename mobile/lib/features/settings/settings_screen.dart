import 'package:dinarwise/core/currency/gulf_currency.dart';
import 'package:dinarwise/core/analytics/analytics_service.dart';
import 'package:dinarwise/core/database/app_database.dart';
import 'package:dinarwise/core/database/database_provider.dart';
import 'package:dinarwise/core/preferences/app_preferences.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/features/notifications/notification_providers.dart';
import 'package:dinarwise/features/sms_detection/sms_disclosure_dialog.dart';
import 'package:dinarwise/features/sms_detection/sms_platform_channel.dart';
import 'package:dinarwise/features/tutorial/dashboard_tutorial.dart';
import 'package:dinarwise/features/receipts/smart/smart_scan_disclosure.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' show Value;

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAccess());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAccess();
    }
  }

  Future<void> _checkAccess() async {
    try {
      final channel = ref.read(smsPlatformChannelProvider);
      final hasSms = await channel.hasPermission();

      final isCurrentlyEnabled = ref.read(smsDetectionEnabledProvider);
      if (!hasSms && isCurrentlyEnabled) {
        // Permission was revoked in Android Settings -> update state to OFF
        await ref.read(smsDetectionEnabledProvider.notifier).setEnabled(false);
      }
    } catch (_) {}
  }

  Future<void> _changeCurrency(String code) async {
    final state = await ref.read(onboardingControllerProvider.future);
    final database = ref.read(databaseProvider);
    await database.transaction(() async {
      await (database.update(database.financialTransactions)
            ..where((row) => row.profileId.equals(state.localProfileId)))
          .write(FinancialTransactionsCompanion(currency: Value(code)));
      await database.into(database.financialPreferences).insertOnConflictUpdate(
            FinancialPreferencesCompanion.insert(
              profileId: state.localProfileId,
              currency: Value(code),
            ),
          );
    });
    await ref.read(onboardingControllerProvider.notifier).selectCurrency(code);
  }

  Future<void> _reset(BuildContext context) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.warning_amber_rounded,
          color: Theme.of(context).colorScheme.error,
          size: 42,
        ),
        title: Text(l10n.resetDataTitle),
        content: Text(l10n.resetDataMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.resetDataConfirmation),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(databaseProvider).clearAllFinancialData();
    await ref.read(onboardingControllerProvider.notifier).resetPreferences();
    if (context.mounted) context.go('/language');
  }

  @override
  Widget build(BuildContext context) {
    ref.read(analyticsServiceProvider)
      ..screen('settings')
      ..settingsViewed();
    final l10n = context.l10n;
    final state = ref.watch(onboardingControllerProvider).requireValue;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.preferences,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.delete_forever_outlined,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  l10n.resetApplicationData,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                onTap: () => _reset(context),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(l10n.language),
                    trailing: DropdownButton<String>(
                      value: state.locale?.languageCode ?? 'en',
                      underline: const SizedBox.shrink(),
                      items: [
                        DropdownMenuItem(
                            value: 'en', child: Text(l10n.english)),
                        DropdownMenuItem(value: 'ar', child: Text(l10n.arabic)),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          ref
                              .read(onboardingControllerProvider.notifier)
                              .selectLanguage(value);
                        }
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.currency_exchange_outlined),
                    title: Text(l10n.chooseCurrency),
                    trailing: DropdownButton<String>(
                      value: state.currencyCode ?? 'SAR',
                      underline: const SizedBox.shrink(),
                      items: [
                        for (final currency in GulfCurrency.supported)
                          DropdownMenuItem(
                            value: currency.code,
                            child: Text(currency.code),
                          ),
                      ],
                      onChanged: (value) {
                        if (value != null) _changeCurrency(value);
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.school_outlined),
                    title: Text(l10n.replayAppTutorial),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      await ref
                          .read(appPreferencesProvider)
                          .setDashboardTutorialCompletedV1(false);
                      ref.read(tutorialReplayRequestProvider.notifier).state++;
                      if (context.mounted) {
                        context.go('/');
                      }
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.category_outlined),
                    title: Text(l10n.customCategories),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/settings/categories'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.account_balance_wallet_outlined),
                    title: Text(l10n.paymentMethods),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/settings/payment-methods'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.receipt_long_outlined),
                    title: Text(l10n.receiptStorage),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/settings/receipts'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(l10n.smartScanInformation),
                    onTap: () => showSmartScanInformation(context),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.notifications_outlined),
                    title: Text(l10n.enableNotifications),
                    subtitle: Text(l10n.notificationPermissionHint),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final granted = await ref
                          .read(localNotificationServiceProvider)
                          .requestPermission();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              granted
                                  ? l10n.notificationsEnabled
                                  : l10n.notificationsDenied,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  const Divider(height: 1),
                  () {
                    final isSupported =
                        ref.watch(smsSupportedProvider).valueOrNull ?? false;
                    if (!isSupported) {
                      return SwitchListTile(
                        secondary: const Icon(Icons.sms_outlined),
                        title: Text(l10n.automaticTransactionDetection),
                        subtitle: Text(l10n.smsDetectionUnavailable),
                        value: false,
                        onChanged: null,
                      );
                    }
                    return SwitchListTile(
                      secondary: const Icon(Icons.sms_outlined),
                      title: Text(l10n.automaticTransactionDetection),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.automaticTransactionDetectionSubtitle),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () => showSmsDetectionDisclosure(
                              context,
                              isInformationalOnly: true,
                            ),
                            child: Text(
                              l10n.smsDisclosureLearnMore,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      value: ref.watch(smsDetectionEnabledProvider),
                      onChanged: (value) async {
                        if (value) {
                          final channel = ref.read(smsPlatformChannelProvider);
                          final hasSms = await channel.hasPermission();

                          if (!hasSms) {
                            if (!context.mounted) return;
                            final agreed =
                                await showSmsDetectionDisclosure(context);
                            if (!agreed) {
                              return;
                            }
                            final result = await channel.requestPermission();
                            if (!result.granted) {
                              await ref
                                  .read(smsDetectionEnabledProvider.notifier)
                                  .setEnabled(false);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text(l10n.smsPermissionDeniedNotice),
                                    action: result.permanentlyDenied
                                        ? SnackBarAction(
                                            label: l10n.settings,
                                            onPressed: () =>
                                                channel.openAppSettings(),
                                          )
                                        : null,
                                  ),
                                );
                              }
                              return;
                            }
                          }
                          await ref
                              .read(smsDetectionEnabledProvider.notifier)
                              .setEnabled(true);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.smsDetectionEnabledNotice),
                              ),
                            );
                          }
                        } else {
                          await ref
                              .read(smsDetectionEnabledProvider.notifier)
                              .setEnabled(false);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.smsDetectionDisabledNotice),
                              ),
                            );
                          }
                        }
                      },
                    );
                  }(),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.import_export_outlined),
                    title: Text(l10n.backupAndExport),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/settings/data-tools'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.security_outlined),
                    title: Text(l10n.applicationSecurity),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/settings/security'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.calculate_outlined),
                    title: Text(l10n.offlineCalculators),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/calculators'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
