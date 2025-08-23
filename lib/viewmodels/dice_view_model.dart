import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:vector_math/vector_math_64.dart';
import '../domain/services/physics_service.dart';
import '../domain/services/render_service.dart';
import '../core/utils/fps_counter.dart';
import '../sound_effects.dart';


class DiceViewModel extends ChangeNotifier {
  final PhysicsService physics;
  final RenderService render;
  late String dice1Body, dice2Body;
  late String dice1Mesh, dice2Mesh;
  bool ready = false;
  bool running = false;
  int? result1, result2;
  final fps = FpsCounter();

  DiceViewModel({required this.physics, required this.render});

  Future<void> init(html.Element host) async {
    await render.init(host: host as html.HtmlElement);
    await physics.init();
    physics.addGround(size: 50);
    render.addGroundMesh(50);
    dice1Mesh = render.addDiceMesh(1.0, textureAsset: 'assets/textures/dice_uv.png');
    dice2Mesh = render.addDiceMesh(1.0, textureAsset: 'assets/textures/dice_uv.png');
    dice1Body = physics.addDice(size: 1.0, mass: 1.0);
    dice2Body = physics.addDice(size: 1.0, mass: 1.0);
    roll();
    ready = true;
    notifyListeners();
  }

  void roll() {
    result1 = null;
    result2 = null;
    physics.randomizeDice(dice1Body, xBias: -1.2);
    physics.randomizeDice(dice2Body, xBias: 1.2);
    SoundEffects.playStandard();

    running = true;
    notifyListeners();
  }

  void reset() {
    physics.resetBodies();
    result1 = null;
    result2 = null;
    running = false;
    notifyListeners();
  }

  void update(double dt) {
    if (!ready) return;
    physics.step(dt);
    final s1 = physics.stateOf(dice1Body);
    final s2 = physics.stateOf(dice2Body);
    render.sync(dice1Mesh, s1.position, s1.rotation);
    render.sync(dice2Mesh, s2.position, s2.rotation);
    render.renderFrame();
    fps.tick(dt);
    if (running && s1.sleeping && s2.sleeping) {
      result1 = physics.topFace(dice1Body);
      result2 = physics.topFace(dice2Body);
      running = false;
      notifyListeners();
    }
  }
}
