import 'package:flutter/material.dart';
import 'package:proyecto_ia/models/cell.dart';
import 'package:proyecto_ia/provider/config_provider.dart';
import 'package:proyecto_ia/widgets/custom_button.dart';

class ConfigCellTypeWidget extends StatelessWidget {
  const ConfigCellTypeWidget(
      {super.key, required this.cellType, required this.onCellTypeChanged});
  final CellType cellType;
  final ValueChanged<CellType> onCellTypeChanged;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final configState = ConfigurationProvider.of(context);
    final initialPositionNotifier = configState.initialPositionNotifier;
    final goalPositionNotifier = configState.goalPositionNotifier;
    return SizedBox(
      width: size.width * .8,
      height: (size.height - 60) * .2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Selecciona el tipo de celda',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ValueListenableBuilder(
                valueListenable: initialPositionNotifier,
                builder: (context, value, _) {
                  return CustomButton(
                    text: 'Ratón Jones',
                    imagen: 'assets/imgs/mouse.png',
                    onPressed: value != null
                        ? null
                        : () {
                            onCellTypeChanged(CellType.initial);
                          },
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: goalPositionNotifier,
                builder: (context, value, _) {
                  return CustomButton(
                    text: 'Queso',
                    imagen: 'assets/imgs/cheese.png',
                    onPressed: value != null
                        ? null
                        : () {
                            onCellTypeChanged(CellType.goal);
                          },
                  );
                },
              ),
              CustomButton(
                text: 'Muro',
                imagen: 'assets/imgs/wall.png',
                onPressed: () {
                  onCellTypeChanged(CellType.wall);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
