import 'package:flutter/material.dart';
import 'package:proyecto_ia/utils/validate_number.dart';

class FileUploaderToBoard extends StatelessWidget {
  const FileUploaderToBoard({super.key, required this.formKey});
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
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
              ),
              TextFormField(
                controller: characterGoal,
                decoration: const InputDecoration(
                  labelText: '¿Con qué caracter o dónde está la meta?',
                ),
              ),
              TextFormField(
                  controller: maxIterationsController,
                  decoration: const InputDecoration(
                    labelText: 'Número máximo de iteraciones',
                  ),
                  validator: validateNumber),
            ],
          ),
        ));
  }
}
