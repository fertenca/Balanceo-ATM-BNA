import 'ajuste.dart';
import 'ticket_data.dart';

class Balanceo {
  final String id;
  final String atmId;
  final DateTime fecha;
  final TicketData ticketData;
  final List<Ajuste> ajustes;
  final DateTime timestamp;

  const Balanceo({
    required this.id,
    required this.atmId,
    required this.fecha,
    required this.ticketData,
    required this.ajustes,
    required this.timestamp,
  });

  int get totalAjustes => ajustes.fold(0, (acc, item) => acc + item.monto);

  int get diferenciaTicket => int.tryParse(ticketData.diferencia) ?? 0;

  int get diferenciaFinal => diferenciaTicket + totalAjustes;

  Map<String, dynamic> toJson() => {
        'id': id,
        'atmId': atmId,
        'fecha': fecha.toIso8601String(),
        'ticketData': ticketData.toJson(),
        'ajustes': ajustes.map((e) => e.toJson()).toList(),
        'timestamp': timestamp.toIso8601String(),
      };

  factory Balanceo.fromJson(Map<String, dynamic> json) {
    return Balanceo(
      id: json['id']?.toString() ?? '',
      atmId: json['atmId']?.toString() ?? '',
      fecha: DateTime.parse(json['fecha']?.toString() ?? DateTime.now().toIso8601String()),
      ticketData: TicketData.fromJson(Map<String, dynamic>.from(json['ticketData'] as Map? ?? const {})),
      ajustes: (json['ajustes'] as List<dynamic>? ?? const [])
          .map((e) => Ajuste.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      timestamp: DateTime.parse(json['timestamp']?.toString() ?? DateTime.now().toIso8601String()),
    );
  }
}
