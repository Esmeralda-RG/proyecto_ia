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
  static final Map<int, List<int>> nodesByFather = {};
  static Map<int, Map<int, int>> orderInLevel = {};
  int order = 0;
  int currentIndex = 0;

  Future<List<BaseNode>?> search(
      Future<void> Function(BaseNode, {bool isGoal, bool isKill}) renderNode,
      int maxIterations);

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

  int isLevel(BaseNode current) {
    int level = current.level + 1;
    return level;
  }

  void setNodesByFather(BaseNode current) {
    if (nodesByFather[current.father!.index] == null) {
      nodesByFather[current.father!.index] = [];
    }
    nodesByFather[current.father!.index]!.add(current.index);
  }

  int isOrderInLevel(BaseNode current) {
    if (orderInLevel[current.level] == null) {
      orderInLevel[current.level] = {};
    }
    setNodesByFather(current);
    orderInLevel[current.level]![current.father!.orderInLevel] =
        nodesByFather[current.father!.index]!.length;
    sortOrderInLevel();
    int order = 0;
    int childsFather = 0;

    for (var key in orderInLevel[current.level]!.keys) {
      int initial = order;
      childsFather += orderInLevel[current.level]![key]!;
      for (var i = initial; i < childsFather; i++) {
        order = i;
      }
    }
    return order;
  }

  void sortOrderInLevel() {
    final keys = orderInLevel.keys.toList();
    for (var level in keys) {
      final keyOrderFather = orderInLevel[level]!.keys.toList();
      keyOrderFather.sort();
      final Map<int, int> newOrderInLevel = {};
      for (var key in keyOrderFather) {
        newOrderInLevel[key] = orderInLevel[level]![key]!;
      }
      orderInLevel[level] = newOrderInLevel;
    }
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
