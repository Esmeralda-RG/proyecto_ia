import 'dart:math';
import 'package:proyecto_ia/models/base_node.dart';

abstract class SearchAlgorithm {
  SearchAlgorithm({
    required this.board,
    required this.advanceOrders,
    required this.goalX,
    required this.goalY,
  });

  final List<List<int>> board;
  final List<List<int>> advanceOrders;
  final int goalX, goalY;
  final Map<int, int> expandedNodes = {};
  int currentIndex = 0;

  Future<List<BaseNode>?> search(
      Future<void> Function(BaseNode, [bool]) renderNode, int maxIterations);

  List<BaseNode> getPath(BaseNode node) {
    final List<BaseNode> path = [];
    BaseNode? current = node;
    while (current != null) {
      path.add(current);
      current = current.father;
    }
    return path.reversed.toList();
  }

  String getPathString(BaseNode? node) {
    if (node == null) {
      return 'No path found';
    }
    final path = getPath(node);
    return path.map((e) => '(${e.x}, ${e.y})').join(' -> ');
  }

  int _manhattanDistance(int x, int y, int goalX, int goalY) {
    return (x - goalX).abs() + (y - goalY).abs();
  }

  bool isValid(int x, int y) {
    return x >= 0 &&
        x < board.length &&
        y >= 0 &&
        y < board[0].length &&
        board[x][y] != 1;
  }

  int getHeuristic(int x, int y) {
    return _manhattanDistance(x, y, goalX, goalY);
  }

  int getCost(BaseNode node) {
    return node.cost + 1;
  }

  void setupNodeContext(List<BaseNode> nodes);

  void initAlgorithm(List<BaseNode> nodes) {
    setupNodeContext(nodes);
    currentIndex = nodes.map((e) => e.index).reduce(max) + 1;
    for (var node in nodes) {
      expandedNodes[node.index] = 0;
    }
  }

  void setNodeIterations(BaseNode node) {
    if (expandedNodes[node.father!.index] != null) {
      expandedNodes[node.index] = expandedNodes[node.father!.index]! + 1;
    }
  }

  bool hasReachedMaxIterations(
      BaseNode current, BaseNode next, int maxIterations,
      [bool hasComplete = false]) {
    if (expandedNodes[next.index] == expandedNodes[current.index] &&
        hasComplete) {
      return false;
    }

    if (expandedNodes[next.index] == maxIterations) {
      return true;
    }

    if (!hasComplete && expandedNodes.containsValue(maxIterations)) {
      return true;
    }

    return false;
  }
}
