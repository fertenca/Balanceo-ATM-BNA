class TicketData {
  final String textoOriginal;
  final String totalTicket;
  final String totalContado;
  final String diferencia;
  final Map<String, String> camposExtraidos;

  const TicketData({
    required this.textoOriginal,
    required this.totalTicket,
    required this.totalContado,
    required this.diferencia,
    required this.camposExtraidos,
  });

  factory TicketData.empty() => const TicketData(
        textoOriginal: '',
        totalTicket: '0',
        totalContado: '0',
        diferencia: '0',
        camposExtraidos: {},
      );

  TicketData copyWith({
    String? textoOriginal,
    String? totalTicket,
    String? totalContado,
    String? diferencia,
    Map<String, String>? camposExtraidos,
  }) {
    return TicketData(
      textoOriginal: textoOriginal ?? this.textoOriginal,
      totalTicket: totalTicket ?? this.totalTicket,
      totalContado: totalContado ?? this.totalContado,
      diferencia: diferencia ?? this.diferencia,
      camposExtraidos: camposExtraidos ?? this.camposExtraidos,
    );
  }

  Map<String, dynamic> toJson() => {
        'textoOriginal': textoOriginal,
        'totalTicket': totalTicket,
        'totalContado': totalContado,
        'diferencia': diferencia,
        'camposExtraidos': camposExtraidos,
      };

  factory TicketData.fromJson(Map<String, dynamic> json) {
    return TicketData(
      textoOriginal: json['textoOriginal']?.toString() ?? '',
      totalTicket: json['totalTicket']?.toString() ?? '0',
      totalContado: json['totalContado']?.toString() ?? '0',
      diferencia: json['diferencia']?.toString() ?? '0',
      camposExtraidos: Map<String, String>.from(
        (json['camposExtraidos'] as Map?)?.map(
              (key, value) => MapEntry(key.toString(), value.toString()),
            ) ??
            const {},
      ),
    );
  }
}
