class BaseNode implements Comparable<BaseNode> {
  final int x, y;
  final int cost;
  final int heuristic;
  final int index;
  final int level;
  late int orderInLevel;
  BaseNode? father;

  BaseNode(this.x, this.y, this.index, this.cost, this.heuristic, this.level,
      [this.father]);

  @override
  String toString() => '($x, $y), level: $level, order: $orderInLevel';

  @override
  int compareTo(BaseNode other) {
    throw UnimplementedError();
  }
}
