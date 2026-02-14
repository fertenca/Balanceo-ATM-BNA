import '../../../core/utils/text_normalizer.dart';
import '../../entities/ticket_data.dart';
import '../parser_ticket.dart';

class GenericParser implements ParserTicket {
  @override
  String get model => 'GENERIC';

  @override
  double detectLayout(String ocrText) => 0.1;

  @override
  ParseResult parse({required String ocrText, required String atmId}) {
    final normalized = TextNormalizer.normalize(ocrText);
    final total = TextNormalizer.extractAmount(normalized, RegExp(r'TOTAL\s*[:=]?\s*([\d\.,]+)'));
    final diffMatch = RegExp(r'(?:DIFERENCIA|DIFF)\s*[:=]?\s*([\-\d\.,]+)').firstMatch(normalized);
    final diff = double.tryParse((diffMatch?.group(1) ?? '0').replaceAll('.', '').replaceAll(',', '.')) ?? 0;

    final ticket = TicketData(
      atmId: atmId,
      totalEsperado: total,
      totalContado: total,
      diferencia: diff,
      totalPorGaveta: {},
      rawText: ocrText,
      confidence: 0.5,
    );

    return ParseResult(ticketData: ticket, confidenceScores: {
      'layout': 0.2,
      'totals': total > 0 ? 0.6 : 0.2,
      'difference': 0.5,
    });
  }
}
