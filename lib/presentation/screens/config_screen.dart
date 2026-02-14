import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/config.dart';
import '../providers/app_providers.dart';
import '../widgets/atm_form_dialog.dart';
import 'new_balanceo_screen.dart';

class ConfigScreen extends ConsumerStatefulWidget {
  const ConfigScreen({super.key});

  @override
  ConsumerState<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends ConsumerState<ConfigScreen> {
  final _nombre = TextEditingController();
  final _numero = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Config inicial')),
      body: state.when(
        data: (config) {
          _nombre.text = config.sucursalNombre;
          _numero.text = config.sucursalNumero;
          final atms = [...config.atms];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                TextField(controller: _nombre, decoration: const InputDecoration(labelText: 'Sucursal nombre')),
                TextField(controller: _numero, decoration: const InputDecoration(labelText: 'Sucursal número')),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('ATMs', style: TextStyle(fontWeight: FontWeight.bold)),
                    IconButton(
                      onPressed: () async {
                        final atm = await showDialog(context: context, builder: (_) => const AtmFormDialog());
                        if (atm != null) {
                          atms.add(atm);
                          await ref.read(appControllerProvider.notifier).saveConfig(
                                Config(
                                  sucursalNombre: _nombre.text,
                                  sucursalNumero: _numero.text,
                                  atms: atms,
                                ),
                              );
                        }
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                ...atms.map((e) => ListTile(title: Text('${e.nombre} (${e.id})'), subtitle: Text('Modelo: ${e.modelo}'))),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () async {
                    await ref.read(appControllerProvider.notifier).saveConfig(
                          Config(
                            sucursalNombre: _nombre.text,
                            sucursalNumero: _numero.text,
                            atms: atms,
                          ),
                        );
                    if (!mounted) return;
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const NewBalanceoScreen()));
                  },
                  child: const Text('Continuar a nuevo balanceo'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
