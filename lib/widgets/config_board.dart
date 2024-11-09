import 'package:flutter/material.dart';
import 'package:proyecto_ia/models/cell.dart';
import 'package:proyecto_ia/provider/config_provider.dart';
import 'package:proyecto_ia/widgets/dragable_grid.dart';

class ConfigBoard extends StatelessWidget {
  const ConfigBoard({super.key, required this.cellType});
  final CellType cellType;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final configState = ConfigurationProvider.of(context);
    final selectedCellsNotifier = configState.selectedCellsNotifier;
    final rowsController = configState.rowsController;
    final columnsController = configState.columnsController;
    final initialPositionNotifier = configState.initialPositionNotifier;
    final goalPositionNotifier = configState.goalPositionNotifier;
    final walls = configState.walls;

    return SizedBox(
      width: size.width * .8,
      height: (size.height - 60) * .8,
      child: ValueListenableBuilder(
        valueListenable: selectedCellsNotifier,
        builder: (context, value, _) {
          return DragableGrid(
            rows: int.parse(rowsController.text),
            columns: int.parse(columnsController.text),
            selectedCells: value,
            imageForCell: (row, column) {
              if (cellType == CellType.undefined) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Selecciona un tipo de celda'),
                  ),
                );
                return null;
              }

              if (initialPositionNotifier.value != null &&
                  initialPositionNotifier.value?.row == row &&
                  initialPositionNotifier.value?.column == column) {
                initialPositionNotifier.value = null;
                return '';
              }

              if (goalPositionNotifier.value != null &&
                  goalPositionNotifier.value?.row == row &&
                  goalPositionNotifier.value?.column == column) {
                goalPositionNotifier.value = null;
                return '';
              }

              if (initialPositionNotifier.value != null &&
                  cellType == CellType.initial) {
                return null;
              }

              if (goalPositionNotifier.value != null &&
                  cellType == CellType.goal) {
                return null;
              }

              if (walls.any((element) =>
                  element.row == row && element.column == column)) {
                walls.removeWhere((element) =>
                    element.row == row && element.column == column);
                return '';
              }

              if (cellType == CellType.initial) {
                initialPositionNotifier.value =
                    Cell(row, column, 'assets/imgs/mouse.png');
                return 'assets/imgs/mouse.png';
              }

              if (cellType == CellType.goal) {
                goalPositionNotifier.value =
                    Cell(row, column, 'assets/imgs/cheese.png');
                return 'assets/imgs/cheese.png';
              }

              walls.add(Cell(row, column, 'assets/imgs/wall.png'));
              return 'assets/imgs/wall.png';
            },
          );
        },
      ),
    );
  }
}
