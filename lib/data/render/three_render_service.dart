import 'dart:html';
import 'package:flutter_gl/flutter_gl.dart';
import 'package:three_dart/three_dart.dart' as three;
import 'package:vector_math/vector_math_64.dart';
import '../../domain/services/render_service.dart';

class ThreeRenderService implements RenderService {
  late FlutterGlPlugin _gl;
  late three.Scene _scene;
  late three.PerspectiveCamera _camera;
  late three.WebGLRenderer _renderer;
  final Map<String, three.Object3D> _meshes = {};
  int _id = 0;

  @override
  Future<void> init({required HtmlElement host}) async {
    _gl = FlutterGlPlugin();
    await _gl.initialize(options: {
      'width': host.clientWidth,
      'height': host.clientHeight,
      'canvas': host,
    });
    _scene = three.Scene();
    _camera = three.PerspectiveCamera(
        55, host.clientWidth / host.clientHeight, 0.1, 1000)
      ..position.setValues(0, 6, 10);
    final hemi = three.HemisphereLight(three.Color(0xffffff), three.Color(0x444444), 0.6);
    _scene.add(hemi);
    final dir = three.DirectionalLight(three.Color(0xffffff), 0.8)
      ..position.setValues(5, 10, 7);
    _scene.add(dir);
    _renderer = three.WebGLRenderer({'canvas': _gl.element});
    _renderer.setSize(host.clientWidth, host.clientHeight);
  }

  @override
  String addGroundMesh(double size) {
    final geo = three.PlaneGeometry(size, size);
    final mat = three.MeshStandardMaterial({'color': 0x888888});
    final mesh = three.Mesh(geo, mat)..rotation.x = -three.Math.PI / 2;
    _scene.add(mesh);
    final id = (++_id).toString();
    _meshes[id] = mesh;
    return id;
  }

  @override
  String addDiceMesh(double size, {String? textureAsset}) {
    final geo = three.BoxGeometry(size, size, size);
    late three.MeshStandardMaterial mat;
    if (textureAsset != null) {
      final tex = three.TextureLoader().load(textureAsset);
      mat = three.MeshStandardMaterial({'map': tex});
    } else {
      mat = three.MeshStandardMaterial({'color': 0xffffff});
    }
    final mesh = three.Mesh(geo, mat);
    _scene.add(mesh);
    final id = (++_id).toString();
    _meshes[id] = mesh;
    return id;
  }

  @override
  void sync(String meshId, Vector3 pos, Quaternion rot) {
    final mesh = _meshes[meshId];
    mesh?.position.setValues(pos.x, pos.y, pos.z);
    mesh?.quaternion.set(rot.x, rot.y, rot.z, rot.w);
  }

  @override
  void renderFrame() {
    _renderer.render(_scene, _camera);
  }

  @override
  void dispose() {
    _meshes.clear();
    _gl.dispose();
  }
}
