import 'package:flutter/material.dart';
import 'package:proyecto_ia/models/cell.dart';
import 'package:proyecto_ia/widgets/widgets.dart';
import 'package:proyecto_ia/provider/config_provider.dart';
import 'package:proyecto_ia/screens/search_algorithm_screen.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<CellType> cellType = ValueNotifier(CellType.undefined);
    final size = MediaQuery.of(context).size;
    final configBoardFormKey = GlobalKey<FormState>();

    final configState = ConfigurationProvider.of(context);
    final rowsController = configState.rowsController;
    final columnsController = configState.columnsController;
    final iterationsController = configState.iterationsController;
    final initialPositionNotifier = configState.initialPositionNotifier;
    final goalPositionNotifier = configState.goalPositionNotifier;
    final walls = configState.walls;

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
                    ConfigPanel(
                        formKey: configBoardFormKey,
                        onInit: () {
                          if (!configBoardFormKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Por favor, llena los campos correctamente')));
                            return;
                          }

                          if (initialPositionNotifier.value == null ||
                              goalPositionNotifier.value == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Por favor, selecciona la posición inicial y la meta')));
                            return;
                          }

                          final board = List.generate(
                              int.parse(rowsController.text),
                              (index) => List.generate(
                                  int.parse(columnsController.text),
                                  (index) => 0));

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
                                iterations:
                                    int.parse(iterationsController.text),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ),
          ),
          ValueListenableBuilder(
              valueListenable: cellType,
              builder: (context, value, _) {
                return Column(
                  children: [
                    ConfigBoard(cellType: value),
                    ConfigCellTypeWidget(
                        cellType: value,
                        onCellTypeChanged: (value) {
                          cellType.value = value;
                        })
                  ],
                );
              }),
        ],
      ),
    );
  }
}
