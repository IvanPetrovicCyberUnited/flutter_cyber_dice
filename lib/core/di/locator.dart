import '../../domain/services/physics_service.dart';
import '../../domain/services/render_service.dart';
import '../../data/physics/physics_cannon_dart.dart';
import '../../data/render/three_render_service.dart';

class Locator {
  static PhysicsService physics() => CannonDartPhysicsService();
  static RenderService render() => ThreeRenderService();
}
