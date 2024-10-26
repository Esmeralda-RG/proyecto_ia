import 'package:proyecto_ia/algorithms/breadth_first_search.dart';
import 'package:proyecto_ia/algorithms/greedy_search.dart';
import 'package:proyecto_ia/algorithms/uniform_cost.dart';
import 'package:proyecto_ia/models/base_node.dart';
import 'package:proyecto_ia/models/search_algorithm.dart';

class SearchAlgorithmController {
  final List<List<int>> board;
  final List<List<int>> advanceOrders;
  final int startX, startY, goalX, goalY;
  final Future<void> Function(BaseNode, [bool]) renderNode;
  final Function(String) onAlgorithmChange;

  SearchAlgorithmController(
      {required this.board,
      required this.advanceOrders,
      required this.startX,
      required this.startY,
      required this.goalX,
      required this.goalY,
      required this.onAlgorithmChange,
      required this.renderNode}) {
    _algorithms = {
      'Uniform Cost': UniformCost(
          board: board,
          advanceOrders: advanceOrders,
          goalX: goalX,
          goalY: goalY),
      'Greedy Search': GreedySearch(
          board: board,
          advanceOrders: advanceOrders,
          goalX: goalX,
          goalY: goalY),
      'Breadth First Search': BreadthFirstSearch(
          board: board,
          advanceOrders: advanceOrders,
          goalX: goalX,
          goalY: goalY),
    };

    _nodeContex.clear();
    _nodeContex.add(BaseNode(startX, startY, 0, 0, 0, null));
  }

  late final Map<String, SearchAlgorithm> _algorithms;

  final List<BaseNode> _nodeContex = [];

  Future<void> search() async {
    final keysAlgorithm = _algorithms.keys.toList();
    keysAlgorithm.shuffle();
    print('Order of algorithms: $keysAlgorithm');
    for (var key in keysAlgorithm) {
      onAlgorithmChange(key);
      final algorithm = _algorithms[key]!;
      algorithm.initContext(_nodeContex);
      final newContext = await algorithm.search(renderNode, 2);

      if (newContext == null) {
        throw Exception('No solution found');
      }

      if (newContext.isNotEmpty) {
        _nodeContex.clear();
        _nodeContex.addAll(newContext);
        continue;
      }

      _nodeContex.clear();
      print('Solution found with $key');
      return;
    }
  }
}
