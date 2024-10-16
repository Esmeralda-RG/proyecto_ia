import 'package:flutter/material.dart';
import 'package:proyecto_ia/view/tree_view.dart';

class SearchAlgorithmScreen extends StatelessWidget {
  const SearchAlgorithmScreen(
      {super.key,
      required this.board,
      required this.startX,
      required this.startY,
      required this.goalX,
      required this.goalY});
  final List<List<int>> board;
  final int startX;
  final int startY;
  final int goalX;
  final int goalY;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Algoritmos de búsqueda'),
        ),
        body: TreeView(
          board: board,
          advanceOrder: [
            [-1, 0], // Arriba
            [0, 1], // Derecha
            [1, 0], // Abajo
            [0, -1], // Izquierda,
          ],
          startX: startX,
          startY: startY,
          goalX: goalX,
          goalY: goalY,
        ));
  }
}
