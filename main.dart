import 'dart:html';
import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/app.dart';
import 'viewmodels/dice_view_model.dart';
import 'core/di/locator.dart';

void main() {
  ui.platformViewRegistry.registerViewFactory('three-canvas', (int viewId) {
    final div = DivElement()
      ..style.width = '100%'
      ..style.height = '100%';
    return div;
  });

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
        create: (_) => DiceViewModel(
            physics: Locator.physics(), render: Locator.render())),
  ], child: const App()));
}
