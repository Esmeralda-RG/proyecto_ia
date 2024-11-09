import 'package:flutter/material.dart';
import 'package:proyecto_ia/models/cell.dart';

class ConfigurationProvider extends InheritedWidget {
  ConfigurationProvider({super.key, required super.child});

  static ConfigurationProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ConfigurationProvider>()!;
  }

  final ValueNotifier<Set<Cell>> selectedCellsNotifier = ValueNotifier({});
  final TextEditingController rowsController = TextEditingController(text: '4');
  final TextEditingController columnsController =
      TextEditingController(text: '4');
  final TextEditingController iterationsController =
      TextEditingController(text: '1');
  final TextEditingController maxIterationsController =
      TextEditingController(text: '2');
  final ValueNotifier<Cell?> initialPositionNotifier = ValueNotifier(null);
  final ValueNotifier<Cell?> goalPositionNotifier = ValueNotifier(null);
  final List<Cell> walls = [];

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
