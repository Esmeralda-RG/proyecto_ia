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

  // Función para reiniciar la visualización del árbol
  Future<void> resetRenderedNodes(renderNode) async {
    await renderNode(node: null, resetTree: true);
  }

  @override
  Future<List<BaseNode>?> search(renderNode) async {
    int depthLimit = 1;
    bool found = false;

    final startX = board[0][0];
    final startY = board[0][1];

    while (!found) {
      await resetRenderedNodes(renderNode);

      _queue.clear();
      _temporaryNodes.clear();
      _queue.add(BaseNode(
        startX,
        startY,
        0,
        0,
        getHeuristic(startX, startY),
        0,
        null,
      ));

      int iterationCount = 0;
      const maxTotalIterations = 5000;

      while (_queue.isNotEmpty && iterationCount < maxTotalIterations) {
        final current = _queue.removeLast();
        iterationCount++;

        if (current.level <= depthLimit || current.level % 3 == 0) {
          await renderNode(node: current);
        }

        if (current.x == goalX && current.y == goalY) {
          await renderNode(node: current, isGoal: true);
          found = true;
          return [];
        }

        bool isKill = true;
        _temporaryNodes.clear();

        // Expansión de nodos en el sentido de las manecillas del reloj
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

          // Agregar vecinos en orden inverso para mantener el sentido de las manecillas del reloj
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
      _queue.add(node);
    }
  }
}
