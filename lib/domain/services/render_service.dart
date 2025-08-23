import 'dart:html';
import 'package:vector_math/vector_math_64.dart';

abstract class RenderService {
  Future<void> init({required HtmlElement host});
  String addGroundMesh(double size);
  String addDiceMesh(double size, {String? textureAsset});
  void sync(String meshId, Vector3 pos, Quaternion rot);
  void renderFrame();
  void dispose();
}
