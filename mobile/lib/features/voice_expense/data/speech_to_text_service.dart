class WhisperTranscriptionResult {
  const WhisperTranscriptionResult({
    required this.transcript,
    required this.durationMs,
    required this.modelLoadMs,
  });

  final String transcript;
  final int durationMs;
  final int modelLoadMs;
}

abstract class SpeechToTextService {
  Future<bool> isAvailable();
  Future<WhisperTranscriptionResult> transcribeAudio();
  Future<void> release();
}
