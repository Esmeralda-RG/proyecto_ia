import 'dart:convert' show utf8;

import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:proyecto_ia/provider/config_provider.dart';
import 'package:proyecto_ia/widgets/file_uploader_to_board.dart';

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
                    child: FileUploaderToBoard(formKey: GlobalKey<FormState>()),
                  ),
                ),
        ],
      ),
    );
  }
}
