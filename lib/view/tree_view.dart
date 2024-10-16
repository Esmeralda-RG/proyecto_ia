import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:proyecto_ia/algorithms/greedy_search.dart' as greedy_search;

class TreeView extends StatefulWidget {
  const TreeView(
      {super.key,
      required this.board,
      required this.advanceOrder,
      required this.startX,
      required this.startY,
      required this.goalX,
      required this.goalY});
  final List<List<int>> board;
  final List<List<int>> advanceOrder;
  final int startX;
  final int startY;
  final int goalX;
  final int goalY;
  @override
  State<TreeView> createState() => _TreeViewState();
}

class _TreeViewState extends State<TreeView> {
  late greedy_search.GreedySearch algorithm;
  final streamController = StreamController<greedy_search.Node>();
  final Graph graph = Graph()..isTree = true;
  final BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();
  final paint = Paint()
    ..color = Colors.green
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;

  Future<void> renderNode(greedy_search.Node node) async {
    await Future.delayed(Duration(milliseconds: 1000));

    if (node.father == null) {
      graph.addNode(Node.Id(node));
    } else {
      final child = Node.Id(node);
      final parent = Node.Id(node.father);
      graph.addEdge(parent, child);
    }
    streamController.add(node);
  }

  @override
  void initState() {
    super.initState();
    algorithm = greedy_search.GreedySearch(
      board: widget.board,
      advanceOrders: widget.advanceOrder,
      startX: widget.startX,
      startY: widget.startY,
      goalX: widget.goalX,
      goalY: widget.goalY,
    );

    algorithm.search(renderNode);

    builder
      ..siblingSeparation = (50)
      ..levelSeparation = (50)
      ..subtreeSeparation = (50)
      ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<greedy_search.Node>(
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
            minScale: 0.01,
            maxScale: 5.6,
            child: GraphView(
              graph: graph,
              algorithm:
                  BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
              paint: paint,
              builder: (Node node) {
                final value = node.key?.value as greedy_search.Node;
                return nodeWidget(value,
                    isRoot: value.father == null,
                    isGoal: value.x == algorithm.goalX &&
                        value.y == algorithm.goalY);
              },
            ),
          );
        });
  }

  Widget nodeWidget(greedy_search.Node node,
      {bool isRoot = false, bool isGoal = false}) {
    final color = isRoot
        ? Colors.green.shade100
        : isGoal
            ? Colors.red.shade100
            : Colors.blue.shade100;

    return Container(
      padding: EdgeInsets.all(16),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(4), color: color),
      child: Text(node.toString()),
    );
  }
}
