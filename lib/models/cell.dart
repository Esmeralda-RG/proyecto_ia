import 'dart:ui' show Offset;

class Cell {
  Cell(this.row, this.column, this.imagen)
      : position = Offset(row.toDouble(), column.toDouble());
  final int row;
  final int column;
  final Offset position;
  final String imagen;
}

enum CellType { undefined, initial, goal, wall }
