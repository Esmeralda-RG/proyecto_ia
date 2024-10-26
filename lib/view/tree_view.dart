import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:proyecto_ia/models/base_node.dart';
import 'package:proyecto_ia/controllers/search_algorithm_controller.dart';

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
  late Future executionSearch;
  final streamController = StreamController<bool>();
  final Graph graph = Graph()..isTree = true;
  final BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();
  final paint = Paint()
    ..color = Colors.green
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;

  int xGoalParent = -1;
  int yGoalParent = -1;

  Future<void> renderNode(BaseNode node, [bool isGoal = false]) async {
    await Future.delayed(Duration(seconds: 1));

    if (node.father == null) {
      graph.addNode(Node.Id('(${node.x}, ${node.y}), ${node.index}'));
    } else {
      final child = Node.Id('(${node.x}, ${node.y}), ${node.index}');
      final parent = Node.Id(
          '(${node.father!.x}, ${node.father!.y}), ${node.father!.index}');
      graph.addEdge(parent, child);
    }
    if (isGoal) {
      xGoalParent = node.father?.x ?? -1;
      yGoalParent = node.father?.y ?? -1;
    }
    streamController.add(isGoal);
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
        renderNode: renderNode);

    executionSearch = _algorithmController.search();
    executionSearch.whenComplete(() {
      streamController.close();
    });
    builder
      ..siblingSeparation = (50)
      ..levelSeparation = (50)
      ..subtreeSeparation = (50)
      ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM);
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
                return nodeWidget(null, text: node.key!.value.toString());
              },
            ),
          );
        });
  }

  Widget nodeWidget(BaseNode? node,
      {bool isRoot = false, bool isGoal = false, String text = ''}) {
    final color = isRoot
        ? Colors.green.shade100
        : isGoal
            ? Colors.red.shade100
            : Colors.blue.shade100;

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4), color: color),
          child: Text(node?.toString() ?? text),
        ),
        if (isGoal)
          Positioned(
            top: -10,
            right: 0,
            child: Icon(
              Icons.flag,
              color: Colors.red,
            ),
          ),
      ],
    );
  }
}
