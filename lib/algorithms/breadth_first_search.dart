import 'dart:collection' show Queue;
import 'package:proyecto_ia/models/base_node.dart';
import 'package:proyecto_ia/models/search_algorithm.dart';

class BreadthFirstSearch extends SearchAlgorithm {
  BreadthFirstSearch({
    required super.board,
    required super.advanceOrders,
    required super.goalX,
    required super.goalY,
  });

  final Queue<BaseNode> _queue = Queue<BaseNode>();

  @override
  Future<List<BaseNode>?> search(
      Future<void> Function(BaseNode, {bool isGoal, bool isKill}) renderNode,
      int maxIterations) async {
    final initialNode = _queue.first;

    await renderNode(initialNode);
    while (_queue.isNotEmpty) {
      final current = _queue.removeFirst();

      if (current.x == goalX && current.y == goalY) {
        await renderNode(current, isGoal: true);
        return [];
      }
      bool isKill = true;
      for (var i = 0; i < advanceOrders.length; i++) {
        var advance = advanceOrders[i];
        int newX = current.x + advance[0];
        int newY = current.y + advance[1];
        final level = isLevel(current);
        bool isGrandparent =
            current.father?.x == newX && current.father?.y == newY;

        if (isValid(newX, newY) && !isGrandparent) {
          isKill = false;
          final neighbor = BaseNode(newX, newY, currentIndex++,
              getCost(current), getHeuristic(newX, newY), level, current);
          _queue.add(neighbor);
          setNodeIterations(neighbor);
          await renderNode(neighbor);
        }
      }

      if (isKill) {
        await renderNode(current, isKill: true);
      }

      if (hasReachedMaxIterations(current, _queue.first, maxIterations, true)) {
        return _queue.toList();
      }
    }

    return null;
  }

  @override
  void setupNodeContext(List<BaseNode> nodes) {
    _queue.clear();
    for (var node in nodes) {
      _queue.add(node);
    }
  }
}
