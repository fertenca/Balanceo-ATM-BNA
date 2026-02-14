import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/ticket_data.dart';
import '../providers/app_providers.dart';
import 'ajustes_screen.dart';

class ReviewTicketScreen extends ConsumerStatefulWidget {
  const ReviewTicketScreen({super.key});

  @override
  ConsumerState<ReviewTicketScreen> createState() => _ReviewTicketScreenState();
}

class _ReviewTicketScreenState extends ConsumerState<ReviewTicketScreen> {
  late final TextEditingController esperado;
  late final TextEditingController contado;
  late final TextEditingController diferencia;

  @override
  void initState() {
    super.initState();
    final t = ref.read(appControllerProvider.notifier).draft.ticketData!;
    esperado = TextEditingController(text: t.totalEsperado.toString());
    contado = TextEditingController(text: t.totalContado.toString());
    diferencia = TextEditingController(text: t.diferencia.toString());
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(appControllerProvider.notifier);
    final current = controller.draft.ticketData!;

    return Scaffold(
      appBar: AppBar(title: const Text('Revisar y corregir OCR')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: esperado, decoration: const InputDecoration(labelText: 'Total esperado')),
            TextField(controller: contado, decoration: const InputDecoration(labelText: 'Total contado')),
            TextField(controller: diferencia, decoration: const InputDecoration(labelText: 'Diferencia')),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                controller.updateTicketData(
                  TicketData(
                    atmId: current.atmId,
                    totalEsperado: double.tryParse(esperado.text) ?? 0,
                    totalContado: double.tryParse(contado.text) ?? 0,
                    diferencia: double.tryParse(diferencia.text) ?? 0,
                    totalPorGaveta: current.totalPorGaveta,
                    rawText: current.rawText,
                    confidence: current.confidence,
                  ),
                );
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AjustesScreen()));
              },
              child: const Text('Continuar a ajustes'),
            ),
          ],
        ),
      ),
    );
  }
}
