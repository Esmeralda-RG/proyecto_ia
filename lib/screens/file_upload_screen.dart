import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({super.key});

  @override
  State<FileUploadScreen> createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  late DropzoneViewController dropzoneController;
  String? fileName;

  void handleFileDrop(dynamic event) async {
    fileName = await dropzoneController.getFilename(event);
    final mime = await dropzoneController.getFileMIME(event);
    print("File dropped: $fileName");
    print("MIME type: $mime");

    // Aquí puedes añadir más lógica para procesar el archivo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cargar Archivo'),
        centerTitle: true,
      ),
      body: Center(
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
      ),
    );
  }
}
