import '../models/ticket_data.dart';

abstract class TicketParser {
  TicketData parse(String rawText);
  double confidence(String rawText);
}
