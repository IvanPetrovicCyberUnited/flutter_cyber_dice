import 'package:flutter/material.dart';

class FpsBadge extends StatelessWidget {
  final double fps;
  const FpsBadge({super.key, required this.fps});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
            color: Colors.black54, borderRadius: BorderRadius.circular(12)),
        child: Text('${fps.toStringAsFixed(0)} FPS',
            style: const TextStyle(color: Colors.white)),
      );
}
