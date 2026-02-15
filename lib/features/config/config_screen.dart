import 'package:flutter/material.dart';

import '../../core/models/atm.dart';
import '../../core/models/config.dart';
import '../scan/scan_screen.dart';
import '../shared/app_scope.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  final nombreController = TextEditingController();
  final numeroController = TextEditingController();
  final emailController = TextEditingController();
  bool _syncedInitialValues = false;

  @override
  void dispose() {
    nombreController.dispose();
    numeroController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final atms = [...controller.config.atms];

    if (!_syncedInitialValues) {
      nombreController.text = controller.config.sucursalNombre;
      numeroController.text = controller.config.sucursalNumero;
      emailController.text = controller.config.emailUsuario;
      _syncedInitialValues = true;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: nombreController, decoration: const InputDecoration(labelText: 'Sucursal nombre')),
            TextField(controller: numeroController, decoration: const InputDecoration(labelText: 'Sucursal número')),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email usuario')),
            const SizedBox(height: 12),
            Row(
              children: [
                const Expanded(child: Text('ATMs')),
                IconButton(
                  onPressed: () async {
                    final atm = await _showAtmDialog(context);
                    if (atm == null) return;
                    await controller.saveConfig(
                      Config(
                        sucursalNombre: nombreController.text.trim(),
                        sucursalNumero: numeroController.text.trim(),
                        emailUsuario: emailController.text.trim(),
                        atms: [...atms, atm],
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            ...atms.map((e) => ListTile(title: Text(e.nombre), subtitle: Text('ID ATM: ${e.id}'))),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () async {
                await controller.saveConfig(
                  Config(
                    sucursalNombre: nombreController.text.trim(),
                    sucursalNumero: numeroController.text.trim(),
                    emailUsuario: emailController.text.trim(),
                    atms: atms,
                  ),
                );
                if (!context.mounted) return;
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ScanScreen()));
              },
              child: const Text('Guardar y continuar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<ATM?> _showAtmDialog(BuildContext context) async {
    final id = TextEditingController();
    final nombre = TextEditingController();
    return showDialog<ATM>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nuevo ATM'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: id, decoration: const InputDecoration(labelText: 'ID ATM')),
            TextField(controller: nombre, decoration: const InputDecoration(labelText: 'Nombre ATM')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () => Navigator.pop(context, ATM(id: id.text.trim(), nombre: nombre.text.trim())),
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}
