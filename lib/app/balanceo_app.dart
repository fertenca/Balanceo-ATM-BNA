import 'package:flutter/material.dart';

import '../features/config/config_screen.dart';

class BalanceoApp extends StatelessWidget {
  const BalanceoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Balanceo ATM',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const ConfigScreen(),
    );
  }
}
