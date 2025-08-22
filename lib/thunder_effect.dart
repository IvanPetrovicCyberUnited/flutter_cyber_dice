import 'dart:math';

import 'package:flutter/material.dart';

class ThunderEffect extends StatefulWidget {
  final bool active;
  final double width;
  final double height;
  final int diceCount;
  const ThunderEffect({
    super.key,
    required this.active,
    required this.width,
    required this.height,
    required this.diceCount,
  });

  @override
  State<ThunderEffect> createState() => _ThunderEffectState();
}

class _ThunderEffectState extends State<ThunderEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final int _boltCount = 6;
  late List<_Bolt> _bolts;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..forward();
    _bolts =
        List.generate(_boltCount, (i) => _Bolt(widget.width, widget.height));
  }

  @override
  void didUpdateWidget(covariant ThunderEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.width != oldWidget.width || widget.height != oldWidget.height) {
      _bolts =
          List.generate(_boltCount, (i) => _Bolt(widget.width, widget.height));
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
          painter: _ThunderPainter(_bolts, _controller.value),
        );
      },
    );
  }
}

class _Bolt {
  double x, y;
  _Bolt(double w, double h)
      : x = 40 + Random().nextDouble() * (w - 80),
        y = 40 + Random().nextDouble() * (h - 80);
}

class _ThunderPainter extends CustomPainter {
  final List<_Bolt> bolts;
  final double progress;
  _ThunderPainter(this.bolts, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellowAccent.withOpacity(1 - progress)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    for (final b in bolts) {
      if (progress < 0.7) {
        final boltLen = 60 + 40 * sin(progress * pi * 2);
        final path = Path()
          ..moveTo(b.x, 0)
          ..lineTo(b.x + 10 * sin(progress * 8), b.y - boltLen / 2)
          ..lineTo(b.x, b.y)
          ..lineTo(b.x + 10 * cos(progress * 8), b.y + boltLen / 2)
          ..lineTo(b.x, size.height);
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ThunderPainter oldDelegate) => true;
}
