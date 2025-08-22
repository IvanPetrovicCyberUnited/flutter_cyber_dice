import 'dart:math';

import 'package:flutter/material.dart';

class VolcanoEffect extends StatefulWidget {
  final bool active;
  final double width;
  final double height;
  const VolcanoEffect({
    super.key,
    required this.active,
    required this.width,
    required this.height,
  });

  @override
  State<VolcanoEffect> createState() => _VolcanoEffectState();
}

class _VolcanoEffectState extends State<VolcanoEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final int _lavaCount = 30;
  late List<_LavaParticle> _particles;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..repeat();
    _particles = List.generate(
        _lavaCount, (i) => _LavaParticle(widget.width, widget.height));
  }

  @override
  void didUpdateWidget(covariant VolcanoEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.width != oldWidget.width || widget.height != oldWidget.height) {
      _particles = List.generate(
          _lavaCount, (i) => _LavaParticle(widget.width, widget.height));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active) return const SizedBox.shrink();
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.width, widget.height),
          painter: _VolcanoPainter(_particles, _controller.value),
        );
      },
    );
  }
}

class _LavaParticle {
  double x, y, vx, vy, r, t0;
  _LavaParticle(double w, double h)
      : x = w / 2 + Random().nextDouble() * 40 - 20,
        y = h - 30,
        vx = (Random().nextDouble() - 0.5) * 6,
        vy = -8 - Random().nextDouble() * 6,
        r = 4 + Random().nextDouble() * 3,
        t0 = Random().nextDouble();
}

class _VolcanoPainter extends CustomPainter {
  final List<_LavaParticle> particles;
  final double progress;
  _VolcanoPainter(this.particles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw volcano
    final volcanoPaint = Paint()..color = Colors.brown.shade800;
    final baseY = size.height - 20;
    final volcanoPath = Path()
      ..moveTo(size.width / 2 - 40, baseY)
      ..lineTo(size.width / 2, baseY - 60)
      ..lineTo(size.width / 2 + 40, baseY)
      ..close();
    canvas.drawPath(volcanoPath, volcanoPaint);
    // Draw lava particles
    for (final p in particles) {
      final t = (progress + p.t0) % 1.0;
      final px = p.x + p.vx * t * 60;
      final py = p.y + p.vy * t * 60 + 0.5 * 9.8 * pow(t * 2.5, 2);
      final lavaPaint = Paint()
        ..color = Colors.orange.withOpacity(1 - t)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawCircle(Offset(px, py), p.r, lavaPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _VolcanoPainter oldDelegate) => true;
}
