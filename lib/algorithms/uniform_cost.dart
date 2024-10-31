import 'package:collection/collection.dart' show PriorityQueue;
import 'package:proyecto_ia/models/base_node.dart';
import 'package:proyecto_ia/models/search_algorithm.dart';

class Node extends BaseNode {
  Node(super.x, super.y, super.index, super.cost, super.heuristic, super.level,
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
  String toString() => '($x, $y) -> Cost: $cost, Level: $level';
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
  Future<List<BaseNode>?> search(
      Future<void> Function(BaseNode node, {bool isGoal, bool isKill})
          renderNode,
      int maxIterations) async {
    final initialNode = _queue.first;
    await renderNode(initialNode);

    while (_queue.isNotEmpty) {
      Node current = _queue.removeFirst();
      if (current.x == goalX && current.y == goalY) {
        await renderNode(current, isGoal: true);
        return [];
      }

      bool isKill = true;
      final List<BaseNode> temporaryNodes = [];
      for (var advance in advanceOrders) {
        int newX = current.x + advance[0];
        int newY = current.y + advance[1];
        final level = isLevel(current);

        bool isGrandparent =
            current.father?.x == newX && current.father?.y == newY;

        if (isValid(newX, newY) && !isGrandparent) {
          isKill = false;
          final neighbor = Node(newX, newY, currentIndex++, getCost(current),
              getHeuristic(newX, newY), level, current);
          _queue.add(neighbor);
          setNodeIterations(neighbor);
          await renderNode(neighbor);
          temporaryNodes.add(neighbor);
        }
      }

      if (isKill) {
        await renderNode(current, isKill: true);
      }

      updateNodeIndex(
          temporaryNodes.map((n) => n.index).toList(), current.index);

      if (hasReachedMaxIterations(current, _queue.first, maxIterations)) {
        return orderNodes(_queue.toList());
      }
    }

    return null;
  }

  @override
  void setupNodeContext(List<BaseNode> nodes) {
    _queue.clear();
    for (var context in nodes) {
      final node = Node(context.x, context.y, context.index, context.cost,
          context.heuristic, context.level, context.father);
      _queue.add(node);
    }
  }
}
