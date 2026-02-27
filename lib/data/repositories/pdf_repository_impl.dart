import 'dart:io';

import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/balanceo.dart';
import '../../domain/entities/config.dart';
import '../../domain/repositories/pdf_repository.dart';

class PdfRepositoryImpl implements PdfRepository {
  @override
  Future<String> generateAndSave({
    required Config config,
    required Balanceo balanceo,
    required String atmName,
  }) async {
    final excel = Excel.createExcel();
    final defaultSheet = excel.getDefaultSheet();
    final sheet = excel[defaultSheet ?? 'Planilla'];

    sheet.cell(CellIndex.indexByString('A1')).value = const TextCellValue('PLANILLA DIARIA ATM');
    sheet.cell(CellIndex.indexByString('A3')).value = TextCellValue('Sucursal: ${config.sucursalNombre} (${config.sucursalNumero})');
    sheet.cell(CellIndex.indexByString('A4')).value = TextCellValue('ATM: $atmName (${balanceo.atmId})');
    sheet.cell(CellIndex.indexByString('A5')).value =
        TextCellValue('Fecha: ${DateFormat('yyyy-MM-dd').format(balanceo.fecha)}  Turno: ${balanceo.turno ?? '-'}');

    sheet.cell(CellIndex.indexByString('A7')).value = const TextCellValue('Total esperado');
    sheet.cell(CellIndex.indexByString('B7')).value = DoubleCellValue(balanceo.ticketData.totalEsperado);
    sheet.cell(CellIndex.indexByString('A8')).value = const TextCellValue('Total contado');
    sheet.cell(CellIndex.indexByString('B8')).value = DoubleCellValue(balanceo.ticketData.totalContado);
    sheet.cell(CellIndex.indexByString('A9')).value = const TextCellValue('Diferencia ticket');
    sheet.cell(CellIndex.indexByString('B9')).value = DoubleCellValue(balanceo.ticketData.diferencia);

    sheet.cell(CellIndex.indexByString('A11')).value = const TextCellValue('Gaveta');
    sheet.cell(CellIndex.indexByString('B11')).value = const TextCellValue('Denominación');
    sheet.cell(CellIndex.indexByString('C11')).value = const TextCellValue('Cantidad');
    sheet.cell(CellIndex.indexByString('D11')).value = const TextCellValue('Monto');

    var row = 12;
    for (final ajuste in balanceo.ajustes) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row - 1)).value = TextCellValue(ajuste.gaveta);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row - 1)).value = DoubleCellValue(ajuste.denominacion);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row - 1)).value = IntCellValue(ajuste.cantidadBilletes);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row - 1)).value = DoubleCellValue(ajuste.monto);
      row++;
    }

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = const TextCellValue('Total ajustes');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row)).value = DoubleCellValue(balanceo.totalAjustes);
    row += 2;

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = const TextCellValue('Estado final');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value =
        TextCellValue(balanceo.estadoConforme ? 'CONFORME' : 'NO CONFORME');
    row++;
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = const TextCellValue('Observaciones');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value = TextCellValue(balanceo.observaciones ?? '-');
    row++;
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = const TextCellValue('Timestamp');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value =
        TextCellValue(balanceo.timestamp.toIso8601String());

    final encoded = excel.encode();
    if (encoded == null) {
      throw StateError('No se pudo generar la planilla XLSX.');
    }

    final dir = await getApplicationDocumentsDirectory();
    final fileName = '${config.sucursalNombre}-$atmName-${DateFormat('yyyyMMdd').format(balanceo.fecha)}.xlsx';
    final file = File(p.join(dir.path, fileName));
    await file.writeAsBytes(encoded, flush: true);
    return file.path;
  }
}
