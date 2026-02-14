import 'package:flutter/material.dart';

import '../../domain/entities/ajuste.dart';
import '../../domain/entities/atm.dart';

class AjusteForm extends StatefulWidget {
  final ATM atm;
  const AjusteForm({super.key, required this.atm});

  @override
  State<AjusteForm> createState() => _AjusteFormState();
}

class _AjusteFormState extends State<AjusteForm> {
  String? gaveta;
  int? denom;
  final cantidad = TextEditingController(text: '0');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar ajuste'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: gaveta,
            decoration: const InputDecoration(labelText: 'Gaveta'),
            items: widget.atm.gavetas.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) => setState(() => gaveta = v),
          ),
          DropdownButtonFormField<int>(
            value: denom,
            decoration: const InputDecoration(labelText: 'Denominación'),
            items: widget.atm.denominacionesPermitidas
                .map((e) => DropdownMenuItem(value: e, child: Text('\$$e')))
                .toList(),
            onChanged: (v) => setState(() => denom = v),
          ),
          TextField(
            controller: cantidad,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Cantidad billetes (+/-)'),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        FilledButton(
          onPressed: () {
            if (gaveta == null || denom == null) return;
            Navigator.pop(
              context,
              Ajuste(
                gaveta: gaveta!,
                denominacion: denom!,
                cantidadBilletes: int.tryParse(cantidad.text) ?? 0,
              ),
            );
          },
          child: const Text('Agregar'),
        ),
      ],
    );
  }
}
