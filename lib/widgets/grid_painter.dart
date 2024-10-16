import 'package:flutter/material.dart';
import 'package:proyecto_ia/models/cell.dart';

class GridPainter extends CustomPainter {
  final int rows;
  final int columns;
  final double cellSize;
  final double offsetX;
  final double offsetY;
  final Set<Cell> selectedCells;
  final Map<String, ImageInfo> imageDetails = {};

  GridPainter({
    required this.rows,
    required this.columns,
    required this.cellSize,
    required this.offsetX,
    required this.offsetY,
    required this.selectedCells,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint gridPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke;

    final visibleWidth = size.width;
    final visibleHeight = size.height;

    final int startRow = (offsetY / cellSize).floor().clamp(0, rows);
    final int endRow =
        ((offsetY + visibleHeight) / cellSize).ceil().clamp(0, rows);

    final int startColumn = (offsetX / cellSize).floor().clamp(0, columns);
    final int endColumn =
        ((offsetX + visibleWidth) / cellSize).ceil().clamp(0, columns);

    for (int i = startRow; i < endRow; i++) {
      for (int j = startColumn; j < endColumn; j++) {
        final double top = i * cellSize - offsetY;
        final double left = j * cellSize - offsetX;
        final Rect cellRect = Rect.fromLTWH(left, top, cellSize, cellSize);

        final cells =
            selectedCells.where((cell) => cell.row == i && cell.column == j);

        if (cells.isNotEmpty) {
          final cell = cells.first;
          drawImageInCell(canvas, cellRect, cell.imagen);
        }
        canvas.drawRect(cellRect, gridPaint);

        final textSpan = TextSpan(
          text: '$i, $j',
          style: const TextStyle(color: Colors.black, fontSize: 14),
        );
        final textPainter = TextPainter(
          text: textSpan,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();

        final textOffset = Offset(
          left + (cellSize - textPainter.width) / 2,
          top + (cellSize - textPainter.height) / 2,
        );
        textPainter.paint(canvas, textOffset);
      }
    }
  }

  void drawImageInCell(Canvas canvas, Rect cellRect, String imagenPath) async {
    if (imageDetails[imagenPath] != null) {
      paintImage(
        canvas: canvas,
        rect: cellRect,
        image: imageDetails[imagenPath]!.image,
        fit: BoxFit.cover,
      );
      return;
    }

    final imageProvider = AssetImage(imagenPath);
    final ImageStream stream = imageProvider.resolve(ImageConfiguration());
    stream.addListener(
        ImageStreamListener((ImageInfo imageInfo, bool synchronousCall) {
      final image = imageInfo.image;
      imageDetails[imagenPath] = imageInfo;
      paintImage(
        canvas: canvas,
        rect: cellRect,
        image: image,
        fit: BoxFit.cover,
      );
    }));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
