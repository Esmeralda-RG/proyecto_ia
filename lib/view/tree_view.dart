import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
//import 'package:proyecto_ia/algorithms/greedy_search.dart' as greedy_search;
//import 'package:proyecto_ia/algorithms/uniform_cost.dart' as uniform_cost;
import 'package:proyecto_ia/algorithms/depth_first_search.dart'
    as depth_first_search;

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
  late depth_first_search.DepthFirstSearch algorithm;
  //late uniform_cost.UniformCost algorithm;
  //late greedy_search.GreedySearch algorithm;
  late Future executionSearch;
  //final streamController = StreamController<bool>();
  final streamController = StreamController<bool>();
  final Graph graph = Graph()..isTree = true;
  final BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();
  final paint = Paint()
    ..color = Colors.green
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;

  int xGoalParent = -1;
  int yGoalParent = -1;

  //Future<void> renderNode(uniform_cost.Node node, [bool isGoal = false]) async {
  Future<void> renderNode(depth_first_search.Node node,
      [bool isGoal = false]) async {
    //print('Renderizando nodo: (${node.x}, ${node.y})');
    await Future.delayed(Duration(seconds: 1));

    if (node.father == null) {
      graph.addNode(Node.Id(node));
    } else {
      final child = Node.Id(node);
      final parent = Node.Id(node.father);
      graph.addEdge(parent, child);
    }
    if (isGoal) {
      xGoalParent = node.father?.x ?? -1;
      yGoalParent = node.father?.y ?? -1;
      //print('Nodo meta encontrado: (${node.x}, ${node.y})');
    }
    streamController.add(isGoal);
  }

  @override
  void initState() {
    super.initState();
    //algorithm = greedy_search.GreedySearch(
    //algorithm = uniform_cost.UniformCost(
    algorithm = depth_first_search.DepthFirstSearch(
      board: widget.board,
      advanceOrders: widget.advanceOrder,
      startX: widget.startX,
      startY: widget.startY,
      goalX: widget.goalX,
      goalY: widget.goalY,
    );

    executionSearch = algorithm.search(renderNode);

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
        //return StreamBuilder<bool>(
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
                // final value = node.key?.value as uniform_cost.Node;
                final value = node.key?.value as depth_first_search.Node;
                return nodeWidget(value,
                    isRoot: value.father == null,
                    isGoal: (snapshot.data ?? false) &&
                        (value.x == widget.goalX && value.y == widget.goalY));
              },
            ),
          );
        });
  }

  Widget nodeWidget(depth_first_search.Node node,
      // Widget nodeWidget(uniform_cost.Node node,
      {bool isRoot = false,
      bool isGoal = false}) {
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
          child: Text(node.toString()),
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
