import 'package:graphview/GraphView.dart';
import 'package:proyecto_ia/models/base_node.dart';

extension NodeExtension on Node {
  String get id {
    return key?.value.toString() ?? '';
  }

  static List<BaseNode> nodes = [];

  void addValue(BaseNode node) {
    nodes.add(node);
  }

  BaseNode get value {
    return nodes.firstWhere((element) => element.index == int.parse(id));
  }
}
