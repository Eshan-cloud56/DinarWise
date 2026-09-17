import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dinarwise/core/analytics/analytics_service.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/features/expenses/data/expense_providers.dart';
import 'package:dinarwise/features/payment_methods/payment_method_providers.dart';
import 'package:dinarwise/features/voice_expense/data/voice_recording_service.dart';
import 'package:dinarwise/features/voice_expense/domain/voice_expense_parser.dart';
import 'package:dinarwise/features/voice_expense/models/voice_expense_draft.dart';

enum VoiceExpenseStatus {
  ready,
  listening,
  processing,
  result,
  error,
}

class VoiceExpenseState {
  const VoiceExpenseState({
    required this.status,
    this.draft,
    this.errorMessage,
    this.recordingDuration = Duration.zero,
    this.transcriptionDurationMs,
    this.modelLoadMs,
  });

  final VoiceExpenseStatus status;
  final VoiceExpenseDraft? draft;
  final String? errorMessage;
  final Duration recordingDuration;
  final int? transcriptionDurationMs;
  final int? modelLoadMs;

  VoiceExpenseState copyWith({
    VoiceExpenseStatus? status,
    VoiceExpenseDraft? draft,
    String? errorMessage,
    Duration? recordingDuration,
    int? transcriptionDurationMs,
    int? modelLoadMs,
    bool clearDraft = false,
    bool clearError = false,
  }) {
    return VoiceExpenseState(
      status: status ?? this.status,
      draft: clearDraft ? null : (draft ?? this.draft),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      recordingDuration: recordingDuration ?? this.recordingDuration,
      transcriptionDurationMs: transcriptionDurationMs ?? this.transcriptionDurationMs,
      modelLoadMs: modelLoadMs ?? this.modelLoadMs,
    );
  }
}

final voiceExpenseCoordinatorProvider =
    StateNotifierProvider.autoDispose<VoiceExpenseCoordinator, VoiceExpenseState>((ref) {
  return VoiceExpenseCoordinator(ref);
});

class VoiceExpenseCoordinator extends StateNotifier<VoiceExpenseState> {
  VoiceExpenseCoordinator(this._ref)
      : super(const VoiceExpenseState(status: VoiceExpenseStatus.ready));

  final Ref _ref;
  Timer? _timer;
  DateTime? _recordStartTime;

  VoiceRecordingService get _service => _ref.read(voiceRecordingServiceProvider);

  Future<void> startListening() async {
    try {
      final hasPermission = await _service.hasPermission();
      if (!hasPermission) {
        final granted = await _service.requestPermission();
        if (!granted) {
          state = state.copyWith(
            status: VoiceExpenseStatus.error,
            errorMessage: 'Microphone permission is required to record voice expenses.',
          );
          return;
        }
      }

      final started = await _service.startRecording();
      if (!started) {
        state = state.copyWith(
          status: VoiceExpenseStatus.error,
          errorMessage: 'Unable to start audio recording.',
        );
        return;
      }

      _recordStartTime = DateTime.now();
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_recordStartTime != null) {
          state = state.copyWith(
            recordingDuration: DateTime.now().difference(_recordStartTime!),
          );
        }
      });

      state = state.copyWith(
        status: VoiceExpenseStatus.listening,
        clearDraft: true,
        clearError: true,
        recordingDuration: Duration.zero,
      );

      // Safe non-sensitive analytics event
      _ref.read(analyticsServiceProvider).voiceExpenseStarted();
    } catch (_) {
      state = state.copyWith(
        status: VoiceExpenseStatus.error,
        errorMessage: 'Failed to access microphone.',
      );
    }
  }

  Future<void> stopAndProcess() async {
    _timer?.cancel();
    _timer = null;

    if (state.status != VoiceExpenseStatus.listening) return;

    state = state.copyWith(status: VoiceExpenseStatus.processing);

    try {
      final result = await _service.stopAndTranscribe();
      if (result == null || result.transcript.isEmpty) {
        state = state.copyWith(
          status: VoiceExpenseStatus.error,
          errorMessage: 'No speech was detected. Please try speaking again.',
        );
        _ref.read(analyticsServiceProvider).voiceExpenseFailed();
        return;
      }

      // Gather categories & payment methods for deterministic parsing
      final categories = _ref.read(categoriesProvider).valueOrNull ?? [];
      final paymentMethods = _ref.read(paymentMethodsProvider).valueOrNull ?? [];
      final defaultCurrency = _ref.read(onboardingControllerProvider).valueOrNull?.currencyCode ?? 'SAR';

      final draft = VoiceExpenseParser.parse(
        transcript: result.transcript,
        categories: categories,
        paymentMethods: paymentMethods,
        defaultCurrencyCode: defaultCurrency,
      );

      state = state.copyWith(
        status: VoiceExpenseStatus.result,
        draft: draft,
        transcriptionDurationMs: result.durationMs,
        modelLoadMs: result.modelLoadMs,
      );

      // Safe non-sensitive analytics event without financial values
      _ref.read(analyticsServiceProvider).voiceExpenseCompleted();
    } catch (_) {
      state = state.copyWith(
        status: VoiceExpenseStatus.error,
        errorMessage: 'An error occurred during transcription.',
      );
      _ref.read(analyticsServiceProvider).voiceExpenseFailed();
    }
  }

  Future<void> cancel() async {
    _timer?.cancel();
    _timer = null;
    await _service.cancelRecording();
    state = state.copyWith(
      status: VoiceExpenseStatus.ready,
      clearDraft: true,
      clearError: true,
      recordingDuration: Duration.zero,
    );
  }

  void reset() {
    _timer?.cancel();
    _timer = null;
    state = const VoiceExpenseState(status: VoiceExpenseStatus.ready);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _service.cancelRecording();
    super.dispose();
  }
}
