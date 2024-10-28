import 'package:collection/collection.dart' show PriorityQueue;
import 'package:proyecto_ia/models/base_node.dart';
import 'package:proyecto_ia/models/search_algorithm.dart';

class Node extends BaseNode {
  Node(super.x, super.y, super.index, super.cost, super.heuristic,
      [super.father]);

  @override
  int compareTo(BaseNode other) {
    int heuristicComparison = heuristic.compareTo(other.heuristic);
    if (heuristicComparison == 0) {
      return index.compareTo(other.index);
    }
    return heuristicComparison;
  }

  @override
  String toString() => '($x, $y) -> Heuristic: $heuristic';
}

class GreedySearch extends SearchAlgorithm {
  final PriorityQueue<Node> _queue = PriorityQueue<Node>();

  GreedySearch({
    required super.board,
    required super.advanceOrders,
    required super.goalX,
    required super.goalY,
  });

  final List<Node> _temporaryNodes = [];

  @override
  Future<List<BaseNode>?> search(
      Future<void> Function(Node, [bool]) renderNode, int maxIterations) async {
    final initialNode = _queue.first;
    await renderNode(initialNode);
    while (_queue.isNotEmpty) {
      Node current = _queue.removeFirst();

      if (current.x == goalX && current.y == goalY) {
        await renderNode(current, true);
        return [];
      }

      for (var advance in advanceOrders) {
        int newX = current.x + advance[0];
        int newY = current.y + advance[1];
        if (current.father != null &&
            newX == current.father!.x &&
            newY == current.father!.y) {
          continue;
        }
        if (isValid(newX, newY)) {
          int heuristic = getHeuristic(newX, newY);
          int cost = getCost(current);
          Node neighbor =
              Node(newX, newY, currentIndex++, cost, heuristic, current);
          _queue.add(neighbor);
          setNodeIterations(neighbor);
          _temporaryNodes.add(neighbor);
          await renderNode(neighbor);
        }
      }

       _temporaryNodes.removeWhere((element) => element.index == current.index);
      if (hasReachedMaxIterations(current, _queue.first, maxIterations)) {
        return _temporaryNodes;
      }
    }
    return null;
  }

  @override
  void setupNodeContext(List<BaseNode> nodes) {
    _queue.clear();
    for (var context in nodes) {
     final node =  Node(
          context.x, context.y, context.index, context.cost, context.heuristic, context.father);
      _queue.add(node);
      _temporaryNodes.add(node);
    }
  }
}
