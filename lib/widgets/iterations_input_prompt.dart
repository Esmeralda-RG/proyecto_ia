import 'package:flutter/material.dart';

class IterationsInputPrompt extends StatelessWidget {
  const IterationsInputPrompt({super.key, required this.algorithm});
  final String algorithm;
  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return AlertDialog(
      title: Text('Iterations for $algorithm'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('How many iterations do you want to run the search?'),
            ),
            TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: 'Iterations'),
                textAlignVertical: TextAlignVertical.center,
                onChanged: (value) {
                  if (int.tryParse(value) == null) {
                    controller.clear();
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a number';
                  }
                  return null;
                }),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (!formKey.currentState!.validate()) {
              return;
            }
            Navigator.of(context).pop(int.parse(controller.text));
          },
          child: Text('Ok'),
        ),
      ],
    );
  }
}
