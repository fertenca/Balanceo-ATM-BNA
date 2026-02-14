import 'atm.dart';

class Config {
  final String sucursalNombre;
  final String sucursalNumero;
  final List<ATM> atms;

  const Config({
    required this.sucursalNombre,
    required this.sucursalNumero,
    required this.atms,
  });

  factory Config.empty() => const Config(
        sucursalNombre: '',
        sucursalNumero: '',
        atms: [],
      );

  Map<String, dynamic> toJson() => {
        'sucursalNombre': sucursalNombre,
        'sucursalNumero': sucursalNumero,
        'atms': atms.map((e) => e.toJson()).toList(),
      };

  factory Config.fromJson(Map<String, dynamic> json) => Config(
        sucursalNombre: json['sucursalNombre'] as String? ?? '',
        sucursalNumero: json['sucursalNumero'] as String? ?? '',
        atms: (json['atms'] as List? ?? [])
            .map((e) => ATM.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );
}
