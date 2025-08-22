class FpsCounter {
  int _frames = 0;
  double _accum = 0;
  double fps = 0;
  void tick(double dt) {
    _frames++;
    _accum += dt;
    if (_accum >= 1.0) {
      fps = _frames / _accum;
      _frames = 0;
      _accum = 0;
    }
  }
}
