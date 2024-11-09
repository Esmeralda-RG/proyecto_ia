import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'dart:convert';

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({Key? key, required this.onMatrixLoaded}) : super(key: key);

  final void Function(List<List<String>> matrix) onMatrixLoaded;

  @override
  State<FileUploadScreen> createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  late DropzoneViewController dropzoneController;
  String? fileName;

  Future<void> handleFileDrop(dynamic event) async {
    fileName = await dropzoneController.getFilename(event);
    final bytes = await dropzoneController.getFileData(event);
    final fileContent = utf8.decode(bytes);
    final matrix = _parseMatrix(fileContent);

    if (matrix != null) {
      widget.onMatrixLoaded(matrix);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El archivo no tiene el formato correcto')),
      );
    }
  }

  List<List<String>>? _parseMatrix(String content) {
    final lines = content
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    if (lines.length != 4 || lines.any((line) => line.replaceAll(' ', '').length != 4)) {
      return null;
    }

    return lines.map((line) => line.replaceAll(' ', '').split('')).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cargar Archivo'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
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
                    onCreated: (controller) => dropzoneController = controller,
                    onDrop: handleFileDrop,
                  ),
                  Center(
                    child: Text(
                      fileName != null
                          ? 'Archivo cargado: $fileName'
                          : 'Arrastra un archivo aquí para cargar',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "El ratón se representa con 'o', el queso con 'x' y los muros con '#'",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}




