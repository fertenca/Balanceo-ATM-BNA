import '../../../core/utils/text_normalizer.dart';
import '../../entities/ticket_data.dart';
import '../parser_ticket.dart';

class NcrParser implements ParserTicket {
  @override
  String get model => 'NCR';

  @override
  double detectLayout(String ocrText) {
    final normalized = TextNormalizer.normalize(ocrText);
    double score = 0;
    if (normalized.contains('NCR')) score += 0.4;
    if (normalized.contains('CASSETTE')) score += 0.2;
    if (normalized.contains('TOTAL ESPERADO')) score += 0.2;
    if (normalized.contains('DIFERENCIA')) score += 0.2;
    return score;
  }

  @override
  ParseResult parse({required String ocrText, required String atmId}) {
    final normalized = TextNormalizer.normalize(ocrText);
    final esperado = TextNormalizer.extractAmount(normalized, RegExp(r'TOTAL ESPERADO\s*[:=]?\s*([\d\.,]+)'));
    final contado = TextNormalizer.extractAmount(normalized, RegExp(r'TOTAL CONTADO\s*[:=]?\s*([\d\.,]+)'));
    final diferencia = TextNormalizer.extractAmount(normalized, RegExp(r'DIFERENCIA\s*[:=]?\s*([\-\d\.,]+)'));

    final ticket = TicketData(
      atmId: atmId,
      totalEsperado: esperado,
      totalContado: contado,
      diferencia: diferencia == 0 ? contado - esperado : diferencia,
      totalPorGaveta: {},
      rawText: ocrText,
      confidence: 0.85,
    );

    return ParseResult(ticketData: ticket, confidenceScores: {
      'layout': detectLayout(ocrText),
      'totals': esperado > 0 || contado > 0 ? 0.9 : 0.3,
      'difference': 0.8,
    });
  }
}
