import '../../../core/utils/text_normalizer.dart';
import '../../entities/ticket_data.dart';
import '../parser_ticket.dart';

class DieboldParser implements ParserTicket {
  @override
  String get model => 'DIEBOLD';

  @override
  double detectLayout(String ocrText) {
    final normalized = TextNormalizer.normalize(ocrText);
    double score = 0;
    if (normalized.contains('DIEBOLD')) score += 0.5;
    if (normalized.contains('CASSET')) score += 0.2;
    if (normalized.contains('EXPECTED')) score += 0.2;
    if (normalized.contains('DIFF')) score += 0.1;
    return score;
  }

  @override
  ParseResult parse({required String ocrText, required String atmId}) {
    final normalized = TextNormalizer.normalize(ocrText);
    final esperado = TextNormalizer.extractAmount(normalized, RegExp(r'EXPECTED\s*[:=]?\s*([\d\.,]+)'));
    final contado = TextNormalizer.extractAmount(normalized, RegExp(r'COUNTED\s*[:=]?\s*([\d\.,]+)'));
    final diferencia = TextNormalizer.extractAmount(normalized, RegExp(r'DIFF\s*[:=]?\s*([\-\d\.,]+)'));

    final ticket = TicketData(
      atmId: atmId,
      totalEsperado: esperado,
      totalContado: contado,
      diferencia: diferencia == 0 ? contado - esperado : diferencia,
      totalPorGaveta: {},
      rawText: ocrText,
      confidence: 0.8,
    );

    return ParseResult(ticketData: ticket, confidenceScores: {
      'layout': detectLayout(ocrText),
      'totals': esperado > 0 || contado > 0 ? 0.85 : 0.3,
      'difference': 0.75,
    });
  }
}
