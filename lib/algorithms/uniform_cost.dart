import 'package:collection/collection.dart' show PriorityQueue;
import 'package:proyecto_ia/models/base_node.dart';
import 'package:proyecto_ia/models/search_algorithm.dart';

class Node extends BaseNode {
  Node(super.x, super.y, super.index, super.cost, super.heuristic,
      [super.father]);

  @override
  int compareTo(BaseNode other) {
    int costComparison = cost.compareTo(other.cost);
    if (costComparison == 0) {
      return index.compareTo(other.index);
    }
    return costComparison;
  }

  @override
  String toString() => '($x, $y) -> Cost: $cost';
}

class UniformCost extends SearchAlgorithm {
  UniformCost({
    required super.board,
    required super.advanceOrders,
    required super.goalX,
    required super.goalY,
  });

  final PriorityQueue<Node> _queue = PriorityQueue<Node>();

  @override
  void initContext(List<BaseNode> nodes) {
    _queue.clear();
    for (var node in nodes) {
      _queue.add(Node(
          node.x, node.y, node.index, node.cost, node.heuristic, node.father));
      setCurrentIndex(nodes);
    }
  }

  final Map<BaseNode, int> _expandedNodes = {};

  @override
  Future<List<BaseNode>?> search(
      Future<void> Function(BaseNode node, [bool isGoal]) renderNode,
      int maxIterations) async {
    final initialNode = _queue.first;
    _expandedNodes[initialNode] = 1;
    await renderNode(initialNode);
    while (_queue.isNotEmpty) {
      Node current = _queue.removeFirst();
      if (current.x == goalX && current.y == goalY) {
        await renderNode(current, true);
        return [];
      }

      if (current.father != null && _expandedNodes[current.father] != null) {
        _expandedNodes[current] = _expandedNodes[current.father]! + 1;
      }

      if (_expandedNodes[current.father] == maxIterations) {
        return [current, ..._queue.toList()];
      }

      for (var advance in advanceOrders) {
        int newX = current.x + advance[0];
        int newY = current.y + advance[1];

        bool isGrandparent =
            current.father?.x == newX && current.father?.y == newY;

        if (isValid(newX, newY) && !isGrandparent) {
          final neighbor = Node(newX, newY, currentIndex++, getCost(current),
              getHeuristic(newX, newY), current);
          _queue.add(neighbor);
          await renderNode(neighbor);
        }
      }
    }

    return null;
  }
}
