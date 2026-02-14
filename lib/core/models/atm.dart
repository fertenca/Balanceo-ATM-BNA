class ATM {
  final String id;
  final String nombre;

  const ATM({required this.id, required this.nombre});

  Map<String, dynamic> toJson() => {'id': id, 'nombre': nombre};

  factory ATM.fromJson(Map<String, dynamic> json) {
    return ATM(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
    );
  }
}
