class Ajuste {
  final String gaveta;
  final int denominacion;
  final int cantidadBilletes;

  const Ajuste({
    required this.gaveta,
    required this.denominacion,
    required this.cantidadBilletes,
  });

  double get monto => denominacion * cantidadBilletes.toDouble();

  Map<String, dynamic> toJson() => {
        'gaveta': gaveta,
        'denominacion': denominacion,
        'cantidadBilletes': cantidadBilletes,
      };

  factory Ajuste.fromJson(Map<String, dynamic> json) => Ajuste(
        gaveta: json['gaveta'] as String,
        denominacion: json['denominacion'] as int,
        cantidadBilletes: json['cantidadBilletes'] as int,
      );
}
