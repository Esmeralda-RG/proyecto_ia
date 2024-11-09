import 'dart:convert' show utf8;

import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:proyecto_ia/provider/config_provider.dart';
import 'package:proyecto_ia/utils/validate_number.dart';

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({super.key});

  @override
  State<FileUploadScreen> createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  late DropzoneViewController dropzoneController;
  late final ConfigurationProvider? configState;
  String fileContent = '';

  void message(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  void handleFileDrop(dynamic event) async {
    final mime = await dropzoneController.getFileMIME(event);
    if (mime != 'text/plain') {
      message('Solo se permiten archivos de texto');
      return;
    }
    final data = await dropzoneController.getFileData(event);
    final content = utf8.decode(data);
    setState(() {
      fileContent = content;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cargar Archivo'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          fileContent.isEmpty
              ? Center(
                  child: Container(
                    width: 300,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        DropzoneView(
                          onCreated: (controller) =>
                              dropzoneController = controller,
                          onDrop: handleFileDrop,
                        ),
                        Center(
                          child: Text(
                            'Arrastra un archivo aquí para cargar',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Container(
                    width: 600,
                    height: 600,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FileUploaderToBoard(),
                  ),
                ),
        ],
      ),
    );
  }
}

class FileUploaderToBoard extends StatelessWidget {
  const FileUploaderToBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
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
