import 'package:flutter/material.dart';
import 'package:proyecto_ia/view/tree_view.dart';

class SearchAlgorithmScreen extends StatelessWidget {
  const SearchAlgorithmScreen({
    super.key,
    required this.board,
    required this.startX,
    required this.startY,
    required this.goalX,
    required this.goalY,
    required this.iterations,  // Recibir el parámetro de iteraciones
  });

  final List<List<int>> board;
  final int startX;
  final int startY;
  final int goalX;
  final int goalY;
  final int iterations;  // Almacenar las iteraciones

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<String> selectedAlgorithm = ValueNotifier<String>('');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Algoritmos de búsqueda'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: ValueListenableBuilder<String>(
            valueListenable: selectedAlgorithm,
            builder: (context, value, child) {
              return Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              );
            },
          ),
        ),
      ),
      body: TreeView(
        board: board,
        startX: startX,
        startY: startY,
        goalX: goalX,
        goalY: goalY,
        advanceOrder: [
          [-1, 0], // Arriba
          [0, 1], // Derecha
          [1, 0], // Abajo
          [0, -1], // Izquierda,
        ],
        iterations: iterations,  // Pasar las iteraciones a TreeView
        onAlgorithmChange: (String algorithm) {
          selectedAlgorithm.value = algorithm;
        },
      ),
    );
  }
}

