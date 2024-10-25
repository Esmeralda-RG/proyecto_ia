import 'package:proyecto_ia/algorithms/search_algorithm.dart';

class Node {
  final int x, y;
  final Node? father;
  Node(this.x, this.y, [this.father]);

  @override
  String toString() => '($x, $y)';
}

class DepthFirstSearch implements SearchAlgorithm<Node> {
  final List<List<int>> board;
  final List<List<int>> advanceOrders;
  final int startX, startY, goalX, goalY;
  int currentIndex = 0;

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
    Node initialNode = Node(startX, startY);
    List<Node> stack = [initialNode];
    await renderNode(initialNode);
    while (stack.isNotEmpty) {
      Node current = stack.removeLast();

      if (current.x == goalX && current.y == goalY) {
        await renderNode(current, true);
        return current;
      }

      final List<Node> neighbors = [];
      for (var advance in advanceOrders) {
        int newX = current.x + advance[0];
        int newY = current.y + advance[1];
        bool isGrandparent =
            current.father?.x == newX && current.father?.y == newY;

        if (isValid(newX, newY, board) && !isGrandparent) {
          Node neighbor = Node(newX, newY, current);
          neighbors.add(neighbor);
          await renderNode(neighbor);
        }
      }
      stack.addAll(neighbors.reversed);
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
