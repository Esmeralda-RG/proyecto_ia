import 'package:flutter/material.dart';
import 'package:proyecto_ia/screens/config_screen.dart';
import 'package:proyecto_ia/provider/config_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ConfigurationProvider(
      child: MaterialApp(
        title: 'Proyecto IA',
        home: ConfigScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
