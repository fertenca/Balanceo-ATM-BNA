import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('PLANILLA DIARIA ATM (Placeholder Template)', style: pw.TextStyle(fontSize: 16)),
            pw.SizedBox(height: 8),
            pw.Text('Sucursal: ${config.sucursalNombre} (${config.sucursalNumero})'),
            pw.Text('ATM: $atmName (${balanceo.atmId})'),
            pw.Text('Fecha: ${DateFormat('yyyy-MM-dd').format(balanceo.fecha)}  Turno: ${balanceo.turno ?? '-'}'),
            pw.Divider(),
            pw.Text('Total esperado: ${balanceo.ticketData.totalEsperado.toStringAsFixed(2)}'),
            pw.Text('Total contado: ${balanceo.ticketData.totalContado.toStringAsFixed(2)}'),
            pw.Text('Diferencia ticket: ${balanceo.ticketData.diferencia.toStringAsFixed(2)}'),
            pw.SizedBox(height: 8),
            pw.Text('Ajustes por gaveta:'),
            pw.Table.fromTextArray(
              headers: const ['Gaveta', 'Denominación', 'Cantidad', 'Monto'],
              data: balanceo.ajustes
                  .map((a) => [a.gaveta, a.denominacion.toString(), a.cantidadBilletes.toString(), a.monto.toStringAsFixed(2)])
                  .toList(),
            ),
            pw.SizedBox(height: 8),
            pw.Text('Total ajustes: ${balanceo.totalAjustes.toStringAsFixed(2)}'),
            pw.Text('Estado final: ${balanceo.estadoConforme ? 'CONFORME' : 'NO CONFORME'}'),
            pw.Text('Observaciones: ${balanceo.observaciones ?? '-'}'),
            pw.Text('Timestamp: ${balanceo.timestamp.toIso8601String()}'),
          ],
        ),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final fileName = '${config.sucursalNombre}-$atmName-${DateFormat('yyyyMMdd').format(balanceo.fecha)}.pdf';
    final file = File(p.join(dir.path, fileName));
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }
}
