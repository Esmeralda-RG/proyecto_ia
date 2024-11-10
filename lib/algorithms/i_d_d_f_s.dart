import 'package:proyecto_ia/models/base_node.dart';
import 'package:proyecto_ia/models/search_algorithm.dart';

class IterativeDeepeningSearch extends SearchAlgorithm {
  IterativeDeepeningSearch({
    required super.board,
    required super.advanceOrders,
    required super.goalX,
    required super.goalY,
  });

  final List<BaseNode> _stack = [];
  final List<BaseNode> _temporaryNodes = [];
  final List<BaseNode> _rootNodes = [];
  final List<int> _nodesIndexRemoved = [];

  @override
  Future<List<BaseNode>?> search(renderNode) async {
    final initialNode = _rootNodes.first;
    await renderNode(node: initialNode);
    int depth = 0;
    int maxDepth = 1;
    int lastLevel = -1;

    while (_stack.isNotEmpty) {
      final current = _stack.removeLast();

      if (current.x == goalX && current.y == goalY) {
        await renderNode(node: current, isGoal: true);
        return [];
      }

      if (depth == maxDepth && current.level >= lastLevel) {
        if (_stack.isEmpty) {
          depth = 0;
          maxDepth++;
          _stack.addAll(_rootNodes);
          await renderNode(nodeIdsToRemove: _nodesIndexRemoved);
          _nodesIndexRemoved.clear();
        }
        continue;
      }

      final List<BaseNode> neighbors = [];
      bool isKill = true;
      _temporaryNodes.clear();
      for (var advance in advanceOrders) {
        int newX = current.x + advance[0];
        int newY = current.y + advance[1];
        final level = isLevel(current);
        bool isGrandparent =
            current.father?.x == newX && current.father?.y == newY;

        if (isValid(newX, newY) && !isGrandparent) {
          isKill = false;
          final neighbor = BaseNode(newX, newY, currentIndex++,
              getCost(current), getHeuristic(newX, newY), level, current);
          neighbors.add(neighbor);
          await renderNode(node: neighbor);
          _temporaryNodes.add(neighbor);
          _nodesIndexRemoved.add(neighbor.index);
        }
      }

      if (neighbors.isNotEmpty) {
        if (depth < maxDepth) {
          depth++;
          lastLevel = neighbors.first.level;
        }
      }

      _stack.addAll(neighbors.reversed);

      if (isKill) {
        await renderNode(node: current, isKill: true);
      }
      if (_stack.isEmpty) {
        return null;
      }
      updateNodeIndex(_temporaryNodes.map((n) => n.index), current.index);

      if (checkMaxIterationsLimit(
          _temporaryNodes.firstOrNull ?? _stack.first)) {
        return orderNodes(_stack.reversed.toList());
      }
    }
    return null;
  }

  @override
  void setupNodeContext(List<BaseNode> nodes) {
    _stack.clear();
    for (var node in nodes.reversed) {
      _stack.add(node);
      _rootNodes.add(node);
    }
  }
}
