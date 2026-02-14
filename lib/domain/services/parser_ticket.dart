import '../entities/ticket_data.dart';

class ParseResult {
  final TicketData ticketData;
  final Map<String, double> confidenceScores;

  const ParseResult({
    required this.ticketData,
    required this.confidenceScores,
  });
}

abstract class ParserTicket {
  String get model;
  double detectLayout(String ocrText);
  ParseResult parse({required String ocrText, required String atmId});
}
