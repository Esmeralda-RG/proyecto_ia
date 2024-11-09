import 'package:collection/collection.dart' show PriorityQueue;
import 'package:proyecto_ia/models/base_node.dart';
import 'package:proyecto_ia/models/search_algorithm.dart';

class Node extends BaseNode implements Comparable<Node> {
  Node(super.x, super.y, super.index, super.cost, super.heuristic, super.level,
      this.order,
      [super.father]);
  final int order;
  @override
  int compareTo(Node other) {
    int heuristicComparison = heuristic.compareTo(other.heuristic);
    if (heuristicComparison == 0) {
      return order.compareTo(other.order);
    }
    return heuristicComparison;
  }

  @override
  String toString() => '($x, $y) -> Heuristic: $heuristic, level: $level';
}

class GreedySearch extends SearchAlgorithm {
  final PriorityQueue<Node> _queue = PriorityQueue<Node>();
  final List<BaseNode> _temporaryNodes = [];

  GreedySearch({
    required super.board,
    required super.advanceOrders,
    required super.goalX,
    required super.goalY,
  });

  @override
  Future<List<BaseNode>?> search(renderNode) async {
    final initialNode = _queue.first;
    await renderNode(node: initialNode);
    while (_queue.isNotEmpty) {
      Node current = _queue.removeFirst();

      if (current.x == goalX && current.y == goalY) {
        await renderNode(node: current, isGoal: true);
        return [];
      }
      bool isKill = true;
      _temporaryNodes.clear();
      for (var advance in advanceOrders) {
        int newX = current.x + advance[0];
        int newY = current.y + advance[1];
        final level = isLevel(current);

        if (current.father != null &&
            newX == current.father!.x &&
            newY == current.father!.y) {
          continue;
        }
        if (isValid(newX, newY)) {
          isKill = false;
          int order = current.order + 1;
          Node neighbor = Node(newX, newY, currentIndex++, getCost(current),
              getHeuristic(newX, newY), level, order, current);
          _queue.add(neighbor);
          await renderNode(node: neighbor);
          _temporaryNodes.add(neighbor);
        }
      }

      if (isKill) {
        await renderNode(node: current, isKill: true);
      }
      if (_queue.isEmpty) {
        return null;
      }
      updateNodeIndex(_temporaryNodes.map((n) => n.index), current.index);

      if (checkMaxIterationsLimit(
          _temporaryNodes.firstOrNull ?? _queue.first)) {
        return orderNodes(_queue.toList());
      }
    }
    return null;
  }

  @override
  void setupNodeContext(List<BaseNode> nodes) {
    _queue.clear();
    for (var i = 0; i < nodes.length; i++) {
      final node = Node(nodes[i].x, nodes[i].y, nodes[i].index, nodes[i].cost,
          nodes[i].heuristic, nodes[i].level, i, nodes[i].father);
      _queue.add(node);
    }
  }
}
