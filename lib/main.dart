import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'algorithms/uniform_cost.dart' as uniform_cost;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: TreeViewPage(),
      );
}

class TreeViewPage extends StatefulWidget {
  const TreeViewPage({super.key});

  @override
  State<TreeViewPage> createState() => _TreeViewPageState();
}

class _TreeViewPageState extends State<TreeViewPage> {
  late uniform_cost.UniformCost algorithm;
  final streamController = StreamController<uniform_cost.Node>();
  final Graph graph = Graph()..isTree = true;
  final BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();
  final paint = Paint()
    ..color = Colors.green
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;

  Future<void> renderNode(uniform_cost.Node node) async {
    await Future.delayed(Duration(milliseconds: 500));

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
    algorithm = uniform_cost.UniformCost(
      board: [
        [0, 0, 0, 0],
        [0, 1, 1, 0],
        [0, 1, 0, 0],
        [0, 0, 0, 1]
      ],
      advanceOrders: [
        [-1, 0], // Arriba
        [0, 1], // Derecha
        [1, 0], // Abajo
        [0, -1], // Izquierda,
      ],
      startX: 2,
      startY: 0,
      goalX: 1,
      goalY: 3,
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
    return Scaffold(
        body: InteractiveViewer(
            constrained: false,
            boundaryMargin: EdgeInsets.all(100),
            minScale: 0.01,
            maxScale: 5.6,
            child: StreamBuilder<uniform_cost.Node>(
                stream: streamController.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  return GraphView(
                    graph: graph,
                    algorithm: BuchheimWalkerAlgorithm(
                        builder, TreeEdgeRenderer(builder)),
                    paint: paint,
                    builder: (Node node) {
                      final value = node.key?.value as uniform_cost.Node;
                      return nodeWidget(value,
                          isRoot: value.father == null,
                          isGoal: value.x == algorithm.goalX &&
                              value.y == algorithm.goalY);
                    },
                  );
                })));
  }

  Widget nodeWidget(uniform_cost.Node node,
      {bool isRoot = false, bool isGoal = false}) {
    final color = isRoot
        ? Colors.green.shade100
        : isGoal
            ? Colors.red.shade100
            : Colors.blue.shade100;

    return InkWell(
      onTap: () {
        print(algorithm.getPath(node));
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(4), color: color),
        child: Text(node.toString()),
      ),
    );
  }
}
