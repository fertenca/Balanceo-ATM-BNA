import 'package:flutter/material.dart';

import 'presentation/screens/config_screen.dart';

class BalanceoApp extends StatelessWidget {
  const BalanceoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Balanceo ATM BNA',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const ConfigScreen(),
    );
  }
}
