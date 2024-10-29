import 'package:proyecto_ia/models/base_node.dart';
import 'package:proyecto_ia/models/search_algorithm.dart';

class DepthLimitedSearch extends SearchAlgorithm {
  //final int depthLimit;

  DepthLimitedSearch({
    required super.board,
    required super.advanceOrders,
    required super.goalX,
    required super.goalY,
  });

 /*required this.depthLimit,*/

  final List<BaseNode> _stack = [];

  @override
  Future<List<BaseNode>?> search(
      Future<void> Function(BaseNode, [bool]) renderNode,
      int maxIterations) async {
    final initialNode = _stack.last;

    await renderNode(initialNode);
    while (_stack.isNotEmpty) {
      final current = _stack.removeLast();

      // verifica si el nodo actual es la meta
      if (current.x == goalX && current.y == goalY) {
        await renderNode(current, true);
        return [];
      }

      // verifica si la profundidad del nodo actual excede el limite y omite sus vecinos
      /*if (_getDepth(current) >= depthLimit) {
        continue;
      }*/

      final List<BaseNode> neighbors = [];
      for (var advance in advanceOrders) {
        int newX = current.x + advance[0];
        int newY = current.y + advance[1];
        final level = isLevel(current);
        bool isGrandparent =
            current.father?.x == newX && current.father?.y == newY;

        if (isValid(newX, newY) && !isGrandparent) {
          final neighbor = BaseNode(newX, newY, currentIndex++,
              getCost(current), getHeuristic(newX, newY), level, current);
          neighbors.add(neighbor);
          setNodeIterations(neighbor);
          await renderNode(neighbor);
        }
      }
      _stack.addAll(neighbors.reversed);

      if (hasReachedMaxIterations(current, _stack.isNotEmpty ? _stack.last : current, maxIterations)) {
        return _stack;
      }
    }
    return null;
  }

  @override
  void setupNodeContext(List<BaseNode> nodes) {
    _stack.clear();
    for (var node in nodes.reversed) {
      _stack.add(node);
    }
  }

  // calcuña la profundidad del nodo hasta la raiz
  /*int _getDepth(BaseNode node) {
    int depth = 0;
    BaseNode? current = node;
    while (current?.father != null) {
      depth++;
      current = current?.father;
    }
    return depth;
  }*/
}
