import 'package:collection/collection.dart' show PriorityQueue;
import 'package:proyecto_ia/algorithms/search_algorithm.dart';

class Node implements Comparable<Node> {
  final int x, y;
  final int cost;
  final Node? father;
  final int level;
  final int orderInLevel;

  Node(this.x, this.y, this.cost, this.level, this.orderInLevel, [this.father]);

  @override
  int compareTo(Node other) {
    int costComparison = cost.compareTo(other.cost);
    if (costComparison == 0) {
      if (level != other.level && orderInLevel == other.orderInLevel) {
        return level.compareTo(other.level);
      } else {
        return orderInLevel.compareTo(other.orderInLevel);
      }
    }
    return costComparison;
  }

  @override
  String toString() =>
      '($x, $y) -> Costo: $cost, Nivel: $level, Orden: $orderInLevel';
}

class GreedySearch implements SearchAlgorithm<Node> {
  final List<List<int>> board;
  final List<List<int>> advanceOrders;
  final int startX, startY, goalX, goalY;
  int orderCounter = 0;
  Map<int, int> levelOrderCounter = {};

  GreedySearch(
      {required this.board,
      required this.advanceOrders,
      required this.startX,
      required this.startY,
      required this.goalX,
      required this.goalY});

  @override
  Future<Node?> search(Future<void> Function(Node, [bool]) renderNode) async {
    PriorityQueue<Node> queue = PriorityQueue<Node>();
    Set<String> visited = {};
    Node initialNode = Node(startX, startY, 0, 0, orderCounter++);
    queue.add(initialNode);
    await renderNode(initialNode);

    while (queue.isNotEmpty) {
      Node current = queue.removeFirst();
      if (current.x == goalX && current.y == goalY) {
        await renderNode(current, true);
        return current;
      }
      visited.add('${current.x},${current.y}');

      for (var advance in advanceOrders) {
        int newX = current.x + advance[0];
        int newY = current.y + advance[1];
        if (current.father != null &&
            newX == current.father!.x &&
            newY == current.father!.y) {
          continue;
        }
        if (isValid(newX, newY, board)) {
          int heuristic = manhattanDistance(newX, newY, goalX, goalY);
          int level = current.level + 1;
          int orderInLevel = levelOrderCounter
              .update(level, (value) => value + 1, ifAbsent: () => 0);
          Node neighbor =
              Node(newX, newY, heuristic, level, orderInLevel, current);
          queue.add(neighbor);
          await renderNode(neighbor);
        }
      }
    }
    return null;
  }

  int manhattanDistance(int x, int y, int goalX, int goalY) {
    return (x - goalX).abs() + (y - goalY).abs();
  }

  bool isValid(int x, int y, List<List<int>> board) {
    return x >= 0 &&
        x < board.length &&
        y >= 0 &&
        y < board[0].length &&
        board[x][y] != 1;
  }

  String getPath(Node? node) {
    if (node == null) {
      return 'No se encontró un camino.';
    }
    List<Node> path = [];
    while (node != null) {
      path.add(node);
      node = node.father;
    }
    path = path.reversed.toList();
    return 'Camino encontrado: ${path.join(' -> ')}';
  }
}
