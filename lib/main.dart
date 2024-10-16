import 'package:flutter/material.dart';
import 'package:proyecto_ia/screens/config_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proyecto IA',
      home: const ConfigScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
