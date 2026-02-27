import 'package:balanceo_atm_bna/domain/services/parser_registry.dart';
import 'package:balanceo_atm_bna/domain/services/parsers/bna_balance_red_parser.dart';
import 'package:balanceo_atm_bna/domain/services/parsers/diebold_parser.dart';
import 'package:balanceo_atm_bna/domain/services/parsers/generic_parser.dart';
import 'package:balanceo_atm_bna/domain/services/parsers/ncr_parser.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

void main() {
  final registry = ParserRegistry([BnaBalanceRedParser(), NcrParser(), DieboldParser(), GenericParser()]);

  test('detecta layout NCR y parsea diferencia', () {
    final parser = registry.select(fixtureNcr);
    expect(parser.model, 'NCR');
    final result = parser.parse(ocrText: fixtureNcr, atmId: 'ATM-1');
    expect(result.ticketData.totalEsperado, 150000);
    expect(result.ticketData.totalContado, 149000);
    expect(result.ticketData.diferencia, -1000);
  });

  test('detecta layout DIEBOLD y parsea sin diferencia', () {
    final parser = registry.select(fixtureDiebold);
    expect(parser.model, 'DIEBOLD');
    final result = parser.parse(ocrText: fixtureDiebold, atmId: 'ATM-2');
    expect(result.ticketData.totalEsperado, 200000);
    expect(result.ticketData.totalContado, 200000);
    expect(result.ticketData.diferencia, 0);
  });

  test('detecta layout BNA BALANCE DE RED y parsea gavetas', () {
    final parser = registry.select(fixtureBnaBalanceRed);
    expect(parser.model, 'BNA_BALANCE_RED');
    final result = parser.parse(ocrText: fixtureBnaBalanceRed, atmId: 'ATM-3');
    expect(result.ticketData.atmCode, '19855');
    expect(result.ticketData.totalPorGaveta['C3'], 8000000);
    expect(result.ticketData.totalEsperado, 8000000);
    expect(result.ticketData.totalContado, 8000000);
    expect(result.ticketData.diferencia, 0);
  });
}
