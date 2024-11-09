import 'package:flutter/material.dart';
import 'package:proyecto_ia/utils/validate_number.dart';
import 'package:proyecto_ia/provider/config_provider.dart';
import 'package:proyecto_ia/screens/file_upload_screen.dart';

class ConfigPanel extends StatelessWidget {
  const ConfigPanel({
    super.key,
    required this.formKey,
    required this.onInit,
  });

  final GlobalKey<FormState> formKey;
  final void Function() onInit;

  @override
  Widget build(BuildContext context) {
    final configState = ConfigurationProvider.of(context);
    final maxIterationsController = configState.maxIterationsController;
    final rowsController = configState.rowsController;
    final columnsController = configState.columnsController;
    final selectedCellsNotifier = configState.selectedCellsNotifier;
    final initialPositionNotifier = configState.initialPositionNotifier;
    final goalPositionNotifier = configState.goalPositionNotifier;
    final walls = configState.walls;

    return Form(
      key: formKey,
      child: SizedBox(
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextFormField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              controller: maxIterationsController,
              validator: validateNumber,
              decoration: const InputDecoration(
                labelText: 'Maximo de iteraciones',
              ),
            ),
            TextFormField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              controller: rowsController,
              validator: validateNumber,
              decoration: const InputDecoration(
                labelText: 'Filas',
              ),
            ),
            TextFormField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              controller: columnsController,
              validator: validateNumber,
              decoration: const InputDecoration(
                labelText: 'Columnas',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Por favor, llena los campos correctamente'),
                    ),
                  );
                  return;
                }
                selectedCellsNotifier.value = {};
                initialPositionNotifier.value = null;
                goalPositionNotifier.value = null;
                walls.clear();
              },
              child: const Text('Generar tablero'),
            ),
            ElevatedButton(
              onPressed: () {
                selectedCellsNotifier.value = {};
                initialPositionNotifier.value = null;
                goalPositionNotifier.value = null;
                walls.clear();
              },
              child: const Text('Limpiar tablero'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FileUploadScreen()),
                );
              },
              child: const Text('Cargar Archivo'),
            ),
            ElevatedButton(onPressed: onInit, child: Text('Iniciar')),
          ],
        ),
      ),
    );
  }
}
