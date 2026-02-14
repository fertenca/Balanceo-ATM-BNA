import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../shared/app_scope.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = AppScope.of(context).history.reversed.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Historial local')),
      body: history.isEmpty
          ? const Center(child: Text('Sin balanceos guardados'))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return ListTile(
                  title: Text('ATM ${item.atmId} - ${DateFormat('yyyy-MM-dd HH:mm').format(item.timestamp)}'),
                  subtitle: Text('Diferencia final: ${item.diferenciaFinal}'),
                );
              },
            ),
    );
  }
}
