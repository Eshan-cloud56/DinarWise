import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BrandLaunchScreen extends StatefulWidget {
  const BrandLaunchScreen({required this.onFinished, super.key});

  final VoidCallback onFinished;

  @override
  State<BrandLaunchScreen> createState() => _BrandLaunchScreenState();
}

class _BrandLaunchScreenState extends State<BrandLaunchScreen> {
  late final VideoPlayerController _controller;
  Timer? _fallbackTimer;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'assets/branding/DinarWise-Splash-Animation.mp4',
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: true,
        allowBackgroundPlayback: false,
      ),
    )..addListener(_handleVideoState);
    _initialize();
    _fallbackTimer = Timer(const Duration(seconds: 5), _finish);
  }

  Future<void> _initialize() async {
    try {
      await _controller.initialize();
      await _controller.setVolume(0);
      if (!mounted) return;
      setState(() {});
      await _controller.play();
    } catch (_) {
      // The poster remains visible and the bounded fallback completes launch.
    }
  }

  void _handleVideoState() {
    if (_controller.value.isCompleted) _finish();
  }

  void _finish() {
    if (_finished || !mounted) return;
    _finished = true;
    _fallbackTimer?.cancel();
    widget.onFinished();
  }

  @override
  void dispose() {
    _fallbackTimer?.cancel();
    _controller
      ..removeListener(_handleVideoState)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xff071c1a),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/branding/DinarWise-Splash-Poster.png',
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
          if (_controller.value.isInitialized)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
        ],
      ),
    );
  }
}
