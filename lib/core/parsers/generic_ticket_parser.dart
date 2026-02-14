import 'ticket_parser.dart';
import '../models/ticket_data.dart';

class GenericTicketParser implements TicketParser {
  static final _numberRegex = RegExp(r'[-+]?\d+[\.,]?\d*');

  @override
  TicketData parse(String rawText) {
    final normalized = rawText.replaceAll('.', '').replaceAll(',', '.');

    final totalTicket = _extractByLabel(normalized, ['total ticket', 'esperado']) ?? _firstNumber(normalized) ?? '0';
    final totalContado = _extractByLabel(normalized, ['total contado', 'contado']) ?? '0';
    final diferencia = _extractByLabel(normalized, ['diferencia']) ?? '0';

    return TicketData(
      textoOriginal: rawText,
      totalTicket: totalTicket,
      totalContado: totalContado,
      diferencia: diferencia,
      camposExtraidos: {
        'totalTicket': totalTicket,
        'totalContado': totalContado,
        'diferencia': diferencia,
      },
    );
  }

  @override
  double confidence(String rawText) {
    final lower = rawText.toLowerCase();
    var score = 0.2;
    if (lower.contains('total')) score += 0.2;
    if (lower.contains('contado')) score += 0.3;
    if (lower.contains('diferencia')) score += 0.3;
    return score.clamp(0, 1).toDouble();
  }

  String? _extractByLabel(String text, List<String> labels) {
    final lower = text.toLowerCase();
    for (final label in labels) {
      final idx = lower.indexOf(label);
      if (idx < 0) continue;
      final snippet = text.substring(idx, (idx + 50).clamp(0, text.length));
      final match = _numberRegex.firstMatch(snippet);
      if (match != null) return match.group(0);
    }
    return null;
  }

  String? _firstNumber(String text) => _numberRegex.firstMatch(text)?.group(0);
}
