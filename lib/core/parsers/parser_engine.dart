import '../models/ticket_data.dart';
import 'generic_ticket_parser.dart';
import 'ticket_parser.dart';

class ParserEngine {
  ParserEngine({List<TicketParser>? parsers}) : _parsers = parsers ?? [GenericTicketParser()];

  final List<TicketParser> _parsers;

  TicketData parse(String rawText) {
    var bestConfidence = -1.0;
    TicketParser? bestParser;

    for (final parser in _parsers) {
      final value = parser.confidence(rawText);
      if (value > bestConfidence) {
        bestConfidence = value;
        bestParser = parser;
      }
    }

    return (bestParser ?? GenericTicketParser()).parse(rawText);
  }
}
