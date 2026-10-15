import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dinarwise/core/currency/gulf_currency.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/core/theme.dart';
import 'package:dinarwise/features/categories/category_localization.dart';
import 'package:dinarwise/features/expenses/data/expense_providers.dart';
import 'package:dinarwise/features/payment_methods/payment_method_providers.dart';
import 'package:dinarwise/features/voice_expense/application/voice_expense_coordinator.dart';
import 'package:dinarwise/features/voice_expense/models/voice_expense_draft.dart';
import 'package:dinarwise/l10n/generated/app_localizations.dart';
import 'package:dinarwise/l10n/l10n_extension.dart';

Future<void> showVoiceExpenseModal(BuildContext context, {bool autoStart = false}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => VoiceExpenseModal(autoStart: autoStart),
  );
}

class VoiceExpenseModal extends ConsumerStatefulWidget {
  const VoiceExpenseModal({super.key, this.autoStart = false});

  final bool autoStart;

  @override
  ConsumerState<VoiceExpenseModal> createState() => _VoiceExpenseModalState();
}

class _VoiceExpenseModalState extends ConsumerState<VoiceExpenseModal> {
  VoiceExpenseCoordinator? _coordinator;

  @override
  void initState() {
    super.initState();
    _coordinator = ref.read(voiceExpenseCoordinatorProvider.notifier);
    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _coordinator?.startListening();
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _coordinator?.reset();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(voiceExpenseCoordinatorProvider);
    final coordinator = ref.read(voiceExpenseCoordinatorProvider.notifier);
    final theme = Theme.of(context);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          coordinator.cancel();
        }
      },
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.90,
          ),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              24,
              16,
              24,
              MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),

                // Content based on status
                switch (state.status) {
                  VoiceExpenseStatus.ready => _buildReadyState(context, state, coordinator, theme),
                  VoiceExpenseStatus.listening => _buildListeningState(context, state, coordinator, theme),
                  VoiceExpenseStatus.processing => _buildProcessingState(context, theme),
                  VoiceExpenseStatus.result => _buildResultState(context, state, coordinator, theme),
                  VoiceExpenseStatus.error => _buildErrorState(context, state.errorMessage, coordinator, theme),
                },
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReadyState(
    BuildContext context,
    VoiceExpenseState state,
    VoiceExpenseCoordinator coordinator,
    ThemeData theme,
  ) {
    final l10n = context.l10n;
    return Column(
      children: [
        Text(
          l10n.voiceExpense,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.voiceExpenseSubtitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF3FBF7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: DinarColors.mint.withAlpha(80)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.trySaying,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: DinarColors.forest,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.voiceExample1,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
              Text(
                l10n.voiceExample2,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          key: const ValueKey('voiceExpenseStartButton'),
          onTap: () => coordinator.startListening(),
          child: Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: DinarColors.forest,
              boxShadow: [
                BoxShadow(
                  color: DinarColors.forest.withAlpha(80),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.mic,
              color: Colors.white,
              size: 38,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          context.l10n.tapToRecord,
          style: theme.textTheme.labelMedium?.copyWith(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildListeningState(
    BuildContext context,
    VoiceExpenseState state,
    VoiceExpenseCoordinator coordinator,
    ThemeData theme,
  ) {
    final l10n = context.l10n;
    final minutes = state.recordingDuration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = state.recordingDuration.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Column(
      children: [
        Text(
          l10n.listening,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: DinarColors.forest,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$minutes:$seconds',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontFamily: 'monospace',
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 32),
        GestureDetector(
          key: const ValueKey('voiceExpenseStopButton'),
          onTap: () => coordinator.stopAndProcess(),
          child: Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red.shade600,
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withAlpha(80),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.stop,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.tapWhenDone,
          style: theme.textTheme.labelMedium?.copyWith(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            coordinator.cancel();
            Navigator.of(context).pop();
          },
          child: Text(
            l10n.cancel,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      ],
    );
  }

  Widget _buildProcessingState(BuildContext context, ThemeData theme) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(DinarColors.forest),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.transcribingAudio,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.whisperModel,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultState(
    BuildContext context,
    VoiceExpenseState state,
    VoiceExpenseCoordinator coordinator,
    ThemeData theme,
  ) {
    final l10n = context.l10n;
    final draft = state.draft!;
    final baseCurrencyCode =
        ref.read(onboardingControllerProvider).valueOrNull?.currencyCode ?? 'SAR';
    final currency = GulfCurrency.fromCode(draft.currency ?? baseCurrencyCode);
    final amountStr = draft.amountMinor != null
        ? '${currency.toMajor(draft.amountMinor!).toStringAsFixed(currency.decimalDigits)} ${currency.code}'
        : l10n.amountNotRecognized;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.recognizedExpense,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              key: const ValueKey('voiceExpenseCloseButton'),
              icon: const Icon(Icons.close, size: 20),
              onPressed: () {
                coordinator.cancel();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Transcript chip
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '"${draft.rawTranscript}"',
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Structured Extraction Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(8),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildFieldRow(
                icon: Icons.payments_outlined,
                label: l10n.amount,
                value: amountStr,
                isBold: true,
              ),
              const Divider(height: 16),
              if (draft.merchant != null && draft.merchant!.isNotEmpty) ...[
                _buildFieldRow(
                  icon: Icons.store_outlined,
                  label: l10n.merchant,
                  value: draft.merchant!,
                ),
              ] else ...[
                _buildFieldRow(
                  icon: Icons.store_outlined,
                  label: l10n.merchant,
                  value: l10n.required,
                  valueColor: Colors.red.shade600,
                  isBold: true,
                ),
              ],
              if (draft.description != null && draft.description!.isNotEmpty) ...[
                const Divider(height: 16),
                _buildFieldRow(
                  icon: Icons.description_outlined,
                  label: l10n.note,
                  value: draft.description!,
                ),
              ],
              if (draft.categoryId != null) ...[
                const Divider(height: 16),
                _buildFieldRow(
                  icon: Icons.category_outlined,
                  label: l10n.category,
                  value: _resolveCategoryLabel(context, draft),
                ),
              ],
              if (draft.paymentMethodId != null) ...[
                const Divider(height: 16),
                _buildFieldRow(
                  icon: Icons.account_balance_wallet_outlined,
                  label: l10n.paymentMethod,
                  value: _resolvePaymentMethodLabel(context, draft),
                ),
              ],
              const Divider(height: 16),
              _buildFieldRow(
                icon: Icons.calendar_today_outlined,
                label: l10n.date,
                value: _resolveDateLabel(context, draft),
              ),
            ],
          ),
        ),

        // Foreign Currency Mismatch Banner
        if (draft.isCurrencyMismatch || draft.isCurrencyAmbiguous) ...[
          const SizedBox(height: 12),
          Container(
            key: const ValueKey('voiceCurrencyMismatchBanner'),
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade400, width: 1.5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber_rounded, size: 20, color: Colors.amber.shade900),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        draft.isCurrencyAmbiguous
                            ? 'Ambiguous Currency (${draft.rawSpokenCurrency ?? "Spoken"})'
                            : 'Currency Mismatch: ${draft.currency ?? "Foreign"} vs $baseCurrencyCode',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        draft.isCurrencyAmbiguous
                            ? 'The spoken currency "${draft.rawSpokenCurrency}" does not match your configured currency ($baseCurrencyCode). Review in Add Expense to specify the amount in $baseCurrencyCode.'
                            : 'Detected currency (${draft.currency}) differs from your configured ledger currency ($baseCurrencyCode). Save is blocked until resolved to $baseCurrencyCode.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.brown.shade900,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],

        // Merchant Required Banner
        if (draft.merchant == null || draft.merchant!.isEmpty) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade300),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 18, color: Colors.orange.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.merchantRequiredBanner,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange.shade900,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 24),

        // Action Buttons: Cancel | Review in Add Expense
        Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 50,
                child: OutlinedButton(
                  key: const ValueKey('voiceExpenseCancelButton'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey.shade700,
                    side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    coordinator.cancel();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    context.l10n.cancel,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  key: const ValueKey('voiceExpenseReviewButton'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DinarColors.forest,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    final launchArgs = draft.toCaptureLaunchArgs();
                    coordinator.reset();
                    Navigator.of(context).pop();
                    context.push('/capture', extra: launchArgs);
                  },
                  child: Text(
                    context.l10n.reviewInAddExpense,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _resolveCategoryLabel(BuildContext context, VoiceExpenseDraft draft) {
    if (draft.categoryId == null) return '';
    final categories = ref.watch(categoriesProvider).valueOrNull ?? [];
    final match = categories.where((c) => c.id == draft.categoryId).firstOrNull;
    if (match != null) {
      final l10n = Localizations.of<AppLocalizations>(context, AppLocalizations);
      if (l10n != null) {
        return localizedCategoryName(l10n, match);
      }
      return match.name;
    }
    if (draft.categoryName != null && draft.categoryName!.isNotEmpty) {
      return draft.categoryName!;
    }
    return draft.categoryId!;
  }

  String _resolvePaymentMethodLabel(BuildContext context, VoiceExpenseDraft draft) {
    if (draft.paymentMethodId == null) return '';
    final methods = ref.watch(paymentMethodsProvider).valueOrNull ?? [];
    final match = methods.where((m) => m.id == draft.paymentMethodId).firstOrNull;
    final l10n = Localizations.of<AppLocalizations>(context, AppLocalizations);
    final code = match?.systemCode ?? draft.paymentMethodSystemCode;
    final fallback = match?.name ?? draft.paymentMethodName ?? draft.paymentMethodId!;

    if (l10n != null && code != null) {
      return switch (code.toLowerCase()) {
        'cash' => l10n.cash,
        'debit_card' => l10n.debitCard,
        'credit_card' => l10n.creditCard,
        'bank_transfer' => l10n.bankTransfer,
        'mada' => 'Mada',
        'stc_pay' => 'STC Pay',
        'google_pay' => 'Google Pay',
        'tabby' => 'Tabby',
        'tamara' => 'Tamara',
        'other' => l10n.other,
        _ => fallback,
      };
    }
    return fallback;
  }

  String _resolveDateLabel(BuildContext context, VoiceExpenseDraft draft) {
    final l10n = Localizations.of<AppLocalizations>(context, AppLocalizations);
    if (draft.isYesterday) {
      return l10n?.yesterday ?? 'Yesterday';
    }
    final draftDate = draft.date;
    if (draftDate == null) {
      return l10n?.today ?? 'Today';
    }
    final now = DateTime.now();
    final todayCal = DateTime(now.year, now.month, now.day);
    final targetCal = DateTime(draftDate.year, draftDate.month, draftDate.day);
    final diff = todayCal.difference(targetCal).inDays;
    if (diff == 0) {
      return l10n?.today ?? 'Today';
    } else if (diff == 1) {
      return l10n?.yesterday ?? 'Yesterday';
    }
    return '${draftDate.year}-${draftDate.month.toString().padLeft(2, '0')}-${draftDate.day.toString().padLeft(2, '0')}';
  }

  Widget _buildFieldRow({
    required IconData icon,
    required String label,
    required String value,
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    String? errorMessage,
    VoiceExpenseCoordinator coordinator,
    ThemeData theme,
  ) {
    final l10n = context.l10n;
    return Column(
      children: [
        Icon(
          Icons.error_outline,
          color: Colors.red.shade400,
          size: 48,
        ),
        const SizedBox(height: 12),
        Text(
          l10n.transcriptionFailed,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _resolveErrorMessage(context, errorMessage),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  side: BorderSide(color: Colors.grey.shade300),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  context.push('/capture');
                },
                child: Text(l10n.manualEntry),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: DinarColors.forest,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => coordinator.startListening(),
                child: Text(l10n.retry),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _resolveErrorMessage(BuildContext context, String? errorMessage) {
    final l10n = context.l10n;
    if (errorMessage == null) return l10n.voiceTranscriptionError;
    if (errorMessage.contains('Microphone permission')) {
      return l10n.voiceMicPermissionRequired;
    }
    if (errorMessage.contains('initialize') || errorMessage.contains('Failed to access')) {
      return l10n.voiceRecordInitFailed;
    }
    if (errorMessage.contains('No speech')) {
      return l10n.voiceNoSpeechDetected;
    }
    return l10n.voiceTranscriptionError;
  }
}
