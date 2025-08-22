class RollResult {
  final int left;
  final int right;
  int get sum => left + right;
  const RollResult(this.left, this.right);
}
