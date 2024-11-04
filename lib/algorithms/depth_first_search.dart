import 'package:proyecto_ia/models/base_node.dart';
import 'package:proyecto_ia/models/search_algorithm.dart';

class DepthFirstSearch extends SearchAlgorithm {
  DepthFirstSearch({
    required super.board,
    required super.advanceOrders,
    required super.goalX,
    required super.goalY,
  });

  final List<BaseNode> _stack = [];
  final List<BaseNode> _temporaryNodes = [];

  @override
  Future<List<BaseNode>?> search(renderNode) async {
    final initialNode = _stack.first;

    await renderNode(node: initialNode);
    while (_stack.isNotEmpty) {
      final current = _stack.removeLast();

      if (current.x == goalX && current.y == goalY) {
        await renderNode(node: current, isGoal: true);
        return [];
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
        }
      }
      _stack.addAll(neighbors.reversed);

      if (isKill) {
        await renderNode(node: current, isKill: true);
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
    }
  }
}
