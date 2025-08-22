import 'dart:html';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dice_3d/viewmodels/dice_view_model.dart';
import 'package:flutter_dice_3d/domain/services/physics_service.dart';
import 'package:flutter_dice_3d/domain/services/render_service.dart';
import 'package:vector_math/vector_math_64.dart';

class FakeRenderService implements RenderService {
  @override
  Future<void> init({required HtmlElement host}) async {}
  @override
  String addGroundMesh(double size) => 'g';
  @override
  String addDiceMesh(double size, {String? textureAsset}) => 'm$size';
  @override
  void sync(String meshId, Vector3 pos, Quaternion rot) {}
  @override
  void renderFrame() {}
  @override
  void dispose() {}
}

class StubPhysicsService implements PhysicsService {
  final Map<String, bool> _sleep = {};
  int _id = 0;
  @override
  Future<void> init() async {}
  @override
  void addGround({double size = 50}) {}
  @override
  String addDice({double size = 1.0, double mass = 1.0}) {
    final id = (++_id).toString();
    _sleep[id] = false;
    return id;
  }
  @override
  void randomizeDice(String id, {double xBias = 0}) {
    _sleep[id] = false;
  }
  @override
  void step(double dt) {
    _sleep.updateAll((key, value) => true);
  }
  @override
  ({Vector3 position, Quaternion rotation, bool sleeping}) stateOf(String id) =>
      (position: Vector3.zero(), rotation: Quaternion.identity(), sleeping: _sleep[id] ?? true);
  @override
  void resetBodies() {
    _sleep.updateAll((key, value) => true);
  }
  @override
  int topFace(String id) => 1;
  @override
  void dispose() {}
}

void main() {
  test('viewmodel update stops when dice sleep', () async {
    final vm = DiceViewModel(physics: StubPhysicsService(), render: FakeRenderService());
    await vm.init(DivElement());
    expect(vm.running, true);
    vm.update(0.016);
    expect(vm.running, false);
    expect(vm.result1, isNotNull);
    expect(vm.result2, isNotNull);
  });
}
