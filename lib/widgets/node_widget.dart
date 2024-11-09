import 'package:flutter/material.dart';
import 'package:proyecto_ia/models/base_node.dart';

class NodeWidget extends StatelessWidget {
  const NodeWidget(
    this.node, {
    super.key,
    required this.isGoal,
    required this.isKill,
    required this.usePath,
  });

  final BaseNode node;
  final bool isGoal;
  final bool isKill;
  final bool usePath;

  @override
  Widget build(BuildContext context) {
    late final Color color;

    if (node.father == null) {
      color = Colors.amber.shade100;
    } else if (isGoal || usePath) {
      color = Colors.green.shade100;
    } else if (isKill) {
      color = Colors.red.shade100;
    } else {
      color = Colors.blue.shade100;
    }

    return SizedBox(
      width: 70,
      height: 70,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
              width: 70,
              height: 70,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('(${node.x}, ${node.y})',
                      style: TextStyle(
                          fontSize: 12,
                          height: 1,
                          fontWeight: FontWeight.w600)),
                  Text(
                    'H: ${node.heuristic}',
                    style: TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 10, height: 1),
                  ),
                ],
              )),
          if (isGoal)
            Positioned(
              top: 2,
              right: 6,
              child: Icon(
                Icons.flag,
                color: Colors.green,
              ),
            ),
          if (isKill)
            Positioned(
              top: 2,
              right: 6,
              child: Icon(
                Icons.close,
                color: Colors.red,
              ),
            ),
        ],
      ),
    );
  }
}
