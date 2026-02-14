import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../core/models/ajuste.dart';
import '../core/models/atm.dart';
import '../core/models/balanceo.dart';
import '../core/models/config.dart';
import '../core/models/ticket_data.dart';
import '../core/parsers/parser_engine.dart';
import '../core/services/local_store_service.dart';
import '../core/services/offline_ocr_service.dart';
import '../core/services/pdf_service.dart';
import '../core/utils/adjustments_calculator.dart';

class AppController extends ChangeNotifier {
  AppController({
    required LocalStoreService localStore,
    required OfflineOcrService ocrService,
    required ParserEngine parserEngine,
    required PdfService pdfService,
  })  : _localStore = localStore,
        _ocrService = ocrService,
        _parserEngine = parserEngine,
        _pdfService = pdfService;

  final LocalStoreService _localStore;
  final OfflineOcrService _ocrService;
  final ParserEngine _parserEngine;
  final PdfService _pdfService;

  Config config = Config.empty();
  List<Balanceo> history = [];
  ATM? selectedAtm;
  File? ticketImage;
  TicketData ticketData = TicketData.empty();
  final List<Ajuste> ajustes = [];

  Future<void> init() async {
    final savedConfig = await _localStore.readJson('config.json');
    config = savedConfig == null ? Config.empty() : Config.fromJson(savedConfig);

    final savedHistory = await _localStore.readJson('history.json');
    history = (savedHistory?['items'] as List<dynamic>? ?? const [])
        .map((e) => Balanceo.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    notifyListeners();
  }

  Future<void> saveConfig(Config newConfig) async {
    config = newConfig;
    await _localStore.saveJson('config.json', config.toJson());
    notifyListeners();
  }

  void chooseAtm(ATM? atm) {
    selectedAtm = atm;
    notifyListeners();
  }

  void setTicketImage(File image) {
    ticketImage = image;
    notifyListeners();
  }

  Future<void> runOcrAndParse() async {
    if (ticketImage == null) return;
    final rawText = await _ocrService.extractText(ticketImage!.path);
    ticketData = _parserEngine.parse(rawText);
    notifyListeners();
  }

  void updateTicketData(TicketData value) {
    ticketData = value;
    notifyListeners();
  }

  void addAjuste(Ajuste ajuste) {
    ajustes.add(ajuste);
    notifyListeners();
  }

  void clearDraft() {
    selectedAtm = null;
    ticketImage = null;
    ticketData = TicketData.empty();
    ajustes.clear();
    notifyListeners();
  }

  int get totalAjustes => AdjustmentsCalculator.total(ajustes);

  int get diferenciaFinal {
    final ticketDiff = int.tryParse(ticketData.diferencia) ?? 0;
    return AdjustmentsCalculator.diferenciaFinal(diferenciaTicket: ticketDiff, ajustes: ajustes);
  }

  Future<File?> generatePdf() async {
    if (selectedAtm == null) return null;

    final balanceo = Balanceo(
      id: const Uuid().v4(),
      atmId: selectedAtm!.id,
      fecha: DateTime.now(),
      ticketData: ticketData,
      ajustes: List.unmodifiable(ajustes),
      timestamp: DateTime.now(),
    );

    final file = await _pdfService.buildBalanceoPdf(
      config: config,
      atmNombre: selectedAtm!.nombre,
      balanceo: balanceo,
    );

    history = [...history, balanceo];
    await _localStore.saveJson('history.json', {'items': history.map((e) => e.toJson()).toList()});
    notifyListeners();
    return file;
  }
}
