import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dinarwise/core/currency/gulf_currency.dart';
import 'package:dinarwise/core/theme.dart';
import 'package:dinarwise/features/voice_expense/application/voice_expense_coordinator.dart';
import 'package:dinarwise/features/voice_expense/models/voice_expense_draft.dart';

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
  @override
  void initState() {
    super.initState();
    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(voiceExpenseCoordinatorProvider.notifier).startListening();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(voiceExpenseCoordinatorProvider);
    final coordinator = ref.read(voiceExpenseCoordinatorProvider.notifier);
    final theme = Theme.of(context);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Content based on status
          switch (state.status) {
            VoiceExpenseStatus.ready => _buildReadyState(context, coordinator, theme),
            VoiceExpenseStatus.listening => _buildListeningState(context, state, coordinator, theme),
            VoiceExpenseStatus.processing => _buildProcessingState(context, theme),
            VoiceExpenseStatus.result => _buildResultState(context, state.draft!, coordinator, theme),
            VoiceExpenseStatus.error => _buildErrorState(context, state.errorMessage, coordinator, theme),
          },
        ],
      ),
    );
  }

  Widget _buildReadyState(
    BuildContext context,
    VoiceExpenseCoordinator coordinator,
    ThemeData theme,
  ) {
    return Column(
      children: [
        Text(
          'Voice Expense',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Speak your expense naturally — 100% on-device & private.',
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
                'Try saying:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: DinarColors.forest,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '• "I spent 100 SAR at AlBaik using cash."',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
              const Text(
                '• "Spent 80 SAR on fuel with card yesterday."',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
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
          'Tap to record',
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
    final minutes = state.recordingDuration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = state.recordingDuration.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Column(
      children: [
        Text(
          'Listening...',
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
          'Tap when done',
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
            'Cancel',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      ],
    );
  }

  Widget _buildProcessingState(BuildContext context, ThemeData theme) {
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
            'Transcribing audio on-device...',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Whisper Tiny multilingual model',
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
    VoiceExpenseDraft draft,
    VoiceExpenseCoordinator coordinator,
    ThemeData theme,
  ) {
    final currency = GulfCurrency.fromCode(draft.currency ?? 'SAR');
    final amountStr = draft.amountMinor != null
        ? '${currency.toMajor(draft.amountMinor!).toStringAsFixed(currency.decimalDigits)} ${currency.code}'
        : 'Amount not recognized';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recognized Expense',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: () => Navigator.of(context).pop(),
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

        // Parsed Fields Preview
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              _buildFieldRow(
                icon: Icons.payments_outlined,
                label: 'Amount',
                value: amountStr,
                isBold: true,
              ),
              if (draft.merchant != null) ...[
                const Divider(height: 16),
                _buildFieldRow(
                  icon: Icons.store_outlined,
                  label: 'Merchant',
                  value: draft.merchant!,
                ),
              ],
              if (draft.description != null && draft.description!.isNotEmpty) ...[
                const Divider(height: 16),
                _buildFieldRow(
                  icon: Icons.description_outlined,
                  label: 'Item',
                  value: draft.description!,
                ),
              ],
              if (draft.categoryId != null) ...[
                const Divider(height: 16),
                _buildFieldRow(
                  icon: Icons.category_outlined,
                  label: 'Category',
                  value: 'Matched',
                ),
              ],
              if (draft.paymentMethodId != null) ...[
                const Divider(height: 16),
                _buildFieldRow(
                  icon: Icons.credit_card_outlined,
                  label: 'Payment',
                  value: 'Recognized',
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Action Button: Review & Save
        SizedBox(
          width: double.infinity,
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
              Navigator.of(context).pop();
              context.push('/capture', extra: draft.toCaptureLaunchArgs());
            },
            child: const Text(
              'Review in Add Expense',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFieldRow({
    required IconData icon,
    required String label,
    required String value,
    bool isBold = false,
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
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: Colors.black87,
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
    return Column(
      children: [
        Icon(
          Icons.error_outline,
          color: Colors.red.shade400,
          size: 48,
        ),
        const SizedBox(height: 12),
        Text(
          'Transcription Failed',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          errorMessage ?? 'Could not transcribe speech. Please try again.',
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
                child: const Text('Enter Manually'),
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
                child: const Text('Retry'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
