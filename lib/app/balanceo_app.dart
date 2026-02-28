import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../features/config/config_screen.dart';

class BalanceoApp extends StatelessWidget {
  const BalanceoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.bnaBlue,
      brightness: Brightness.light,
      primary: AppColors.bnaBlue,
      secondary: AppColors.bnaYellow,
    );

    return MaterialApp(
      title: 'Balanceo ATM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: AppColors.bnaBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.bnaBlue,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const ConfigScreen(),
    );
  }
}
