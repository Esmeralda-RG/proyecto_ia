import 'package:proyecto_ia/models/base_node.dart';
import 'package:proyecto_ia/models/search_algorithm.dart';
import 'package:proyecto_ia/algorithms/algorithms.dart';

class SearchAlgorithmController {
  final List<List<int>> board;
  final List<List<int>> advanceOrders;
  final int startX, startY, goalX, goalY;
  final Future<void> Function(
      {BaseNode? node,
      bool isGoal,
      bool isKill,
      List<int> nodeIdsToRemove}) renderNode;
  final Function(String) onAlgorithmChange;
  final int maxIterations;

  SearchAlgorithmController({
    required this.board,
    required this.advanceOrders,
    required this.startX,
    required this.startY,
    required this.goalX,
    required this.goalY,
    required this.onAlgorithmChange,
    required this.maxIterations,
    required this.renderNode,
  }) {
    _algorithms = {
      'Breadth First Search': BreadthFirstSearch(
          board: board,
          advanceOrders: advanceOrders,
          goalX: goalX,
          goalY: goalY),
      'Greedy Search': GreedySearch(
          board: board,
          advanceOrders: advanceOrders,
          goalX: goalX,
          goalY: goalY),
      'Uniform Cost Search': UniformCostSearch(
          board: board,
          advanceOrders: advanceOrders,
          goalX: goalX,
          goalY: goalY),
      'Depth First Search': DepthFirstSearch(
          board: board,
          advanceOrders: advanceOrders,
          goalX: goalX,
          goalY: goalY),
      'Depth Limited Search': DepthFirstSearch(
          board: board,
          advanceOrders: advanceOrders,
          goalX: goalX,
          goalY: goalY),
    };

    _nodeContext.clear();
    _nodeContext.add(BaseNode(startX, startY, 0, 0, 0, 0, null));
  }

  late final Map<String, SearchAlgorithm> _algorithms;
  final List<BaseNode> _nodeContext = [];

  Future<void> search() async {
    final keysAlgorithm = _algorithms.keys.toList();
    keysAlgorithm.shuffle();
    print('Order of algorithms: $keysAlgorithm');
    for (var key in keysAlgorithm) {
      onAlgorithmChange(key);
      final algorithm = _algorithms[key]!;
      algorithm.initAlgorithm(_nodeContext, maxIterations);

      final newContext = await algorithm.search(renderNode);

      if (newContext == null) {
        throw Exception('No solution found');
      }

      if (newContext.isNotEmpty) {
        _nodeContext.clear();
        _nodeContext.addAll(newContext);
        print('Context updated with ${_nodeContext.length} nodes');
        print('new context by $key: $_nodeContext');
        continue;
      }

      _nodeContext.clear();
      print('Solution found with $key');
      return;
    }
  }

  void dispose() {
    SearchAlgorithm.dispose();
  }
}
