import '../../entities/ticket_data.dart';
import '../parser_ticket.dart';

class BnaBalanceRedParser implements ParserTicket {
  static final RegExp _cassetteRegex = RegExp(
    r'C([1-4])\s*(COM|DIS|FIN|INC|SAL)\s*([-+]?\d[\d\.,]*)',
    caseSensitive: false,
  );

  @override
  String get model => 'BNA_BALANCE_RED';

  @override
  double detectLayout(String ocrText) {
    final upper = ocrText.toUpperCase();
    double score = 0;

    if (upper.contains('BALANCE DE RED')) score += 0.5;
    if (upper.contains('BANCO NACION')) score += 0.2;
    if (upper.contains('NRO. DE TARJETA') || upper.contains('NRO DE TARJETA')) score += 0.1;
    if (_cassetteRegex.hasMatch(upper)) score += 0.2;

    return score.clamp(0, 1).toDouble();
  }

  @override
  ParseResult parse({required String ocrText, required String atmId}) {
    final upper = ocrText.toUpperCase();
    final buckets = <String, Map<String, double>>{};

    for (final m in _cassetteRegex.allMatches(upper)) {
      final cassette = 'C${m.group(1)}';
      final key = m.group(2)!.toUpperCase();
      final value = _parseAmount(m.group(3) ?? '0');
      buckets.putIfAbsent(cassette, () => {});
      buckets[cassette]![key] = value;
    }

    final totalPorGaveta = <String, double>{};
    for (final entry in buckets.entries) {
      final values = entry.value;
      final fin = values['FIN'];
      final computed = (values['INC'] ?? 0) - (values['SAL'] ?? 0);
      totalPorGaveta[entry.key] = fin ?? computed;
    }

    final totalEsperado = totalPorGaveta.values.fold<double>(0, (sum, value) => sum + value);
    final totalContado = totalEsperado;

    final atmCodeMatch = RegExp(r'CAJERO\s*([0-9]{3,})').firstMatch(upper);

    final ticket = TicketData(
      atmId: atmId,
      atmCode: atmCodeMatch?.group(1),
      totalEsperado: totalEsperado,
      totalContado: totalContado,
      diferencia: 0,
      totalPorGaveta: totalPorGaveta,
      rawText: ocrText,
      confidence: detectLayout(ocrText),
    );

    return ParseResult(ticketData: ticket, confidenceScores: {
      'layout': detectLayout(ocrText),
      'cassettes': totalPorGaveta.isNotEmpty ? 0.95 : 0.2,
      'totals': totalEsperado > 0 ? 0.95 : 0.2,
    });
  }

  double _parseAmount(String raw) {
    final sanitized = raw.replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(sanitized) ?? 0;
  }
}
