import 'parser_ticket.dart';

class ParserRegistry {
  final List<ParserTicket> parsers;

  const ParserRegistry(this.parsers);

  ParserTicket select(String text) {
    final ranked = [...parsers]..sort((a, b) => b.detectLayout(text).compareTo(a.detectLayout(text)));
    return ranked.first;
  }
}
