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
  Future<WhisperTranscriptionResult?> stopAndTranscribe({
    String? language,
    String? model,
    String? prompt,
  });
  Future<WhisperTranscriptionResult?> retranscribeLastAudio({
    String? language,
    String? model,
    String? prompt,
  });
  Future<Map<String, dynamic>?> testConsecutive3x({
    String? language,
    String? model,
    String? prompt,
  });
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
  Future<WhisperTranscriptionResult?> stopAndTranscribe({
    String? language,
    String? model,
    String? prompt,
  }) async {
    if (!_isAndroid) {
      // Mock result for non-Android environments (e.g. testing)
      return const WhisperTranscriptionResult(
        transcript: 'I spent 100 SAR at AlBaik using cash.',
        durationMs: 450,
        modelLoadMs: 120,
        detectedLanguage: 'en',
        audioDurationMs: 2500,
        segmentCount: 1,
        segments: ['I spent 100 SAR at AlBaik using cash.'],
        peakAmplitude: 0.65,
        rmsAmplitude: 0.18,
        modelName: 'base',
        modelSizeMb: 141.0,
        memoryUsageMb: 42.0,
        initialPrompt: '',
      );
    }
    try {
      final args = <String, dynamic>{
        if (language != null) 'language': language,
        if (model != null) 'model': model,
        if (prompt != null) 'prompt': prompt,
      };
      final raw = await _channel.invokeMapMethod<String, dynamic>(
        'stopAndTranscribe',
        args.isNotEmpty ? args : null,
      );
      if (raw == null) return null;

      final rawSegments = raw['segments'] as List<dynamic>? ?? [];
      final segments = rawSegments.map((s) => s.toString()).toList();

      return WhisperTranscriptionResult(
        transcript: (raw['transcript'] as String? ?? '').trim(),
        durationMs: (raw['durationMs'] as num? ?? 0).toInt(),
        modelLoadMs: (raw['modelLoadMs'] as num? ?? 0).toInt(),
        detectedLanguage: (raw['detectedLanguage'] as String? ?? 'auto').trim(),
        audioDurationMs: (raw['audioDurationMs'] as num? ?? 0).toInt(),
        segmentCount: (raw['segmentCount'] as num? ?? segments.length).toInt(),
        segments: segments,
        peakAmplitude: (raw['peakAmplitude'] as num? ?? 0.0).toDouble(),
        rmsAmplitude: (raw['rmsAmplitude'] as num? ?? 0.0).toDouble(),
        modelName: raw['modelName'] as String? ?? 'base',
        modelSizeMb: (raw['modelSizeMb'] as num? ?? 0.0).toDouble(),
        memoryUsageMb: (raw['memoryUsageMb'] as num? ?? 0.0).toDouble(),
        initialPrompt: raw['initialPrompt'] as String? ?? '',
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<WhisperTranscriptionResult?> retranscribeLastAudio({
    String? language,
    String? model,
    String? prompt,
  }) async {
    if (!_isAndroid) return null;
    try {
      final args = <String, dynamic>{
        if (language != null) 'language': language,
        if (model != null) 'model': model,
        if (prompt != null) 'prompt': prompt,
      };
      final raw = await _channel.invokeMapMethod<String, dynamic>(
        'retranscribeLastAudio',
        args.isNotEmpty ? args : null,
      );
      if (raw == null) return null;

      final rawSegments = raw['segments'] as List<dynamic>? ?? [];
      final segments = rawSegments.map((s) => s.toString()).toList();

      return WhisperTranscriptionResult(
        transcript: (raw['transcript'] as String? ?? '').trim(),
        durationMs: (raw['durationMs'] as num? ?? 0).toInt(),
        modelLoadMs: (raw['modelLoadMs'] as num? ?? 0).toInt(),
        detectedLanguage: (raw['detectedLanguage'] as String? ?? 'auto').trim(),
        audioDurationMs: (raw['audioDurationMs'] as num? ?? 0).toInt(),
        segmentCount: (raw['segmentCount'] as num? ?? segments.length).toInt(),
        segments: segments,
        peakAmplitude: (raw['peakAmplitude'] as num? ?? 0.0).toDouble(),
        rmsAmplitude: (raw['rmsAmplitude'] as num? ?? 0.0).toDouble(),
        modelName: raw['modelName'] as String? ?? 'base',
        modelSizeMb: (raw['modelSizeMb'] as num? ?? 0.0).toDouble(),
        memoryUsageMb: (raw['memoryUsageMb'] as num? ?? 0.0).toDouble(),
        initialPrompt: raw['initialPrompt'] as String? ?? '',
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>?> testConsecutive3x({
    String? language,
    String? model,
    String? prompt,
  }) async {
    if (!_isAndroid) {
      return const {
        'isIdentical': true,
        'run1': 'I spent 100 SAR at Al Baik today using bank transfer.',
        'run2': 'I spent 100 SAR at Al Baik today using bank transfer.',
        'run3': 'I spent 100 SAR at Al Baik today using bank transfer.',
        'dur1': 1800,
        'dur2': 1750,
        'dur3': 1740,
      };
    }
    try {
      final args = <String, dynamic>{
        if (language != null) 'language': language,
        if (model != null) 'model': model,
        if (prompt != null) 'prompt': prompt,
      };
      final raw = await _channel.invokeMapMethod<String, dynamic>(
        'testConsecutive3x',
        args.isNotEmpty ? args : null,
      );
      return raw;
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
