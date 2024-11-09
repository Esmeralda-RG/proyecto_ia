import 'package:flutter/material.dart';
import 'package:proyecto_ia/models/cell.dart';
import 'package:proyecto_ia/widgets/grid_painter.dart';

class DragableGrid extends StatefulWidget {
  const DragableGrid({
    super.key,
    required this.rows,
    required this.columns,
    required this.imageForCell,
    required this.selectedCells,
  });
  final int rows;
  final int columns;
  final String? Function(int, int) imageForCell;
  final Set<Cell> selectedCells;
  @override
  State<DragableGrid> createState() => _DragableGridState();
}

class _DragableGridState extends State<DragableGrid> {
  final double cellSize = 60.0;
  double _offsetX = 0.0;
  double _offsetY = 0.0;
  Offset _startDragOffset = Offset.zero;

  @override
  void initState() {
    print('initState');
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _centerGrid());
  }

  void _centerGrid() {
    final size = MediaQuery.sizeOf(context);
    final gridWidth = widget.columns * cellSize;
    final gridHeight = widget.rows * cellSize;

    setState(() {
      _offsetX = gridWidth < size.width ? -(size.width - gridWidth) / 2 : 0;
      _offsetY =
          gridHeight < size.height ? -(size.height - 120 - gridHeight) / 2 : 0;
    });
  }

  void _onPanStart(DragStartDetails details) {
    _startDragOffset = details.globalPosition;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final Offset delta = details.globalPosition - _startDragOffset;
    _startDragOffset = details.globalPosition;

    setState(() {
      _offsetX -= delta.dx;
      _offsetY -= delta.dy;
    });
  }

  void _onTapUp(TapUpDetails details) {
    final localPosition = details.localPosition;
    final int row = ((localPosition.dy + _offsetY) / cellSize).floor();
    final int column = ((localPosition.dx + _offsetX) / cellSize).floor();

    if (row >= 0 &&
        row < widget.rows &&
        column >= 0 &&
        column < widget.columns) {
      final imagen = widget.imageForCell(row, column);
      if (imagen == null) {
        return;
      }
      final cell = Cell(row, column, imagen);
      setState(() {
        if (widget.selectedCells
            .where(
              (c) => c.row == cell.row && c.column == cell.column,
            )
            .isNotEmpty) {
          widget.selectedCells.removeWhere(
            (c) => c.row == cell.row && c.column == cell.column,
          );
        } else {
          widget.selectedCells.add(cell);
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant DragableGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rows != widget.rows || oldWidget.columns != widget.columns) {
      _centerGrid();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onTapUp: _onTapUp,
      child: ClipRect(
        child: CustomPaint(
          size: MediaQuery.sizeOf(context),
          painter: GridPainter(
            rows: widget.rows,
            columns: widget.columns,
            cellSize: cellSize,
            offsetX: _offsetX,
            offsetY: _offsetY,
            selectedCells: widget.selectedCells,
          ),
        ),
      ),
    );
  }
}
