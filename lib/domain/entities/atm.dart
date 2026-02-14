class ATM {
  final String id;
  final String nombre;
  final String modelo;
  final List<String> gavetas;
  final List<int> denominacionesPermitidas;

  const ATM({
    required this.id,
    required this.nombre,
    required this.modelo,
    required this.gavetas,
    required this.denominacionesPermitidas,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'modelo': modelo,
        'gavetas': gavetas,
        'denominacionesPermitidas': denominacionesPermitidas,
      };

  factory ATM.fromJson(Map<String, dynamic> json) => ATM(
        id: json['id'] as String,
        nombre: json['nombre'] as String,
        modelo: json['modelo'] as String,
        gavetas: List<String>.from(json['gavetas'] as List),
        denominacionesPermitidas:
            List<int>.from(json['denominacionesPermitidas'] as List),
      );
}
