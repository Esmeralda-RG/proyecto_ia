import 'package:flutter/material.dart';
import 'package:proyecto_ia/models/cell.dart';
import 'package:proyecto_ia/provider/config_provider.dart';
import 'package:proyecto_ia/utils/validate_number.dart';

class FileUploaderToBoard extends StatelessWidget {
  const FileUploaderToBoard(
      {super.key,
      required this.formKey,
      required this.fileContent,
      required this.fileContentList});
  final GlobalKey<FormState> formKey;
  final String fileContent;
  final List<String> fileContentList;

  @override
  Widget build(BuildContext context) {
    final configBoard = ConfigurationProvider.of(context);
    final characterWall = TextEditingController();
    final characterInitial = TextEditingController();
    final characterGoal = TextEditingController();
    final maxIterationsController = TextEditingController();

    return Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Column(
                children: [
                  TextFormField(
                    controller: characterWall,
                    decoration: const InputDecoration(
                      labelText: '¿Con qué caracter se representan los muros?',
                    ),
                  ),
                  TextFormField(
                    controller: characterInitial,
                    decoration: const InputDecoration(
                      labelText:
                          '¿Con qué caracter o dónde está la posición inicial?',
                    ),
                    validator: validateCoordinate,
                  ),
                  TextFormField(
                    controller: characterGoal,
                    decoration: const InputDecoration(
                      labelText: '¿Con qué caracter o dónde está la meta?',
                    ),
                    validator: validateCoordinate,
                  ),
                  TextFormField(
                      controller: maxIterationsController,
                      decoration: const InputDecoration(
                        labelText: 'Número máximo de iteraciones',
                      ),
                      validator: validateNumber),
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }
                    final List<Cell> walls = [];
                    configBoard.rowsController.text =
                        fileContentList.length.toString();
                    configBoard.columnsController.text = fileContentList[0]
                        .split('')
                        .map((e) => e.trim())
                        .length
                        .toString();

                    if (characterInitial.text.contains(',')) {
                      final coordinates = characterInitial.text
                          .split(',')
                          .map((e) => int.parse(e.trim()))
                          .toList();
                      final x = coordinates[0];
                      final y = coordinates[1];

                      configBoard.initialPositionNotifier.value =
                          Cell(x, y, 'assets/imgs/mouse.png');
                    }

                    if (characterGoal.text.contains(',')) {
                      final coordinates = characterGoal.text
                          .split(',')
                          .map((e) => int.parse(e.trim()))
                          .toList();
                      final x = coordinates[0];
                      final y = coordinates[1];
                      configBoard.goalPositionNotifier.value =
                          Cell(x, y, 'assets/imgs/cheese.png');
                    }

                    for (var i = 0; i < fileContentList.length; i++) {
                      final line = fileContentList[i]
                          .split('')
                          .map((e) => e.trim())
                          .toList();

                      for (var j = 0; j < line.length; j++) {
                        if (line[j] == characterWall.text.trim()) {
                          walls.add(Cell(i, j, 'assets/imgs/wall.png'));
                          continue;
                        }

                        if (line[j] == characterInitial.text.trim()) {
                          configBoard.initialPositionNotifier.value =
                              Cell(i, j, 'assets/imgs/mouse.png');
                          continue;
                        }

                        if (line[j] == characterGoal.text.trim()) {
                          configBoard.goalPositionNotifier.value =
                              Cell(i, j, 'assets/imgs/cheese.png');
                          continue;
                        }
                      }
                    }
                    configBoard.walls.clear();
                    configBoard.walls.addAll(walls);
                    configBoard.iterationsController.text =
                        maxIterationsController.text;
                    configBoard.selectedCellsNotifier.value = {
                      ...configBoard.walls,
                      configBoard.initialPositionNotifier.value!,
                      configBoard.goalPositionNotifier.value!
                    };
                    Navigator.pop(context);
                  },
                  child: const Text('Aceptar'))
            ],
          ),
        ));
  }

  String? validateCoordinate(String? value) {
    try {
      if (value == null || value.isEmpty || value.trim().isEmpty) {
        return 'Este campo es requerido';
      }
      if (value.contains(',')) {
        final coordinates = value.split(',').map((e) => e.trim()).toList();
        if (coordinates.length != 2) {
          return 'Coordenadas inválidas';
        }
        int.parse(coordinates[0]);
        int.parse(coordinates[1]);
        return null;
      }

      if (!fileContent.contains(value)) {
        return 'Caracter no encontrado en el archivo';
      }

      return null;
    } catch (e) {
      return 'Coordenadas inválidas';
    }
  }
}
