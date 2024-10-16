import 'package:flutter/material.dart';

class SearchAlgorithmScreen extends StatelessWidget {
  const SearchAlgorithmScreen(
      {super.key, required this.board, required this.advanceOrder});
  final List<List<int>> board;
  final List<List<int>> advanceOrder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Algoritmos de búsqueda'),
      ),
      body: const Center(
        child: Text('Pantalla de algoritmos de búsqueda'),
      ),
    );
  }
}
