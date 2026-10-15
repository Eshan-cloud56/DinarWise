class WhisperTranscriptionResult {
  const WhisperTranscriptionResult({
    required this.transcript,
    required this.durationMs,
    required this.modelLoadMs,
    this.detectedLanguage = 'auto',
    this.audioDurationMs = 0,
    this.segmentCount = 1,
    this.segments = const [],
    this.peakAmplitude = 0.0,
    this.rmsAmplitude = 0.0,
    this.modelName = 'base',
    this.modelSizeMb = 0.0,
    this.memoryUsageMb = 0.0,
    this.initialPrompt = '',
  });

  final String transcript;
  final int durationMs;
  final int modelLoadMs;
  final String detectedLanguage;
  final int audioDurationMs;
  final int segmentCount;
  final List<String> segments;
  final double peakAmplitude;
  final double rmsAmplitude;
  final String modelName;
  final double modelSizeMb;
  final double memoryUsageMb;
  final String initialPrompt;
}

abstract class SpeechToTextService {
  Future<bool> isAvailable();
  Future<WhisperTranscriptionResult> transcribeAudio();
  Future<void> release();
}
