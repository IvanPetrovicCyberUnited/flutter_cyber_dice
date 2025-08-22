import 'dart:math';

import 'package:flutter/material.dart';

class SnowEffect extends StatefulWidget {
  final bool active;
  final int diceCount;
  final double width;
  final double height;
  const SnowEffect({
    super.key,
    required this.active,
    required this.diceCount,
    required this.width,
    required this.height,
  });

  @override
  State<SnowEffect> createState() => _SnowEffectState();
}

class _SnowEffectState extends State<SnowEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Snowflake> _flakes;
  final int _flakeCount = 40;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..repeat();
    _flakes = List.generate(
        _flakeCount, (i) => _Snowflake(widget.width, widget.height));
  }

  @override
  void didUpdateWidget(covariant SnowEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.width != oldWidget.width || widget.height != oldWidget.height) {
      _flakes = List.generate(
          _flakeCount, (i) => _Snowflake(widget.width, widget.height));
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
          painter: _SnowPainter(_flakes, _controller.value),
        );
      },
    );
  }
}

class _Snowflake {
  double x, y, r, speed, wind, phase;
  _Snowflake(double w, double h)
      : x = Random().nextDouble() * w,
        y = Random().nextDouble() * h,
        r = 2 + Random().nextDouble() * 2,
        speed = 0.5 + Random().nextDouble() * 1.5,
        wind = -0.5 + Random().nextDouble() * 1.0,
        phase = Random().nextDouble() * 2 * pi;
}

class _SnowPainter extends CustomPainter {
  final List<_Snowflake> flakes;
  final double progress;
  _SnowPainter(this.flakes, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.85);
    for (final f in flakes) {
      final dx = f.x +
          sin(progress * 2 * pi + f.phase) * 10 +
          f.wind * progress * size.width * 0.2;
      final dy = (f.y + (progress * size.height * f.speed)) % size.height;
      canvas.drawCircle(Offset(dx, dy), f.r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SnowPainter oldDelegate) => true;
}
