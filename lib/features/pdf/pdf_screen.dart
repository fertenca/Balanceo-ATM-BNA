import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

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
      appBar: AppBar(title: const Text('Planilla XLSX y compartir')),
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
              child: const Text('Generar planilla XLSX'),
            ),
            if (pdfFile != null) ...[
              const SizedBox(height: 8),
              Text('Planilla generada: ${pdfFile!.path}'),
              FilledButton(
                onPressed: () async {
                  await Share.shareXFiles([XFile(pdfFile!.path)]);
                },
                child: const Text('Enviar por email / compartir planilla'),
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
