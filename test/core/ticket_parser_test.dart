import 'package:balanceo_atm_bna/core/parsers/generic_ticket_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parser genérico extrae montos por etiquetas comunes', () {
    const raw = 'TOTAL TICKET 125000\nTOTAL CONTADO 124000\nDIFERENCIA -1000';
    final parser = GenericTicketParser();

    final result = parser.parse(raw);

    expect(result.totalTicket, '125000');
    expect(result.totalContado, '124000');
    expect(result.diferencia, '-1000');
    expect(parser.confidence(raw), greaterThan(0.7));
  });
}
