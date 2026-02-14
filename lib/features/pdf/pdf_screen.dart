import 'dart:io';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../history/history_screen.dart';
import '../shared/app_scope.dart';

class PdfScreen extends StatefulWidget {
  const PdfScreen({super.key});

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  File? pdfFile;

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('PDF y compartir')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sucursal: ${controller.config.sucursalNombre}'),
            Text('ATM: ${controller.selectedAtm?.nombre ?? '-'}'),
            Text('Diferencia final: ${controller.diferenciaFinal}'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () async {
                final file = await controller.generatePdf();
                setState(() => pdfFile = file);
              },
              child: const Text('Generar PDF'),
            ),
            if (pdfFile != null) ...[
              const SizedBox(height: 8),
              Text('PDF generado: ${pdfFile!.path}'),
              FilledButton(
                onPressed: () async {
                  await Printing.sharePdf(bytes: await pdfFile!.readAsBytes(), filename: pdfFile!.path.split('/').last);
                },
                child: const Text('Enviar por email / compartir'),
              ),
            ],
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
              child: const Text('Ver historial local'),
            ),
          ],
        ),
      ),
    );
  }
}
