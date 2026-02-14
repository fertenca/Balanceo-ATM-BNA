class TicketData {
  final String atmId;
  final String? atmCode;
  final double totalEsperado;
  final double totalContado;
  final double diferencia;
  final Map<String, double> totalPorGaveta;
  final String rawText;
  final double confidence;

  const TicketData({
    required this.atmId,
    this.atmCode,
    required this.totalEsperado,
    required this.totalContado,
    required this.diferencia,
    required this.totalPorGaveta,
    required this.rawText,
    required this.confidence,
  });

  Map<String, dynamic> toJson() => {
        'atmId': atmId,
        'atmCode': atmCode,
        'totalEsperado': totalEsperado,
        'totalContado': totalContado,
        'diferencia': diferencia,
        'totalPorGaveta': totalPorGaveta,
        'rawText': rawText,
        'confidence': confidence,
      };

  factory TicketData.fromJson(Map<String, dynamic> json) => TicketData(
        atmId: json['atmId'] as String? ?? '',
        atmCode: json['atmCode'] as String?,
        totalEsperado: (json['totalEsperado'] as num?)?.toDouble() ?? 0,
        totalContado: (json['totalContado'] as num?)?.toDouble() ?? 0,
        diferencia: (json['diferencia'] as num?)?.toDouble() ?? 0,
        totalPorGaveta: Map<String, double>.from(
          (json['totalPorGaveta'] as Map? ?? {})
              .map((k, v) => MapEntry(k.toString(), (v as num).toDouble())),
        ),
        rawText: json['rawText'] as String? ?? '',
        confidence: (json['confidence'] as num?)?.toDouble() ?? 0,
      );

  TicketData copyWith({
    String? atmId,
    String? atmCode,
    double? totalEsperado,
    double? totalContado,
    double? diferencia,
    Map<String, double>? totalPorGaveta,
    String? rawText,
    double? confidence,
  }) {
    return TicketData(
      atmId: atmId ?? this.atmId,
      atmCode: atmCode ?? this.atmCode,
      totalEsperado: totalEsperado ?? this.totalEsperado,
      totalContado: totalContado ?? this.totalContado,
      diferencia: diferencia ?? this.diferencia,
      totalPorGaveta: totalPorGaveta ?? this.totalPorGaveta,
      rawText: rawText ?? this.rawText,
      confidence: confidence ?? this.confidence,
    );
  }
}
