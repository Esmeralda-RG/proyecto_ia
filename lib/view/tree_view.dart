import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:proyecto_ia/extensions/node_extension.dart';
import 'package:proyecto_ia/models/base_node.dart';
import 'package:proyecto_ia/controllers/search_algorithm_controller.dart';
import 'package:proyecto_ia/widgets/iterations_input_prompt.dart';
import 'package:proyecto_ia/widgets/node_widget.dart';

class TreeView extends StatefulWidget {
  const TreeView(
      {super.key,
      required this.board,
      required this.advanceOrder,
      required this.startX,
      required this.startY,
      required this.goalX,
      required this.goalY,
      required this.onAlgorithmChange});
  final List<List<int>> board;
  final List<List<int>> advanceOrder;
  final int startX;
  final int startY;
  final int goalX;
  final int goalY;
  final ValueChanged<String> onAlgorithmChange;
  @override
  State<TreeView> createState() => _TreeViewState();
}

class _TreeViewState extends State<TreeView> {
  late final SearchAlgorithmController _algorithmController;
  late final Future executionSearch;
  final streamController = StreamController<bool>();
  final Graph graph = Graph()..isTree = true;
  final BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();
  final paint = Paint()
    ..color = Colors.green
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;

  String nodeGoal = '';
  final List<String> nodeKill = [];

  Future<void> renderNode(BaseNode node,
      {bool isGoal = false, bool isKill = false}) async {
    await Future.delayed(Duration(milliseconds: isKill ? 200 : 1000));

    if (node.father == null) {
      graph.addNode(Node.Id('${node.index}')..addValue(node));
    } else {
      final child = Node.Id('${node.index}')..addValue(node);
      final parent = Node.Id('${node.father!.index}');
      graph.addEdge(parent, child);
    }
    if (isGoal) {
      nodeGoal = '${node.index}';
    }

    if (isKill) {
      nodeKill.add('${node.index}');
    }

    streamController.add(true);
  }

  Future<int> getIterations(String algorithm) async {
    final iterations = await showDialog<int>(
        context: context,
        barrierDismissible: false,
        builder: (_) => IterationsInputPrompt(algorithm: algorithm));

    return iterations ?? 0;
  }

  @override
  void initState() {
    super.initState();
    _algorithmController = SearchAlgorithmController(
        board: widget.board,
        advanceOrders: widget.advanceOrder,
        startX: widget.startX,
        startY: widget.startY,
        goalX: widget.goalX,
        goalY: widget.goalY,
        onAlgorithmChange: widget.onAlgorithmChange,
        getMaxIterations: getIterations,
        renderNode: renderNode);

    builder
      ..siblingSeparation = 50
      ..levelSeparation = 50
      ..subtreeSeparation = 50
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      executionSearch = _algorithmController.search();
    });
  }

  @override
  void dispose() {
    executionSearch.ignore();
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: streamController.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          return InteractiveViewer(
            constrained: false,
            boundaryMargin: EdgeInsets.all(10),
            scaleEnabled: false,
            child: GraphView(
              graph: graph,
              algorithm:
                  BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
              paint: paint,
              builder: (Node node) {
                final String id = node.id;
                return NodeWidget(node.value,
                    isGoal: nodeGoal == id, isKill: nodeKill.contains(id));
              },
            ),
          );
        });
  }
}
