import 'package:flutter/material.dart';

import '../../core/models/ajuste.dart';
import '../pdf/pdf_screen.dart';
import '../shared/app_scope.dart';

class AdjustmentsScreen extends StatelessWidget {
  const AdjustmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes por gaveta')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Diferencia ticket: ${controller.ticketData.diferencia}'),
            Expanded(
              child: ListView(
                children: controller.ajustes
                    .map((a) => ListTile(
                          title: Text('Gaveta ${a.gaveta}'),
                          subtitle: Text('${a.denominacion} x ${a.cantidadBilletes}'),
                          trailing: Text(a.monto.toString()),
                        ))
                    .toList(),
              ),
            ),
            FilledButton.icon(
              onPressed: () async {
                final ajuste = await _showAjusteDialog(context);
                if (ajuste != null) controller.addAjuste(ajuste);
              },
              icon: const Icon(Icons.add),
              label: const Text('Agregar gaveta'),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PdfScreen())),
              child: const Text('Generar planilla PDF'),
            ),
          ],
        ),
      ),
    );
  }

  Future<Ajuste?> _showAjusteDialog(BuildContext context) {
    final gaveta = TextEditingController();
    final denominacion = TextEditingController();
    final cantidad = TextEditingController();

    return showDialog<Ajuste>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nuevo ajuste'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: gaveta, decoration: const InputDecoration(labelText: 'Gaveta')),
            TextField(controller: denominacion, decoration: const InputDecoration(labelText: 'Denominación')),
            TextField(controller: cantidad, decoration: const InputDecoration(labelText: 'Cantidad billetes')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () {
              Navigator.pop(
                context,
                Ajuste(
                  gaveta: gaveta.text.trim(),
                  denominacion: int.tryParse(denominacion.text) ?? 0,
                  cantidadBilletes: int.tryParse(cantidad.text) ?? 0,
                ),
              );
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}
