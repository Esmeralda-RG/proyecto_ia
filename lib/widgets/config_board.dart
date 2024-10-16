import 'package:flutter/material.dart';
import 'package:proyecto_ia/utils/validate_number.dart';

class ConfigBoard extends StatelessWidget {
  const ConfigBoard({
    super.key,
    required this.rowsController,
    required this.columnsController,
    required this.onGenerateBoard,
    required this.onClearBoard,
    required this.formKey,
  });

  final TextEditingController rowsController;
  final TextEditingController columnsController;
  final void Function()? onGenerateBoard;
  final void Function()? onClearBoard;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SizedBox(
        height: 210,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
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
                onGenerateBoard?.call();
              },
              child: const Text('Generar tablero'),
            ),
            ElevatedButton(
              onPressed: onClearBoard,
              child: const Text('Limpiar tablero'),
            ),
          ],
        ),
      ),
    );
  }
}
