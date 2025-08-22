import 'dart:async';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/dice_view_model.dart';
import '../widgets/overlay_controls.dart';
import '../widgets/fps_badge.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer _timer;
  html.DivElement? _host;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      context.read<DiceViewModel>().update(1 / 60);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DiceViewModel>();
    return Scaffold(
      body: Stack(children: [
        HtmlElementView(
          viewType: 'three-canvas',
          onPlatformViewCreated: (_) async {
            _host ??= html.DivElement()
              ..style.width = '100%'
              ..style.height = '100%';
            await vm.init(_host!);
          },
        ),
        Positioned(
          left: 16,
          top: 16,
          child: OverlayControls(
            onRoll: vm.running ? null : vm.roll,
            onReset: vm.reset,
            resultLeft: vm.result1,
            resultRight: vm.result2,
          ),
        ),
        Positioned(right: 16, top: 16, child: FpsBadge(fps: vm.fps.fps)),
      ]),
    );
  }
}
