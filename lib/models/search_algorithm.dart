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
  static final List<int> _orderIndexes = [0];
  static int _levelIterations = 0;
  late final int maxIterations;

  int currentIndex = 0;

  Future<List<BaseNode>?> search(
      Future<void> Function(
              {BaseNode? node,
              bool isGoal,
              bool isKill,
              Iterable<int> nodeIdsToRemove})
          renderNode);

  static List<BaseNode> getPath(BaseNode node) {
    final List<BaseNode> path = [];
    BaseNode? current = node;
    while (current != null) {
      path.add(current);
      current = current.father;
    }
    return path.reversed.toList();
  }

  static String getPathString(BaseNode? node) {
    if (node == null) {
      return 'No path found';
    }
    final path = getPath(node);
    return path.map((e) => '(${e.x}, ${e.y})').join(' -> ');
  }

  int _manhattanDistance(int x, int y, int goalX, int goalY) {
    return (x - goalX).abs() + (y - goalY).abs();
  }

  int isLevel(BaseNode current) {
    int level = current.level + 1;
    return level;
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

  void initAlgorithm(List<BaseNode> nodes, int maxIterations) {
    setupNodeContext(nodes);
    this.maxIterations = maxIterations;
    _levelIterations += this.maxIterations;
    currentIndex = nodes.map((e) => e.index).reduce(max) + 1;
  }

  void updateNodeIndex(Iterable<int> nodes, int indexFather) {
  int index = _orderIndexes.indexOf(indexFather);

  if (index == -1) {
    _orderIndexes.addAll(nodes);
  } else {
    _orderIndexes.replaceRange(index, index + 1, nodes);
  }
}


  List<BaseNode> orderNodes(List<BaseNode> nodes) {
    List<BaseNode> orderedNodes = [];
    for (var index in _orderIndexes) {
      for (var node in nodes) {
        if (node.index == index) {
          orderedNodes.add(node);
        }
      }
    }
    return orderedNodes;
  }

  bool checkMaxIterationsLimit(BaseNode next) {
    return next.level == _levelIterations;
  }

  static void dispose() {
    _levelIterations = 0;
    _orderIndexes.clear();
    _orderIndexes.add(0);
  }
}
