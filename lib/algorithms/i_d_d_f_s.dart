import 'dart:collection' show Queue;
import 'package:proyecto_ia/models/base_node.dart';
import 'package:proyecto_ia/models/search_algorithm.dart';

class IterativeDeepeningSearch extends SearchAlgorithm {
  IterativeDeepeningSearch({
    required super.board,
    required super.advanceOrders,
    required super.goalX,
    required super.goalY,
  });

  final Queue<BaseNode> _queue = Queue<BaseNode>();
  final List<BaseNode> _temporaryNodes = [];

  Future<void> resetRenderedNodes(renderNode) async {
    await renderNode(resetTree: true);
  }

  final List<BaseNode> _rootNodes = [];

  @override
  Future<List<BaseNode>?> search(renderNode) async {
    int depthLimit = 1;

    while (depthLimit < maxIterations) {
      final initialNode = _rootNodes.first;
      _queue.addAll(_rootNodes);
      await renderNode(node: initialNode);

      while (_queue.isNotEmpty) {
        final current = _queue.removeLast();

        if (current.level <= depthLimit || current.level % 3 == 0) {
          await renderNode(node: current);
        }

        if (current.x == goalX && current.y == goalY) {
          await renderNode(node: current, isGoal: true);
          return [];
        }

        bool isKill = true;
        _temporaryNodes.clear();

        if (current.level < depthLimit) {
          final List<BaseNode> neighbors = [];
          for (var advance in advanceOrders) {
            int newX = current.x + advance[0];
            int newY = current.y + advance[1];
            bool isGrandparent =
                current.father?.x == newX && current.father?.y == newY;

            if (isValid(newX, newY) && !isGrandparent) {
              isKill = false;
              final neighbor = BaseNode(
                newX,
                newY,
                currentIndex++,
                getCost(current),
                getHeuristic(newX, newY),
                current.level + 1,
                current,
              );
              neighbors.add(neighbor);
              await renderNode(node: neighbor);
              _temporaryNodes.add(neighbor);
            }
          }

          _queue.addAll(neighbors.reversed);
        }

        if (isKill) {
          await renderNode(node: current, isKill: true);
        }
      }

      depthLimit++;
    }

    return null;
  }

  @override
  void setupNodeContext(List<BaseNode> nodes) {
    _queue.clear();
    for (var node in nodes.reversed) {
      _rootNodes.add(node);
    }
  }
}
