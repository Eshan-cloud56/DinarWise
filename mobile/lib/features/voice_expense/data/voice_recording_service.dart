import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dinarwise/features/voice_expense/data/speech_to_text_service.dart';

final voiceRecordingServiceProvider = Provider<VoiceRecordingService>((ref) {
  return PlatformVoiceRecordingService();
});

abstract class VoiceRecordingService {
  Future<bool> hasPermission();
  Future<bool> requestPermission();
  Future<bool> startRecording();
  Future<WhisperTranscriptionResult?> stopAndTranscribe();
  Future<void> cancelRecording();
  Future<void> release();
}

class PlatformVoiceRecordingService implements VoiceRecordingService {
  static const MethodChannel _channel = MethodChannel('dinarwise/voice_expense');

  bool get _isAndroid => Platform.isAndroid;

  @override
  Future<bool> hasPermission() async {
    if (!_isAndroid) return true;
    try {
      final res = await _channel.invokeMethod<bool>('hasPermission');
      return res ?? false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> requestPermission() async {
    if (!_isAndroid) return true;
    try {
      final res = await _channel.invokeMethod<bool>('requestPermission');
      return res ?? false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> startRecording() async {
    if (!_isAndroid) return true;
    try {
      final res = await _channel.invokeMethod<bool>('startRecording');
      return res ?? false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<WhisperTranscriptionResult?> stopAndTranscribe() async {
    if (!_isAndroid) {
      // Mock result for non-Android environments (e.g. testing)
      return const WhisperTranscriptionResult(
        transcript: 'I spent 100 SAR at AlBaik using cash.',
        durationMs: 450,
        modelLoadMs: 120,
      );
    }
    try {
      final raw = await _channel.invokeMapMethod<String, dynamic>('stopAndTranscribe');
      if (raw == null) return null;

      return WhisperTranscriptionResult(
        transcript: (raw['transcript'] as String? ?? '').trim(),
        durationMs: (raw['durationMs'] as num? ?? 0).toInt(),
        modelLoadMs: (raw['modelLoadMs'] as num? ?? 0).toInt(),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cancelRecording() async {
    if (!_isAndroid) return;
    try {
      await _channel.invokeMethod('cancelRecording');
    } catch (_) {}
  }

  @override
  Future<void> release() async {
    if (!_isAndroid) return;
    try {
      await _channel.invokeMethod('release');
    } catch (_) {}
  }
}
