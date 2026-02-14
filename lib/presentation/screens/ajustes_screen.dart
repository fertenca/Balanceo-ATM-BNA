import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import '../widgets/ajuste_form.dart';
import 'summary_screen.dart';

class AjustesScreen extends ConsumerWidget {
  const AjustesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(appControllerProvider.notifier);
    final draft = controller.draft;

    return Scaffold(
      appBar: AppBar(title: const Text('Diferencias por gaveta')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Diferencia ticket: ${draft.ticketData?.diferencia.toStringAsFixed(2) ?? '0.00'}'),
            Expanded(
              child: ListView(
                children: draft.ajustes
                    .map((a) => ListTile(
                          title: Text('Gaveta ${a.gaveta} - $${a.denominacion} x ${a.cantidadBilletes}'),
                          trailing: Text(a.monto.toStringAsFixed(2)),
                        ))
                    .toList(),
              ),
            ),
            FilledButton.icon(
              onPressed: () async {
                final ajuste = await showDialog(context: context, builder: (_) => AjusteForm(atm: draft.atm!));
                if (ajuste != null) {
                  controller.addAjuste(ajuste);
                  (context as Element).markNeedsBuild();
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Agregar ajuste'),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SummaryScreen())),
              child: const Text('Ver resumen final'),
            ),
          ],
        ),
      ),
    );
  }
}
