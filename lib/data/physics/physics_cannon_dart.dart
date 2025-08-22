import 'package:vector_math/vector_math_64.dart';
import '../../core/utils/random_utils.dart';
import '../../domain/services/physics_service.dart';

class _Body {
  Vector3 position;
  Quaternion rotation;
  Vector3 velocity;
  Vector3 angularVelocity;
  bool sleeping;
  _Body({required this.position, required this.rotation})
      : velocity = Vector3.zero(),
        angularVelocity = Vector3.zero(),
        sleeping = false;
}

class CannonDartPhysicsService implements PhysicsService {
  final Map<String, _Body> _bodies = {};
  int _id = 0;

  @override
  Future<void> init() async {}

  @override
  void addGround({double size = 50}) {}

  @override
  String addDice({double size = 1.0, double mass = 1.0}) {
    final id = (++_id).toString();
    _bodies[id] = _Body(position: Vector3(0, 1, 0), rotation: Quaternion.identity());
    return id;
  }

  @override
  void randomizeDice(String id, {double xBias = 0}) {
    final b = _bodies[id]!;
    b.position = Vector3(xBias + rnd(-1, 1), rnd(6, 8), rnd(-1, 1));
    b.velocity = rndVec(5)..y = 0;
    b.velocity.y = rnd(3, 8);
    b.angularVelocity = rndVec(10);
    b.rotation = rndQuat();
    b.sleeping = false;
  }

  static const _g = -9.81;
  static const _restitution = 0.3;
  static const _friction = 0.98;

  @override
  void step(double dt) {
    for (final b in _bodies.values) {
      if (b.sleeping) continue;
      b.velocity.y += _g * dt;
      b.position += b.velocity * dt;
      final ang = b.angularVelocity * dt;
      if (ang.length2 > 0) {
        final q = Quaternion.axisAngle(ang.normalized(), ang.length);
        b.rotation = (b.rotation * q).normalized();
      }
      if (b.position.y <= 0.5) {
        b.position.y = 0.5;
        if (b.velocity.y < 0) b.velocity.y = -b.velocity.y * _restitution;
        b.velocity.x *= _friction;
        b.velocity.z *= _friction;
        if (b.velocity.length < 0.1 && b.angularVelocity.length < 0.1) {
          b.velocity.setZero();
          b.angularVelocity.setZero();
          b.sleeping = true;
        }
      }
    }
  }

  @override
  ({Vector3 position, Quaternion rotation, bool sleeping}) stateOf(String id) {
    final b = _bodies[id]!;
    return (position: b.position.clone(), rotation: b.rotation.clone(), sleeping: b.sleeping);
  }

  @override
  void resetBodies() {
    for (final b in _bodies.values) {
      b.position = Vector3(0, 1, 0);
      b.velocity.setZero();
      b.angularVelocity.setZero();
      b.rotation = Quaternion.identity();
      b.sleeping = true;
    }
  }

  @override
  int topFace(String id) {
    final b = _bodies[id]!;
    final faces = {
      1: Vector3(0, 1, 0),
      6: Vector3(0, -1, 0),
      3: Vector3(1, 0, 0),
      4: Vector3(-1, 0, 0),
      2: Vector3(0, 0, 1),
      5: Vector3(0, 0, -1),
    };
    double best = -double.infinity;
    int top = 1;
    final rot = Matrix3.identity();
    b.rotation.toRotationMatrix(rot);
    final up = Vector3(0, 1, 0);
    faces.forEach((num, normal) {
      final world = rot.transformed(normal);
      final d = world.dot(up);
      if (d > best) {
        best = d;
        top = num;
      }
    });
    return top;
  }
  void setRotation(String id, Quaternion rot) {
    final b = _bodies[id];
    if (b != null) {
      b.rotation = rot;
      b.sleeping = true;
    }
  }


  @override
  void dispose() {
    _bodies.clear();
  }
}
