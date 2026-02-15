import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/balanceo.dart';
import '../models/config.dart';

class PdfService {
  Future<File> buildBalanceoPdf({
    required Config config,
    required String atmNombre,
    required Balanceo balanceo,
  }) async {
    final pdf = pw.Document();
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

    pdf.addPage(
      pw.MultiPage(
        build: (_) => [
          pw.Header(level: 0, child: pw.Text('Planilla Balanceo ATM - MVP')),
          pw.Text('Sucursal: ${config.sucursalNombre} (${config.sucursalNumero})'),
          pw.Text('ATM: $atmNombre (${balanceo.atmId})'),
          pw.Text('Fecha balanceo: ${DateFormat('yyyy-MM-dd').format(balanceo.fecha)}'),
          pw.SizedBox(height: 12),
          pw.Text('Datos ticket:'),
          pw.Bullet(text: 'Total ticket: ${balanceo.ticketData.totalTicket}'),
          pw.Bullet(text: 'Total contado: ${balanceo.ticketData.totalContado}'),
          pw.Bullet(text: 'Diferencia ticket: ${balanceo.ticketData.diferencia}'),
          pw.SizedBox(height: 12),
          pw.Text('Ajustes por gaveta:'),
          ...balanceo.ajustes.map(
            (a) => pw.Bullet(text: 'Gaveta ${a.gaveta} - ${a.denominacion} x ${a.cantidadBilletes} = ${a.monto}'),
          ),
          pw.Divider(),
          pw.Text('Total ajustes: ${balanceo.totalAjustes}'),
          pw.Text('Diferencia final: ${balanceo.diferenciaFinal}'),
          pw.Text('Timestamp generación: ${formatter.format(balanceo.timestamp)}'),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final filename = 'balanceo_${balanceo.atmId}_${DateFormat('yyyyMMdd_HHmmss').format(balanceo.timestamp)}.pdf';
    final file = File(p.join(dir.path, filename));
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
