import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dinarwise/core/analytics/analytics_service.dart';
import 'package:dinarwise/core/preferences/onboarding_controller.dart';
import 'package:dinarwise/features/categories/data/category_repository.dart';
import 'package:dinarwise/features/expenses/data/expense_providers.dart';
import 'package:dinarwise/features/payment_methods/payment_method_repository.dart';
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
  static const String defaultFinancePrompt =
      'SAR, Saudi riyal, riyals, AED, dirham, dirhams, KWD, BHD, QAR, OMR, cash, bank transfer, Visa, Mastercard, Mada, Apple Pay, STC Pay, groceries, coffee, fuel, taxi, shopping, subscription, Al Baik, Carrefour, Starbucks, Panda, Apple Store, Jarir, Amazon, Uber, Careem.';

  const VoiceExpenseState({
    required this.status,
    this.draft,
    this.errorMessage,
    this.recordingDuration = Duration.zero,
    this.transcriptionDurationMs,
    this.modelLoadMs,
    this.rawTranscript,
    this.detectedLanguage,
    this.audioDurationMs,
    this.segmentCount,
    this.segments = const [],
    this.peakAmplitude,
    this.rmsAmplitude,
    this.forcedLanguage = 'en',
    this.modelName = 'base',
    this.promptEnabled = true,
    this.initialPrompt,
    this.modelSizeMb,
    this.memoryUsageMb,
    this.hasCachedAudio = false,
    this.consecutiveTestResult,
    this.isRunningConsecutiveTest = false,
  });

  final VoiceExpenseStatus status;
  final VoiceExpenseDraft? draft;
  final String? errorMessage;
  final Duration recordingDuration;
  final int? transcriptionDurationMs;
  final int? modelLoadMs;
  final String? rawTranscript;
  final String? detectedLanguage;
  final int? audioDurationMs;
  final int? segmentCount;
  final List<String> segments;
  final double? peakAmplitude;
  final double? rmsAmplitude;
  final String? forcedLanguage; // null = auto, 'en' = forced English
  final String modelName; // 'base' or 'tiny'
  final bool promptEnabled;
  final String? initialPrompt;
  final double? modelSizeMb;
  final double? memoryUsageMb;
  final bool hasCachedAudio;
  final Map<String, dynamic>? consecutiveTestResult;
  final bool isRunningConsecutiveTest;

  VoiceExpenseState copyWith({
    VoiceExpenseStatus? status,
    VoiceExpenseDraft? draft,
    String? errorMessage,
    Duration? recordingDuration,
    int? transcriptionDurationMs,
    int? modelLoadMs,
    String? rawTranscript,
    String? detectedLanguage,
    int? audioDurationMs,
    int? segmentCount,
    List<String>? segments,
    double? peakAmplitude,
    double? rmsAmplitude,
    String? forcedLanguage,
    String? modelName,
    bool? promptEnabled,
    String? initialPrompt,
    double? modelSizeMb,
    double? memoryUsageMb,
    bool? hasCachedAudio,
    Map<String, dynamic>? consecutiveTestResult,
    bool? isRunningConsecutiveTest,
    bool clearDraft = false,
    bool clearError = false,
    bool clearForcedLanguage = false,
    bool clearConsecutiveTest = false,
  }) {
    return VoiceExpenseState(
      status: status ?? this.status,
      draft: clearDraft ? null : (draft ?? this.draft),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      recordingDuration: recordingDuration ?? this.recordingDuration,
      transcriptionDurationMs: transcriptionDurationMs ?? this.transcriptionDurationMs,
      modelLoadMs: modelLoadMs ?? this.modelLoadMs,
      rawTranscript: rawTranscript ?? this.rawTranscript,
      detectedLanguage: detectedLanguage ?? this.detectedLanguage,
      audioDurationMs: audioDurationMs ?? this.audioDurationMs,
      segmentCount: segmentCount ?? this.segmentCount,
      segments: segments ?? this.segments,
      peakAmplitude: peakAmplitude ?? this.peakAmplitude,
      rmsAmplitude: rmsAmplitude ?? this.rmsAmplitude,
      forcedLanguage: clearForcedLanguage ? null : (forcedLanguage ?? this.forcedLanguage),
      modelName: modelName ?? this.modelName,
      promptEnabled: promptEnabled ?? this.promptEnabled,
      initialPrompt: initialPrompt ?? this.initialPrompt,
      modelSizeMb: modelSizeMb ?? this.modelSizeMb,
      memoryUsageMb: memoryUsageMb ?? this.memoryUsageMb,
      hasCachedAudio: hasCachedAudio ?? this.hasCachedAudio,
      consecutiveTestResult: clearConsecutiveTest ? null : (consecutiveTestResult ?? this.consecutiveTestResult),
      isRunningConsecutiveTest: isRunningConsecutiveTest ?? this.isRunningConsecutiveTest,
    );
  }
}

