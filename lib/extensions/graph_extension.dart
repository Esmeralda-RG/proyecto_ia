import 'package:graphview/GraphView.dart';
import 'package:proyecto_ia/models/base_node.dart';

extension GraphExtension on Graph {
  void deleteNodeById(String id) {
    final node = nodes.firstWhere((element) => element.id == id);
    removeNode(node);
  }

  void deleteNodesById(Iterable<String> ids) {
    final filteredNodes =
        nodes.where((element) => ids.contains(element.id)).toList();
    removeNodes(filteredNodes);
  }
}

extension NodeExtension on Node {
  String get id {
    return key?.value.toString() ?? '';
  }

  static final List<BaseNode> nodes = [];

  void addValue(BaseNode node) {
    nodes.add(node);
  }

  BaseNode get value {
    return nodes.firstWhere((element) => element.index == int.parse(id));
  }
}
