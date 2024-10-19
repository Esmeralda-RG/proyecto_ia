import 'dart:async';
import 'package:proyecto_ia/algorithms/search_algorithm.dart';

class Node {
  final int x, y;
  final Node? father;
  final int index;

  Node(this.x, this.y, this.index, [this.father]);

  @override
  String toString() => '($x, $y)';
}

class DepthFirstSearch implements SearchAlgorithm<Node> {
  final List<List<int>> board;
  final List<List<int>> advanceOrders;
  final int startX, startY, goalX, goalY;
  int currentIndex = 0;
  bool foundGoal = false;

  DepthFirstSearch({
    required this.board,
    required this.advanceOrders,
    required this.startX,
    required this.startY,
    required this.goalX,
    required this.goalY,
  });

  @override
  Future<Node?> search(Future<void> Function(Node, [bool]) renderNode) async {
    Node initialNode = Node(startX, startY, currentIndex++);
    List<Node> stack = [initialNode];

    while (stack.isNotEmpty && !foundGoal) {
      Node current = stack.removeLast();

      await renderNode(current);

      if (current.x == goalX && current.y == goalY) {
        foundGoal = true;
        await renderNode(current, true); // Marcar meta
        return current;
      }

      // Expandir los vecinos en orden inverso
      for (var i = advanceOrders.length - 1; i >= 0; i--) {
        var advance = advanceOrders[i];
        int newX = current.x + advance[0];
        int newY = current.y + advance[1];
        bool isGrandparent =
            current.father?.x == newX && current.father?.y == newY;

        if (isValid(newX, newY, board) && !isGrandparent) {
          Node neighbor = Node(newX, newY, currentIndex++, current);
          stack.add(neighbor);
          await renderNode(neighbor);
        }
        //print('Vecino generado: ($newX, $newY)');
        //print('Pila actual: $stack');
      }
    }

    return null;
  }

  bool isValid(int x, int y, List<List<int>> board) {
    return x >= 0 &&
        x < board.length &&
        y >= 0 &&
        y < board[0].length &&
        board[x][y] != 1; // '1'  (Obstáculo)
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
