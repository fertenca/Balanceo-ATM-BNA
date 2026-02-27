import 'dart:io';

import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/balanceo.dart';
import '../models/config.dart';

class PdfService {
  Future<File> buildBalanceoPdf({
    required Config config,
    required String atmNombre,
    required Balanceo balanceo,
  }) async {
    final excel = Excel.createExcel();
    final defaultSheet = excel.getDefaultSheet();
    final sheet = excel[defaultSheet ?? 'Planilla'];

    sheet.cell(CellIndex.indexByString('A1')).value = const TextCellValue('PLANILLA BALANCEO ATM');
    sheet.cell(CellIndex.indexByString('A3')).value = TextCellValue('Sucursal: ${config.sucursalNombre} (${config.sucursalNumero})');
    sheet.cell(CellIndex.indexByString('A4')).value = TextCellValue('ATM: $atmNombre (${balanceo.atmId})');
    sheet.cell(CellIndex.indexByString('A5')).value =
        TextCellValue('Fecha balanceo: ${DateFormat('yyyy-MM-dd').format(balanceo.fecha)}');

    sheet.cell(CellIndex.indexByString('A7')).value = const TextCellValue('Total ticket');
    sheet.cell(CellIndex.indexByString('B7')).value = TextCellValue(balanceo.ticketData.totalTicket);
    sheet.cell(CellIndex.indexByString('A8')).value = const TextCellValue('Total contado');
    sheet.cell(CellIndex.indexByString('B8')).value = TextCellValue(balanceo.ticketData.totalContado);
    sheet.cell(CellIndex.indexByString('A9')).value = const TextCellValue('Diferencia ticket');
    sheet.cell(CellIndex.indexByString('B9')).value = TextCellValue(balanceo.ticketData.diferencia);

    sheet.cell(CellIndex.indexByString('A11')).value = const TextCellValue('Gaveta');
    sheet.cell(CellIndex.indexByString('B11')).value = const TextCellValue('Denominación');
    sheet.cell(CellIndex.indexByString('C11')).value = const TextCellValue('Cantidad');
    sheet.cell(CellIndex.indexByString('D11')).value = const TextCellValue('Monto');

    var row = 12;
    for (final a in balanceo.ajustes) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row - 1)).value = TextCellValue(a.gaveta);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row - 1)).value = IntCellValue(a.denominacion);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row - 1)).value = IntCellValue(a.cantidadBilletes);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row - 1)).value = IntCellValue(a.monto);
      row++;
    }

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = const TextCellValue('Total ajustes');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value = IntCellValue(balanceo.totalAjustes);
    row++;
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = const TextCellValue('Diferencia final');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value = IntCellValue(balanceo.diferenciaFinal);
    row++;
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = const TextCellValue('Timestamp generación');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value =
        TextCellValue(DateFormat('yyyy-MM-dd HH:mm:ss').format(balanceo.timestamp));

    final bytes = excel.encode();
    if (bytes == null) {
      throw StateError('No se pudo generar la planilla XLSX.');
    }

    final dir = await getApplicationDocumentsDirectory();
    final filename = 'balanceo_${balanceo.atmId}_${DateFormat('yyyyMMdd_HHmmss').format(balanceo.timestamp)}.xlsx';
    final file = File(p.join(dir.path, filename));
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}
