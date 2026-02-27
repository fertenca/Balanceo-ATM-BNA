import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../providers/app_providers.dart';

class SummaryScreen extends ConsumerStatefulWidget {
  const SummaryScreen({super.key});

  @override
  ConsumerState<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends ConsumerState<SummaryScreen> {
  final obs = TextEditingController();
  String? pdfPath;

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(appControllerProvider.notifier);
    final draft = controller.draft;

    return Scaffold(
      appBar: AppBar(title: const Text('Resumen y planilla')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ATM: ${draft.atm?.nombre ?? '-'}'),
            Text('Diferencia inicial: ${draft.ticketData?.diferencia.toStringAsFixed(2) ?? '0.00'}'),
            Text('Total ajustes: ${draft.ajustes.fold(0.0, (a, b) => a + b.monto).toStringAsFixed(2)}'),
            Text('Diferencia final: ${controller.diferenciaFinal.toStringAsFixed(2)}'),
            Text('Estado: ${controller.diferenciaFinal == 0 ? 'CONFORME' : 'NO CONFORME'}'),
            TextField(controller: obs, decoration: const InputDecoration(labelText: 'Observaciones (opcional)')),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () async {
                final path = await controller.saveBalanceoAndPdf(observaciones: obs.text.trim());
                setState(() => pdfPath = path);
              },
              child: const Text('Generar planilla XLSX y guardar'),
            ),
            if (pdfPath != null) ...[
              const SizedBox(height: 8),
              Text('Planilla: $pdfPath'),
              FilledButton(
                onPressed: () async => Share.shareXFiles([XFile(pdfPath!)]),
                child: const Text('Compartir planilla'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
