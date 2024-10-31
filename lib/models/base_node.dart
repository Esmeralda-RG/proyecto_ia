class BaseNode {
  final int x, y;
  final int cost;
  final int heuristic;
  final int index;
  final int level;
  BaseNode? father;

  BaseNode(this.x, this.y, this.index, this.cost, this.heuristic, this.level,
      [this.father]);

  @override
  String toString() => '($x, $y), level: $level';
}
