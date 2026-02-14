import 'package:balanceo_atm_bna/core/models/ajuste.dart';
import 'package:balanceo_atm_bna/core/utils/adjustments_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('calcula total de ajustes y diferencia final', () {
    final ajustes = [
      const Ajuste(gaveta: 'A', denominacion: 1000, cantidadBilletes: 2),
      const Ajuste(gaveta: 'B', denominacion: 500, cantidadBilletes: 3),
    ];

    expect(AdjustmentsCalculator.total(ajustes), 3500);
    expect(
      AdjustmentsCalculator.diferenciaFinal(diferenciaTicket: -500, ajustes: ajustes),
      3000,
    );
  });
}
