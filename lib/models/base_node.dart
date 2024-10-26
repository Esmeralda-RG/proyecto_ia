class BaseNode implements Comparable<BaseNode> {
  final int x, y;
  final int cost;
  final int heuristic;
  final int index;
  BaseNode? father;

  BaseNode(this.x, this.y, this.index, this.cost, this.heuristic,
      [this.father]);

  @override
  String toString() => '($x, $y)';

  @override
  int compareTo(BaseNode other) {
    throw UnimplementedError();
  }
}
