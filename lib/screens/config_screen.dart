import 'package:flutter/material.dart';
import 'package:proyecto_ia/models/cell.dart';
import 'package:proyecto_ia/screens/search_algorithm_screen.dart';
import 'package:proyecto_ia/widgets/config_board.dart';
import 'package:proyecto_ia/widgets/custom_button.dart';
import 'package:proyecto_ia/widgets/dragable_grid.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    CellType cellType = CellType.undefined;

    final ValueNotifier<Set<Cell>> selectedCellsNotifier =
        ValueNotifier<Set<Cell>>({});
    final TextEditingController rowsController =
        TextEditingController(text: '4');
    final TextEditingController columnsController =
        TextEditingController(text: '4');

    final ValueNotifier<Cell?> initialPositionNotifier =
        ValueNotifier<Cell?>(null);
    final ValueNotifier<Cell?> goalPositionNotifier =
        ValueNotifier<Cell?>(null);
    final List<Cell> walls = [];
    final GlobalKey<FormState> configBoardFormKey = GlobalKey<FormState>();

    int rows = 4;
    int columns = 4;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Proyecto IA'),
        toolbarHeight: 60,
        centerTitle: true,
      ),
      body: Row(
        children: [
          SizedBox(
            width: size.width * .2,
            height: size.height - 60,
            child: Center(
              child: FractionallySizedBox(
                widthFactor: .8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Configuración',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ConfigBoard(
                      rowsController: rowsController,
                      columnsController: columnsController,
                      onGenerateBoard: () {
                        selectedCellsNotifier.value = {};
                        initialPositionNotifier.value = null;
                        goalPositionNotifier.value = null;
                        walls.clear();
                        rows = int.parse(rowsController.text);
                        columns = int.parse(columnsController.text);
                      },
                      onClearBoard: () {
                        initialPositionNotifier.value = null;
                        goalPositionNotifier.value = null;
                        walls.clear();
                        selectedCellsNotifier.value = {};
                      },
                      onInit: () {
                        if (!configBoardFormKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Por favor, llena los campos correctamente'),
                            ),
                          );
                          return;
                        }

                        if (initialPositionNotifier.value == null ||
                            goalPositionNotifier.value == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Por favor, selecciona la posición inicial y la meta'),
                            ),
                          );
                          return;
                        }

                        final board = List.generate(
                          rows,
                          (index) => List.generate(
                            columns,
                            (index) => 0,
                          ),
                        );

                        for (var element in walls) {
                          board[element.row][element.column] = 1;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchAlgorithmScreen(
                              board: board,
                              startX: initialPositionNotifier.value!.row,
                              startY: initialPositionNotifier.value!.column,
                              goalX: goalPositionNotifier.value!.row,
                              goalY: goalPositionNotifier.value!.column,
                            ),
                          ),
                        );
                      },
                      formKey: configBoardFormKey,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(
                width: size.width * .8,
                height: (size.height - 60) * .8,
                child: ValueListenableBuilder(
                    valueListenable: selectedCellsNotifier,
                    builder: (context, value, _) {
                      return DragableGrid(
                        rows: rows,
                        columns: columns,
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
                    }),
              ),
              SizedBox(
                width: size.width * .8,
                height: (size.height - 60) * .2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Selecciona el tipo de celda',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ValueListenableBuilder(
                            valueListenable: initialPositionNotifier,
                            builder: (context, value, _) {
                              return CustomButton(
                                text: 'Ratón Jones',
                                imagen: 'assets/imgs/mouse.png',
                                onPressed: value != null
                                    ? null
                                    : () {
                                        cellType = CellType.initial;
                                      },
                              );
                            }),
                        ValueListenableBuilder(
                            valueListenable: goalPositionNotifier,
                            builder: (context, value, _) {
                              return CustomButton(
                                  text: 'Queso',
                                  imagen: 'assets/imgs/cheese.png',
                                  onPressed: value != null
                                      ? null
                                      : () {
                                          cellType = CellType.goal;
                                        });
                            }),
                        CustomButton(
                            text: 'Muro',
                            imagen: 'assets/imgs/wall.png',
                            onPressed: () {
                              cellType = CellType.wall;
                            }),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
