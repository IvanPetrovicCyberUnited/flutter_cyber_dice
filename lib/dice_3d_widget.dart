import 'dart:math';

import 'package:flutter/material.dart';

class Dice3DWidget extends StatefulWidget {
  final int value;
  final Duration duration;
  final double size;
  final bool animate;
  final bool burned;
  const Dice3DWidget({
    super.key,
    required this.value,
    this.duration = const Duration(milliseconds: 800),
    this.size = 48,
    this.animate = false,
    this.burned = false,
  });

  @override
  State<Dice3DWidget> createState() => _Dice3DWidgetState();
}

class _Dice3DWidgetState extends State<Dice3DWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationX;
  late Animation<double> _rotationY;
  late int _displayValue;

  @override
  void initState() {
    super.initState();
    _displayValue = widget.value;
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _rotationX = Tween<double>(begin: 0, end: pi * 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _rotationY = Tween<double>(begin: 0, end: pi * 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant Dice3DWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value || widget.animate) {
      _controller.reset();
      _controller.forward();
      _displayValue = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..rotateX(_rotationX.value)
            ..rotateY(_rotationY.value),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.burned ? Colors.black87 : Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: widget.burned
                      ? Colors.red.withOpacity(0.25)
                      : Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(2, 4),
                ),
              ],
              border: Border.all(
                color: widget.burned ? Colors.red.shade900 : Colors.deepPurple,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                '$_displayValue',
                style: TextStyle(
                  fontSize: widget.size * 0.6,
                  fontWeight: FontWeight.bold,
                  color: widget.burned
                      ? Colors.orange.shade200
                      : Colors.deepPurple,
                  shadows: [
                    Shadow(
                      color: widget.burned
                          ? Colors.red.withOpacity(0.4)
                          : Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(1, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
