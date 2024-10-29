import 'package:flutter/material.dart';
import 'package:proyecto_ia/models/base_node.dart';

class NodeWidget extends StatelessWidget {
  const NodeWidget(
    this.node, {
    super.key,
    required this.isGoal,
    required this.isKill,
  });

  final BaseNode node;
  final bool isGoal;
  final bool isKill;

  @override
  Widget build(BuildContext context) {
    late final Color color;

    if (node.father == null) {
      color = Colors.amber.shade100;
    } else if (isGoal) {
      color = Colors.green.shade100;
    } else if (isKill) {
      color = Colors.red.shade100;
    } else {
      color = Colors.blue.shade100;
    }

    return Stack(
      children: [
        Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4), color: color),
            child: Column(
              children: [
                Text('(${node.x}, ${node.y})'),
                SizedBox(height: 2),
                Text(
                  'C: ${node.cost}  H: ${node.heuristic} I: ${node.index}',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                )
              ],
            )),
        if (isGoal)
          Positioned(
            top: 2,
            right: 10,
            child: Icon(
              Icons.flag,
              color: Colors.green,
            ),
          ),
        if (isKill)
          Positioned(
            top: 2,
            right: 10,
            child: Icon(
              Icons.close,
              color: Colors.red,
            ),
          ),
      ],
    );
  }
}
