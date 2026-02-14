import 'ajuste.dart';
import 'ticket_data.dart';

class Balanceo {
  final String id;
  final String atmId;
  final DateTime fecha;
  final String? turno;
  final TicketData ticketData;
  final List<Ajuste> ajustes;
  final bool estadoConforme;
  final String? observaciones;
  final DateTime timestamp;

  const Balanceo({
    required this.id,
    required this.atmId,
    required this.fecha,
    this.turno,
    required this.ticketData,
    required this.ajustes,
    required this.estadoConforme,
    this.observaciones,
    required this.timestamp,
  });

  double get totalAjustes => ajustes.fold(0, (acc, e) => acc + e.monto);

  Map<String, dynamic> toJson() => {
        'id': id,
        'atmId': atmId,
        'fecha': fecha.toIso8601String(),
        'turno': turno,
        'ticketData': ticketData.toJson(),
        'ajustes': ajustes.map((e) => e.toJson()).toList(),
        'estadoConforme': estadoConforme,
        'observaciones': observaciones,
        'timestamp': timestamp.toIso8601String(),
      };

  factory Balanceo.fromJson(Map<String, dynamic> json) => Balanceo(
        id: json['id'] as String,
        atmId: json['atmId'] as String,
        fecha: DateTime.parse(json['fecha'] as String),
        turno: json['turno'] as String?,
        ticketData: TicketData.fromJson(Map<String, dynamic>.from(json['ticketData'])),
        ajustes: (json['ajustes'] as List)
            .map((e) => Ajuste.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        estadoConforme: json['estadoConforme'] as bool,
        observaciones: json['observaciones'] as String?,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}
