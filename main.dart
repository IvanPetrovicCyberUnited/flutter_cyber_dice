import 'dart:html';
import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' hide Locator;
import 'package:flutter_dice_3d/ui/app.dart';
import 'package:flutter_dice_3d/viewmodels/dice_view_model.dart';
import 'package:flutter_dice_3d/core/di/locator.dart';

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
