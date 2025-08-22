import 'package:flutter/material.dart';

class OverlayControls extends StatelessWidget {
  final VoidCallback? onRoll;
  final VoidCallback onReset;
  final int? resultLeft;
  final int? resultRight;
  const OverlayControls({super.key, this.onRoll, required this.onReset, this.resultLeft, this.resultRight});

  @override
  Widget build(BuildContext context) {
    final sum = (resultLeft != null && resultRight != null) ? (resultLeft! + resultRight!) : null;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            ElevatedButton(onPressed: onRoll, child: const Text('Roll')),
            const SizedBox(width: 8),
            OutlinedButton(onPressed: onReset, child: const Text('Reset')),
          ]),
          const SizedBox(height: 8),
          Text(sum != null ? 'Ergebnis: $resultLeft + $resultRight = $sum' : 'Würfeln…'),
        ]),
      ),
    );
  }
}
