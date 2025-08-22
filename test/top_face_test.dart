import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:flutter_dice_3d/data/physics/physics_cannon_dart.dart';

void main() {
  test('topFace detects correct face', () async {
    final phys = CannonDartPhysicsService();
    await phys.init();
    final id = phys.addDice();
    expect(phys.topFace(id), 1);
    phys.setRotation(id, Quaternion.axisAngle(Vector3(1, 0, 0), pi));
    expect(phys.topFace(id), 6);
    phys.setRotation(id, Quaternion.axisAngle(Vector3(0, 0, 1), -pi / 2));
    expect(phys.topFace(id), 3);
  });
}