final voiceExpenseCoordinatorProvider =
    StateNotifierProvider.autoDispose<VoiceExpenseCoordinator, VoiceExpenseState>((ref) {
  return VoiceExpenseCoordinator(ref);
});

class VoiceExpenseCoordinator extends StateNotifier<VoiceExpenseState> {
  VoiceExpenseCoordinator(this._ref, [VoiceRecordingService? service])
      : _service = service ?? _ref.read(voiceRecordingServiceProvider),
        super(const VoiceExpenseState(
          status: VoiceExpenseStatus.ready,
          forcedLanguage: 'en',
          modelName: 'base',
          promptEnabled: true,
        ));

  final Ref _ref;
  final VoiceRecordingService _service;
  Timer? _timer;
  DateTime? _recordStartTime;

  void setModel(String model) {
    state = state.copyWith(modelName: model);
  }

  void setPromptEnabled(bool enabled) {
    state = state.copyWith(promptEnabled: enabled);
  }

  void setForcedLanguage(String? lang) {
    state = state.copyWith(
      forcedLanguage: lang,
      clearForcedLanguage: lang == null,
    );
  }

  Future<void> startListening() async {
    try {
      final hasPerm = await _service.hasPermission();
      if (!hasPerm) {
        final granted = await _service.requestPermission();
        if (!granted) {
          state = state.copyWith(
            status: VoiceExpenseStatus.error,
            errorMessage: 'Microphone permission is required to use Voice Expense.',
          );
          return;
        }
      }

      final started = await _service.startRecording();
      if (!started) {
        state = state.copyWith(
          status: VoiceExpenseStatus.error,
          errorMessage: 'Could not initialize audio recording.',
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
      final prompt = state.promptEnabled ? VoiceExpenseState.defaultFinancePrompt : null;
      final result = await _service.stopAndTranscribe(
        language: state.forcedLanguage,
        model: state.modelName,
        prompt: prompt,
      );
      if (result == null || result.transcript.isEmpty) {
        state = state.copyWith(
          status: VoiceExpenseStatus.error,
          errorMessage: 'No speech was detected. Please try speaking again.',
        );
        _ref.read(analyticsServiceProvider).voiceExpenseFailed();
        return;
      }

      if (kDebugMode) {
        debugPrint('VoiceExpense [Debug]: Model=${result.modelName} '
            '(${result.modelSizeMb.toStringAsFixed(1)}MB), Mem=${result.memoryUsageMb.toStringAsFixed(1)}MB '
            'Prompt="${result.initialPrompt}" Raw transcript="${result.transcript}" '
            'lang=${result.detectedLanguage} audio=${result.audioDurationMs}ms '
            'inf=${result.durationMs}ms segments=${result.segmentCount} '
            'peak=${result.peakAmplitude.toStringAsFixed(2)} '
            'rms=${result.rmsAmplitude.toStringAsFixed(2)}');
      }

      // Await real database records before deterministic parsing
      final categories = await _ref
          .read(categoriesProvider.future)
          .catchError((_) => _ref.read(categoriesProvider).valueOrNull ?? <CategoryRecord>[]);
      final paymentMethods = await _ref
          .read(paymentMethodsProvider.future)
          .catchError((_) => _ref.read(paymentMethodsProvider).valueOrNull ?? <PaymentMethodDetails>[]);
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
        rawTranscript: result.transcript,
        detectedLanguage: result.detectedLanguage,
        audioDurationMs: result.audioDurationMs,
        segmentCount: result.segmentCount,
        segments: result.segments,
        peakAmplitude: result.peakAmplitude,
        rmsAmplitude: result.rmsAmplitude,
        transcriptionDurationMs: result.durationMs,
        modelLoadMs: result.modelLoadMs,
        modelName: result.modelName,
        modelSizeMb: result.modelSizeMb,
        memoryUsageMb: result.memoryUsageMb,
        initialPrompt: result.initialPrompt,
        hasCachedAudio: true,
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

  Future<void> retranscribeLastAudio({
    bool? promptEnabled,
    String? model,
    String? language,
  }) async {
    final usePrompt = promptEnabled ?? state.promptEnabled;
    final useModel = model ?? state.modelName;
    final useLanguage = language ?? state.forcedLanguage;

    state = state.copyWith(
      status: VoiceExpenseStatus.processing,
      promptEnabled: usePrompt,
      modelName: useModel,
      forcedLanguage: useLanguage,
      clearForcedLanguage: useLanguage == null,
    );

    try {
      final promptStr = usePrompt ? VoiceExpenseState.defaultFinancePrompt : null;
      final result = await _service.retranscribeLastAudio(
        language: useLanguage,
        model: useModel,
        prompt: promptStr,
      );

      if (result == null || result.transcript.isEmpty) {
        state = state.copyWith(
          status: VoiceExpenseStatus.error,
          errorMessage: 'Could not re-transcribe previous recording.',
        );
        return;
      }

      if (kDebugMode) {
        debugPrint('VoiceExpense [Debug Re-test]: Model=${result.modelName} '
            '(${result.modelSizeMb.toStringAsFixed(1)}MB), Mem=${result.memoryUsageMb.toStringAsFixed(1)}MB '
            'Prompt="${result.initialPrompt}" Raw transcript="${result.transcript}" '
            'lang=${result.detectedLanguage} audio=${result.audioDurationMs}ms '
            'inf=${result.durationMs}ms segments=${result.segmentCount} '
            'peak=${result.peakAmplitude.toStringAsFixed(2)} '
            'rms=${result.rmsAmplitude.toStringAsFixed(2)}');
      }

      // Await real database records before deterministic parsing
      final categories = await _ref
          .read(categoriesProvider.future)
          .catchError((_) => _ref.read(categoriesProvider).valueOrNull ?? <CategoryRecord>[]);
      final paymentMethods = await _ref
          .read(paymentMethodsProvider.future)
          .catchError((_) => _ref.read(paymentMethodsProvider).valueOrNull ?? <PaymentMethodDetails>[]);
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
        rawTranscript: result.transcript,
        detectedLanguage: result.detectedLanguage,
        audioDurationMs: result.audioDurationMs,
        segmentCount: result.segmentCount,
        segments: result.segments,
        peakAmplitude: result.peakAmplitude,
        rmsAmplitude: result.rmsAmplitude,
        transcriptionDurationMs: result.durationMs,
        modelLoadMs: result.modelLoadMs,
        modelName: result.modelName,
        modelSizeMb: result.modelSizeMb,
        memoryUsageMb: result.memoryUsageMb,
        initialPrompt: result.initialPrompt,
        hasCachedAudio: true,
      );
    } catch (_) {
      state = state.copyWith(
        status: VoiceExpenseStatus.error,
        errorMessage: 'An error occurred during re-transcription.',
      );
    }
  }

  Future<void> runConsecutive3xTest() async {
    state = state.copyWith(
      isRunningConsecutiveTest: true,
      clearConsecutiveTest: true,
    );

    try {
      final prompt = state.promptEnabled ? VoiceExpenseState.defaultFinancePrompt : null;
      final result = await _service.testConsecutive3x(
        language: state.forcedLanguage,
        model: state.modelName,
        prompt: prompt,
      );

      state = state.copyWith(
        isRunningConsecutiveTest: false,
        consecutiveTestResult: result,
      );
    } catch (_) {
      state = state.copyWith(isRunningConsecutiveTest: false);
    }
  }

  Future<void> cancel() async {
    _timer?.cancel();
    _timer = null;
    await _service.cancelRecording();
    state = VoiceExpenseState(
      status: VoiceExpenseStatus.ready,
      forcedLanguage: state.forcedLanguage,
      modelName: state.modelName,
      promptEnabled: state.promptEnabled,
      hasCachedAudio: false,
    );
  }

  void reset() {
    if (!mounted) return;
    _timer?.cancel();
    _timer = null;
    _service.cancelRecording();
    state = VoiceExpenseState(
      status: VoiceExpenseStatus.ready,
      forcedLanguage: state.forcedLanguage,
      modelName: state.modelName,
      promptEnabled: state.promptEnabled,
      hasCachedAudio: false,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _service.cancelRecording();
    super.dispose();
  }
}
