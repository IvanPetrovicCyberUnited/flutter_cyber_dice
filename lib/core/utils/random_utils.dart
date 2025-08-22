import 'dart:math';
import 'package:vector_math/vector_math_64.dart';
final _rnd = Random();

double rnd(double min, double max) => min + _rnd.nextDouble() * (max - min);

Vector3 rndVec(double s) => Vector3(rnd(-s, s), rnd(-s, s), rnd(-s, s));

Quaternion rndQuat() {
  final u1 = _rnd.nextDouble();
  final u2 = _rnd.nextDouble() * 2 * pi;
  final u3 = _rnd.nextDouble() * 2 * pi;
  final s1 = sqrt(1 - u1), s2 = sqrt(u1);
  return Quaternion(s1 * sin(u2), s1 * cos(u2), s2 * sin(u3), s2 * cos(u3));
}
