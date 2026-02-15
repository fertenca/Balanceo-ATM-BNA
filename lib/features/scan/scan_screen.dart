import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../review/review_screen.dart';
import '../shared/app_scope.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Escaneo de ticket')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              value: controller.selectedAtm?.id,
              decoration: const InputDecoration(labelText: 'Elegir ATM'),
              items: controller.config.atms
                  .map((atm) => DropdownMenuItem(value: atm.id, child: Text('${atm.nombre} (${atm.id})')))
                  .toList(),
              onChanged: (id) {
                final atm = controller.config.atms.where((e) => e.id == id).firstOrNull;
                controller.chooseAtm(atm);
              },
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () async {
                final file = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 85);
                if (file == null) return;
                controller.setTicketImage(File(file.path));
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Capturar foto ticket'),
            ),
            if (controller.ticketImage != null) Text('Imagen: ${controller.ticketImage!.path}'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: processing
                  ? null
                  : () async {
                      setState(() => processing = true);
                      await controller.runOcrAndParse();
                      if (!mounted) return;
                      setState(() => processing = false);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ReviewScreen()));
                    },
              child: Text(processing ? 'Procesando...' : 'Ejecutar OCR offline'),
            ),
          ],
        ),
      ),
    );
  }
}
