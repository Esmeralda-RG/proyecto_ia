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
      Iterable<int> nodeIdsToRemove}) renderNode;
  final Function(String) onAlgorithmChange;
  final Function(String) onError;
  final int maxIterations;

  SearchAlgorithmController(
      {required this.board,
      required this.advanceOrders,
      required this.startX,
      required this.startY,
      required this.goalX,
      required this.goalY,
      required this.onAlgorithmChange,
      required this.maxIterations,
      required this.renderNode,
      required this.onError}) {
    _algorithms = {
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
      'Iterative Deepening Depth First Search': IterativeDepthSearch(
        board: board,
        advanceOrders: advanceOrders,
        goalX: goalX,
        goalY: goalY,
      )
    };

    _nodeContext.clear();
    _nodeContext.add(BaseNode(startX, startY, 0, 0, 0, 0, null));
  }

  late final Map<String, SearchAlgorithm> _algorithms;
  final List<BaseNode> _nodeContext = [];

  Future<void> search() async {
    try {
      final keysAlgorithm = _algorithms.keys.toList();
      keysAlgorithm.shuffle();
      for (var key in keysAlgorithm) {
        onAlgorithmChange(key);
        final algorithm = _algorithms[key]!;
        algorithm.initAlgorithm(_nodeContext, maxIterations);

        final newContext = await algorithm.search(renderNode);

        if (newContext == null) {
          onError('No solution found');
          return;
        }

        if (newContext.isNotEmpty) {
          _nodeContext.clear();
          _nodeContext.addAll(newContext);
          continue;
        }

        _nodeContext.clear();
        return;
      }
    } catch (e) {
      onError('Error: $e');
    }
  }

  List<BaseNode> getPath(BaseNode goalNode) {
    return SearchAlgorithm.getPath(goalNode);
  }

  void dispose() {
    SearchAlgorithm.dispose();
  }
}
