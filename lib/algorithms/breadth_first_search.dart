import 'dart:collection' show Queue;
import 'dart:math';
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
  final Map<int, List<BaseNode>> _nodesByLevel = {};
  final List<BaseNode> _temporaryNodes = [];

  @override
  Future<List<BaseNode>?> search(renderNode) async {
    final initialNode = _queue.first;
    await renderNode(node: initialNode);
    while (_queue.isNotEmpty) {
      final current = _queue.removeFirst();

      if (current.x == goalX && current.y == goalY) {
        await renderNode(node: current, isGoal: true);
        return [];
      }
      bool isKill = true;
      _temporaryNodes.clear();
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
      orderNodesByLevel(orderNodes(_queue.toList()));

      if (checkMaxIterationsLimit(
          _temporaryNodes.firstOrNull ?? _queue.first)) {
        return orderNodes(_queue.toList());
      }
    }

    return null;
  }

  @override
  void setupNodeContext(List<BaseNode> nodes) {
    orderNodesByLevel(nodes);
  }

  void orderNodesByLevel(List<BaseNode> nodes) {
    _queue.clear();
    _nodesByLevel.clear();

    final int maxLevel = nodes.map((n) => n.level).reduce(max);
    final int minLevel = nodes.map((n) => n.level).reduce(min);

    for (var node in nodes) {
      if (_nodesByLevel[node.level] == null) {
        _nodesByLevel[node.level] = [];
      }
      _nodesByLevel[node.level]!.add(node);
    }

    for (var i = minLevel; i <= maxLevel; i++) {
      if (_nodesByLevel[i] != null) {
        _queue.addAll(_nodesByLevel[i]!);
      }
    }
  }
}
