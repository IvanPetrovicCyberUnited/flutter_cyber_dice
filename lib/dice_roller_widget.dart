import 'dart:ui' as ui;
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DiceRollerWidget extends StatefulWidget {
  final int diceCount;
  const DiceRollerWidget({Key? key, required this.diceCount}) : super(key: key);

  @override
  State<DiceRollerWidget> createState() => _DiceRollerWidgetState();
}

class _DiceRollerWidgetState extends State<DiceRollerWidget> {
  late html.IFrameElement _iframe;
  late String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'dice-roller-${widget.diceCount}-${DateTime.now().millisecondsSinceEpoch}';
    _iframe = html.IFrameElement()
      ..width = '100%'
      ..height = '400'
      ..src = 'dice_roller.html'
      ..style.border = 'none';
    // Register the view
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(_viewType, (int viewId) => _iframe);
    // Wait for iframe to load, then call throwDice via postMessage
    _iframe.onLoad.listen((_) {
      _iframe.contentWindow?.postMessage({'action': 'throwDice', 'diceCount': widget.diceCount}, '*');
    });
  }

  @override
  void didUpdateWidget(covariant DiceRollerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.diceCount != widget.diceCount) {
      _iframe.contentWindow?.postMessage({'action': 'throwDice', 'diceCount': widget.diceCount}, '*');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return const Center(child: Text('3D Dice only available on web'));
    }
    return SizedBox(
      height: 400,
      child: HtmlElementView(viewType: _viewType),
    );
  }
}
