import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Native translation of the supplied Stitch SVG/CSS. No video/network delay,
/// mock status bar, banking claims, or telemetry changes.
class BrandLaunchScreen extends StatefulWidget {
  const BrandLaunchScreen({required this.onFinished, super.key});
  final VoidCallback onFinished;
  @override
  State<BrandLaunchScreen> createState() => _BrandLaunchScreenState();
}

class _BrandLaunchScreenState extends State<BrandLaunchScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _finished = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2600))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted && !_finished) {
          _finished = true;
          widget.onFinished();
        }
      })
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: const Color(0xFF041712)),
        child: ColoredBox(
          color: const Color(0xFF041712),
          child: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
            final size = math.min(
                320.0,
                math.min(
                    constraints.maxWidth * .85, constraints.maxHeight * .5));
            return Center(
                child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) =>
                  Column(mainAxisSize: MainAxisSize.min, children: [
                Semantics(
                    label: 'DinarWise',
                    image: true,
                    child: CustomPaint(
                        key: const ValueKey('stitchOpeningEmblem'),
                        size: Size.square(size),
                        painter: _OpeningPainter(_controller.value))),
                Opacity(
                    opacity: ((_controller.value - .15) / .45).clamp(0, 1),
                    child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 12,
                            children: [
                              Text('DinarWise',
                                  style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      decoration: TextDecoration.none)),
                              Text('دينار وايز',
                                  style: TextStyle(
                                      fontFamily: 'NotoSansArabic',
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFE2BA48),
                                      decoration: TextDecoration.none)),
                            ]))),
                const SizedBox(height: 24),
                SizedBox(
                    width: size * .6,
                    child: LinearProgressIndicator(
                        value: _controller.value,
                        minHeight: 3,
                        borderRadius: BorderRadius.circular(3),
                        color: const Color(0xFFE2BA48),
                        backgroundColor: Colors.white10)),
              ]),
            ));
          })),
        ),
      );
}

class _OpeningPainter extends CustomPainter {
  _OpeningPainter(this.progress);
  final double progress;
  static const gold = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFFFF3C4),
        Color(0xFFE2BA48),
        Color(0xFFB88A22),
        Color(0xFFF7E298)
      ],
      stops: [
        0,
        .35,
        .7,
        1
      ]);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 400, size.height / 400);
    const center = Offset(200, 200);
    canvas.drawCircle(
        center,
        170 + 12 * math.sin(progress * math.pi),
        Paint()
          ..shader = RadialGradient(colors: [
            const Color(0xFF1FD69E).withValues(alpha: .25),
            const Color(0xFF0E4D3E).withValues(alpha: .12),
            Colors.transparent,
          ]).createShader(const Rect.fromLTWH(0, 0, 400, 400)));
    canvas.save();
    canvas.translate(200, 200);
    canvas.rotate(progress * 2.6 / 12 * math.pi * 2);
    canvas.translate(-200, -200);
    final ring = Paint()
      ..shader = gold.createShader(const Rect.fromLTWH(70, 70, 260, 260))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.white.withValues(alpha: .35);
    for (var i = 0; i < 4; i++) {
      canvas.drawArc(const Rect.fromLTWH(70, 70, 260, 260), i * math.pi / 2,
          1.15, false, ring);
      final angle = i * math.pi / 2;
      canvas.drawCircle(
          center + Offset(math.sin(angle), math.cos(angle)) * 155,
          2.5,
          Paint()
            ..color =
                i.isEven ? const Color(0xFFD4AF37) : const Color(0xFF34EEAF));
    }
    canvas.restore();
    final entrance =
        Curves.easeOutBack.transform((progress * 2.6 / 1.6).clamp(0, 1));
    canvas.save();
    canvas.translate(200, 200);
    canvas.scale(.65 + .35 * entrance);
    canvas.rotate((1 - entrance) * -.14);
    canvas.translate(-200, -200);
    final badge = RRect.fromRectAndRadius(
        const Rect.fromLTWH(90, 90, 220, 220), const Radius.circular(60));
    canvas.drawRRect(
        badge,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF125948), Color(0xFF09382C), Color(0xFF041B15)],
          ).createShader(badge.outerRect));
    canvas.drawRRect(
        badge.deflate(1.5),
        Paint()
          ..shader = gold.createShader(badge.outerRect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5);
    final outer = Path()
      ..moveTo(156, 142)
      ..lineTo(196, 142)
      ..cubicTo(226, 142, 248, 164, 248, 198)
      ..cubicTo(248, 232, 226, 254, 196, 254)
      ..lineTo(156, 254)
      ..close();
    final inner = Path()
      ..moveTo(182, 168)
      ..lineTo(196, 168)
      ..cubicTo(214, 168, 226, 180, 226, 198)
      ..cubicTo(226, 216, 214, 228, 196, 228)
      ..lineTo(182, 228)
      ..close();
    void drawPath(Path path, Paint paint, double seconds) {
      for (final metric in path.computeMetrics()) {
        canvas.drawPath(
            metric.extractPath(
                0,
                metric.length *
                    Curves.easeOut
                        .transform((progress * 2.6 / seconds).clamp(0, 1))),
            paint);
      }
    }

    drawPath(
        outer,
        Paint()
          ..shader = gold.createShader(badge.outerRect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 9
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
        2);
    drawPath(
        inner,
        Paint()
          ..color = const Color(0xFF2EE59D)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
        2.2);
    final star = Path()
      ..moveTo(194, 190)
      ..lineTo(200, 172)
      ..lineTo(206, 190)
      ..lineTo(224, 197)
      ..lineTo(206, 204)
      ..lineTo(200, 222)
      ..lineTo(194, 204)
      ..lineTo(176, 197)
      ..close();
    canvas.save();
    canvas.translate(200, 197);
    canvas.scale(
        Curves.easeOutBack.transform((progress * 2.6 / 1.8).clamp(0, 1)));
    canvas.translate(-200, -197);
    canvas.drawPath(star, Paint()..shader = gold.createShader(badge.outerRect));
    canvas.restore();
    canvas.drawCircle(
        const Offset(244, 156),
        6 * (progress * 2.6 / 1.6).clamp(0, 1),
        Paint()..shader = gold.createShader(badge.outerRect));
    canvas.restore();
  }

  @override
  bool shouldRepaint(_OpeningPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
