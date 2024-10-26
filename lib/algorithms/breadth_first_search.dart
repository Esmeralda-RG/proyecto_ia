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
  final Map<BaseNode, int> _expandedNodes = {};

  @override
  Future<List<BaseNode>?> search(
      Future<void> Function(BaseNode, [bool]) renderNode,
      int maxIterations) async {
    final initialNode = _queue.first;
    _expandedNodes[initialNode] = 1;
    await renderNode(initialNode);
    while (_queue.isNotEmpty) {
      final current = _queue.removeFirst();

      if (current.x == goalX && current.y == goalY) {
        await renderNode(current, true);
        return [];
      }
      if (current.father != null && _expandedNodes[current.father] != null) {
        _expandedNodes[current] = _expandedNodes[current.father]! + 1;
      }

      if (_expandedNodes[current.father] == maxIterations) {
        return [current, ..._queue];
      }

      for (var i = 0; i < advanceOrders.length; i++) {
        var advance = advanceOrders[i];
        int newX = current.x + advance[0];
        int newY = current.y + advance[1];
        bool isGrandparent =
            current.father?.x == newX && current.father?.y == newY;

        if (isValid(newX, newY) && !isGrandparent) {
          final neighbor = BaseNode(newX, newY, currentIndex++,
              getCost(current), getHeuristic(newX, newY), current);
          _queue.add(neighbor);
          await renderNode(neighbor);
        }
      }
    }

    return null;
  }

  @override
  void initContext(List<BaseNode> nodes) {
    _queue.clear();
    for (var node in nodes) {
      _queue.add(node);
    }
    setCurrentIndex(nodes);
  }
}
