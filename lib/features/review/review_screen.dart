import 'package:flutter/material.dart';

import '../../core/models/ticket_data.dart';
import '../adjustments/adjustments_screen.dart';
import '../shared/app_scope.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final totalTicket = TextEditingController();
  final totalContado = TextEditingController();
  final diferencia = TextEditingController();
  final rawText = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ticket = AppScope.of(context).ticketData;
    totalTicket.text = ticket.totalTicket;
    totalContado.text = ticket.totalContado;
    diferencia.text = ticket.diferencia;
    rawText.text = ticket.textoOriginal;
  }


  @override
  void dispose() {
    totalTicket.dispose();
    totalContado.dispose();
    diferencia.dispose();
    rawText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Revisión OCR')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: totalTicket, decoration: const InputDecoration(labelText: 'Total ticket')),
            TextField(controller: totalContado, decoration: const InputDecoration(labelText: 'Total contado')),
            TextField(controller: diferencia, decoration: const InputDecoration(labelText: 'Diferencia')),
            TextField(controller: rawText, maxLines: 8, decoration: const InputDecoration(labelText: 'Texto OCR editable')),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                controller.updateTicketData(
                  TicketData(
                    textoOriginal: rawText.text,
                    totalTicket: totalTicket.text,
                    totalContado: totalContado.text,
                    diferencia: diferencia.text,
                    camposExtraidos: {
                      'totalTicket': totalTicket.text,
                      'totalContado': totalContado.text,
                      'diferencia': diferencia.text,
                    },
                  ),
                );
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AdjustmentsScreen()));
              },
              child: const Text('Continuar a ajustes'),
            ),
          ],
        ),
      ),
    );
  }
}
