import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:proyecto_ia/models/base_node.dart';
import 'package:proyecto_ia/widgets/node_widget.dart';
import 'package:proyecto_ia/extensions/graph_extension.dart';
import 'package:proyecto_ia/controllers/search_algorithm_controller.dart';

class TreeView extends StatefulWidget {
  const TreeView({
    super.key,
    required this.board,
    required this.advanceOrder,
    required this.startX,
    required this.startY,
    required this.goalX,
    required this.goalY,
    required this.iterations,
    required this.onAlgorithmChange,
  });

  final List<List<int>> board;
  final List<List<int>> advanceOrder;
  final int startX;
  final int startY;
  final int goalX;
  final int goalY;
  final int iterations;
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

  String goalNodeId = '';
  final List<String> killNodesId = [];
  final List<String> pathNodesId = [];

  Future<void> renderNode(
      {BaseNode? node,
      bool isGoal = false,
      bool isKill = false,
      Iterable<int> nodeIdsToRemove = const []}) async {
    if (node == null) {
      graph.deleteNodesById(nodeIdsToRemove.map((e) => '$e'));
      streamController.add(true);
      return;
    }

    if (node.father == null) {
      graph.addNode(Node.Id('${node.index}')..addValue(node));
    } else {
      final child = Node.Id('${node.index}')..addValue(node);
      final parent = Node.Id('${node.father!.index}');
      graph.addEdge(parent, child);
    }

    if (isGoal) {
      goalNodeId = '${node.index}';
      _algorithmController.getPath(node).forEach((element) {
        pathNodesId.add('${element.index}');
      });
    }

    if (isKill) {
      killNodesId.add('${node.index}');
    }

    await Future.delayed(Duration(milliseconds: isKill ? 200 : 1000));
    streamController.add(true);
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
      maxIterations: widget.iterations,
      onAlgorithmChange: widget.onAlgorithmChange,
      renderNode: renderNode,
      onError: message,
    );

    builder
      ..siblingSeparation = 25
      ..levelSeparation = 30
      ..subtreeSeparation = 25
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;

    executionSearch = _algorithmController.search();
  }

  void message(String message) {
    showAdaptiveDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Ok'),
                ),
              ],
            ));
  }

  @override
  void dispose() {
    executionSearch.ignore();
    streamController.close();
    _algorithmController.dispose();
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

        if (graph.nodes.isEmpty) {
          return Center(child: Text("No hay nodos para mostrar"));
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
              return NodeWidget(
                node.value,
                isGoal: goalNodeId == id,
                isKill: killNodesId.contains(id),
                usePath: pathNodesId.contains(id),
              );
            },
          ),
        );
      },
    );
  }
}
