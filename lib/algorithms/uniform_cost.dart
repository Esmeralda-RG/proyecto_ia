import 'dart:async';

import 'package:collection/collection.dart' show PriorityQueue;
import 'package:proyecto_ia/algorithms/search_algorithm.dart';

class Node implements Comparable<Node> {
  final int x, y;
  final int cost;
  final Node? father;

  Node(this.x, this.y, this.cost, [this.father]);

  @override
  int compareTo(Node other) {
    int costComparison = cost.compareTo(other.cost);

    if (costComparison == 0) {
      int xComparison = x.compareTo(other.x);

      if (xComparison == 0) {
        return y.compareTo(other.y);
      }

      return xComparison;
    }

    return costComparison;
  }

  @override
  String toString() => '($x, $y) -> Costo: $cost';
}

class UniformCost implements SearchAlgorithm<Node> {
  final List<List<int>> board;
  final List<List<int>> advanceOrders;
  final int startX, startY, goalX, goalY;

  UniformCost(
      {required this.board,
      required this.advanceOrders,
      required this.startX,
      required this.startY,
      required this.goalX,
      required this.goalY});

  @override
  Future<Node?> search(Future<void> Function(Node) renderNode) async {
    PriorityQueue<Node> queue = PriorityQueue<Node>();
    Set<String> visited = {};

    Node initialNode = Node(startX, startY, 0);
    queue.add(initialNode);
    await renderNode(initialNode);

    while (queue.isNotEmpty) {
      Node current = queue.removeFirst();

      if (current.x == goalX && current.y == goalY) {
        await renderNode(current);
        return current;
      }

      visited.add('${current.x},${current.y}');

      for (var advance in advanceOrders) {
        int newX = current.x + advance[0];
        int newY = current.y + advance[1];
        int newCost = current.cost + 1;

        if (isValid(newX, newY, board) && !visited.contains('$newX,$newY')) {
          Node neighbor = Node(newX, newY, newCost, current);
          queue.add(neighbor);

          if (neighbor.x == goalX && neighbor.y == goalY) {
            await renderNode(neighbor);
            return neighbor;
          }

          await renderNode(neighbor);
        }
      }
    }

    return null;
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
