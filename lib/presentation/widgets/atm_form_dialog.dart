import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/atm.dart';

class AtmFormDialog extends StatefulWidget {
  const AtmFormDialog({super.key});

  @override
  State<AtmFormDialog> createState() => _AtmFormDialogState();
}

class _AtmFormDialogState extends State<AtmFormDialog> {
  final _id = TextEditingController();
  final _nombre = TextEditingController();
  String _modelo = AppConstants.atmModelos.first;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuevo ATM'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(controller: _id, decoration: const InputDecoration(labelText: 'ID ATM')),
            TextField(controller: _nombre, decoration: const InputDecoration(labelText: 'Nombre ATM')),
            DropdownButtonFormField(
              value: _modelo,
              items: AppConstants.atmModelos
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _modelo = v!),
              decoration: const InputDecoration(labelText: 'Modelo/Layout'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        FilledButton(
          onPressed: () {
            Navigator.pop(
              context,
              ATM(
                id: _id.text.trim(),
                nombre: _nombre.text.trim(),
                modelo: _modelo,
                gavetas: const ['A', 'B', 'C', 'D'],
                denominacionesPermitidas: const [1000, 2000, 10000],
              ),
            );
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
