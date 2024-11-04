import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({Key? key}) : super(key: key);

  @override
  State<FileUploadScreen> createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  late DropzoneViewController dropzoneController1;
  late DropzoneViewController dropzoneController2;
  late DropzoneViewController dropzoneController3;

  String? fileName1;
  String? fileName2;
  String? fileName3;

  void handleFileDrop1(dynamic event) async {
    fileName1 = await dropzoneController1.getFilename(event);
    final mime = await dropzoneController1.getFileMIME(event);
    print("File dropped in Zone 1: $fileName1 (MIME: $mime)");
    setState(() {}); // Actualizar el estado para mostrar el nombre del archivo
  }

  void handleFileDrop2(dynamic event) async {
    fileName2 = await dropzoneController2.getFilename(event);
    final mime = await dropzoneController2.getFileMIME(event);
    print("File dropped in Zone 2: $fileName2 (MIME: $mime)");
    setState(() {});
  }

  void handleFileDrop3(dynamic event) async {
    fileName3 = await dropzoneController3.getFilename(event);
    final mime = await dropzoneController3.getFileMIME(event);
    print("File dropped in Zone 3: $fileName3 (MIME: $mime)");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cargar Archivos'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildDropZone('Zona de Arrastre 1', fileName1, handleFileDrop1, (controller) => dropzoneController1 = controller),
            const SizedBox(height: 20),
            buildDropZone('Zona de Arrastre 2', fileName2, handleFileDrop2, (controller) => dropzoneController2 = controller),
            const SizedBox(height: 20),
            buildDropZone('Zona de Arrastre 3', fileName3, handleFileDrop3, (controller) => dropzoneController3 = controller),
          ],
        ),
      ),
    );
  }

  Widget buildDropZone(String label, String? fileName, void Function(dynamic) onDrop, void Function(DropzoneViewController) onCreated) {
    return Container(
      width: 300,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          DropzoneView(
            onCreated: onCreated,
            onDrop: onDrop,
          ),
          Center(
            child: Text(
              fileName != null
                  ? 'Archivo cargado: $fileName'
                  : label,
              style: TextStyle(color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
