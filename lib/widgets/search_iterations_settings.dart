import 'package:flutter/material.dart';
import 'package:proyecto_ia/utils/validate_number.dart';

class SearchIterationsSettings extends StatelessWidget {
  const SearchIterationsSettings({
    super.key,
    this.onStartSearch,
    required this.finishConfigFormKey,
    required this.iterationsController,
  });
  final GlobalKey<FormState> finishConfigFormKey;
  final TextEditingController iterationsController;
  final void Function()? onStartSearch;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: finishConfigFormKey,
      child: SizedBox(
        height: 110,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextFormField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              controller: iterationsController,
              validator: validateNumber,
              decoration: const InputDecoration(
                labelText: 'Número de iteraciones',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (!finishConfigFormKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Por favor, llena los campos correctamente'),
                    ),
                  );
                  return;
                }
                onStartSearch?.call();
              },
              child: const Text('Iniciar búsqueda'),
            ),
          ],
        ),
      ),
    );
  }
}
