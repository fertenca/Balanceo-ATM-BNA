class Ajuste {
  final String gaveta;
  final int denominacion;
  final int cantidadBilletes;

  const Ajuste({
    required this.gaveta,
    required this.denominacion,
    required this.cantidadBilletes,
  });

  int get monto => denominacion * cantidadBilletes;

  Map<String, dynamic> toJson() => {
        'gaveta': gaveta,
        'denominacion': denominacion,
        'cantidadBilletes': cantidadBilletes,
      };

  factory Ajuste.fromJson(Map<String, dynamic> json) {
    return Ajuste(
      gaveta: json['gaveta']?.toString() ?? '',
      denominacion: (json['denominacion'] as num?)?.toInt() ?? 0,
      cantidadBilletes: (json['cantidadBilletes'] as num?)?.toInt() ?? 0,
    );
  }
}
