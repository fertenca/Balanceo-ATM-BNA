import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_constants.dart';
import '../providers/app_providers.dart';
import '../widgets/capture_guide_overlay.dart';
import 'review_ticket_screen.dart';

class NewBalanceoScreen extends ConsumerStatefulWidget {
  const NewBalanceoScreen({super.key});

  @override
  ConsumerState<NewBalanceoScreen> createState() => _NewBalanceoScreenState();
}

class _NewBalanceoScreenState extends ConsumerState<NewBalanceoScreen> {
  DateTime fecha = DateTime.now();
  String? turno;
  String? atmId;

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appControllerProvider).value;
    final controller = ref.read(appControllerProvider.notifier);
    final draft = controller.draft;

    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo balanceo')),
      body: config == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  DropdownButtonFormField<String>(
                    value: atmId,
                    decoration: const InputDecoration(labelText: 'ATM'),
                    items: config.atms
                        .map((e) => DropdownMenuItem(value: e.id, child: Text('${e.nombre} (${e.modelo})')))
                        .toList(),
                    onChanged: (v) => setState(() => atmId = v),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Fecha: ${DateFormat('yyyy-MM-dd').format(fecha)}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                        initialDate: fecha,
                      );
                      if (picked != null) setState(() => fecha = picked);
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: turno,
                    decoration: const InputDecoration(labelText: 'Turno (opcional)'),
                    items: AppConstants.turnos.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => setState(() => turno = v),
                  ),
                  const SizedBox(height: 12),
                  const CaptureGuideOverlay(),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () async {
                      final atm = config.atms.firstWhere((e) => e.id == atmId);
                      controller.startDraft(atm: atm, fecha: fecha, turno: turno);
                      await controller.captureImage();
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Imagen capturada.')));
                      setState(() {});
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Capturar ticket'),
                  ),
                  if (draft.image != null) Text('Imagen: ${draft.image!.path}'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: draft.image == null
                        ? null
                        : () async {
                            await controller.runOcr();
                            if (!mounted) return;
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const ReviewTicketScreen()));
                          },
                    child: const Text('Procesar OCR offline'),
                  ),
                ],
              ),
            ),
    );
  }
}
