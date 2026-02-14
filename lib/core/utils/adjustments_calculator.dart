import '../models/ajuste.dart';

class AdjustmentsCalculator {
  static int total(List<Ajuste> ajustes) => ajustes.fold(0, (acc, item) => acc + item.monto);

  static int diferenciaFinal({required int diferenciaTicket, required List<Ajuste> ajustes}) {
    return diferenciaTicket + total(ajustes);
  }
}
