import 'atm.dart';

class Config {
  final String sucursalNombre;
  final String sucursalNumero;
  final String emailUsuario;
  final List<ATM> atms;

  const Config({
    required this.sucursalNombre,
    required this.sucursalNumero,
    required this.emailUsuario,
    required this.atms,
  });

  factory Config.empty() => const Config(
        sucursalNombre: '',
        sucursalNumero: '',
        emailUsuario: '',
        atms: [],
      );

  Map<String, dynamic> toJson() => {
        'sucursalNombre': sucursalNombre,
        'sucursalNumero': sucursalNumero,
        'emailUsuario': emailUsuario,
        'atms': atms.map((e) => e.toJson()).toList(),
      };

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      sucursalNombre: json['sucursalNombre']?.toString() ?? '',
      sucursalNumero: json['sucursalNumero']?.toString() ?? '',
      emailUsuario: json['emailUsuario']?.toString() ?? '',
      atms: (json['atms'] as List<dynamic>? ?? const [])
          .map((e) => ATM.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }
}
