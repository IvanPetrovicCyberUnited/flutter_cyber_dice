import 'package:vector_math/vector_math_64.dart';

abstract class PhysicsService {
  Future<void> init();
  void addGround({double size = 50});
  String addDice({double size = 1.0, double mass = 1.0});
  void randomizeDice(String id, {double xBias = 0});
  void step(double dt);
  ({Vector3 position, Quaternion rotation, bool sleeping}) stateOf(String id);
  void resetBodies();
  int topFace(String id);
  void dispose();
}
