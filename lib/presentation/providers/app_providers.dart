import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../data/repositories/balanceo_repository_impl.dart';
import '../../data/repositories/config_repository_impl.dart';
import '../../data/repositories/ocr_repository_impl.dart';
import '../../data/repositories/pdf_repository_impl.dart';
import '../../data/services/image_preprocessor.dart';
import '../../data/services/ocr_service.dart';
import '../../data/services/secure_local_store.dart';
import '../../domain/entities/ajuste.dart';
import '../../domain/entities/atm.dart';
import '../../domain/entities/balanceo.dart';
import '../../domain/entities/config.dart';
import '../../domain/entities/ticket_data.dart';
import '../../domain/services/parser_registry.dart';
import '../../domain/services/parsers/bna_balance_red_parser.dart';
import '../../domain/services/parsers/diebold_parser.dart';
import '../../domain/services/parsers/generic_parser.dart';
import '../../domain/services/parsers/ncr_parser.dart';
import '../../domain/usecases/generate_balanceo_pdf_usecase.dart';
import '../../domain/usecases/process_ticket_usecase.dart';

final _storeProvider = Provider((ref) => SecureLocalStore());
final configRepositoryProvider = Provider((ref) => ConfigRepositoryImpl(ref.read(_storeProvider)));
final balanceoRepositoryProvider = Provider((ref) => BalanceoRepositoryImpl(ref.read(_storeProvider)));
final _ocrServiceProvider = Provider((ref) => OcrService());
final _ocrRepositoryProvider = Provider(
  (ref) => OcrRepositoryImpl(service: ref.read(_ocrServiceProvider), preprocessor: ImagePreprocessor()),
);
final parserRegistryProvider = Provider((ref) => ParserRegistry([BnaBalanceRedParser(), NcrParser(), DieboldParser(), GenericParser()]));
final processTicketProvider = Provider(
  (ref) => ProcessTicketUseCase(ocrRepository: ref.read(_ocrRepositoryProvider), parserRegistry: ref.read(parserRegistryProvider)),
);
final pdfUseCaseProvider = Provider((ref) => GenerateBalanceoPdfUseCase(PdfRepositoryImpl()));

class BalanceoDraft {
  final ATM? atm;
  final DateTime fecha;
  final String? turno;
  final File? image;
  final TicketData? ticketData;
  final List<Ajuste> ajustes;

  const BalanceoDraft({
    this.atm,
    required this.fecha,
    this.turno,
    this.image,
    this.ticketData,
    this.ajustes = const [],
  });

  factory BalanceoDraft.empty() => BalanceoDraft(fecha: DateTime.now());

  BalanceoDraft copyWith({
    ATM? atm,
    DateTime? fecha,
    String? turno,
    File? image,
    TicketData? ticketData,
    List<Ajuste>? ajustes,
  }) {
    return BalanceoDraft(
      atm: atm ?? this.atm,
      fecha: fecha ?? this.fecha,
      turno: turno ?? this.turno,
      image: image ?? this.image,
      ticketData: ticketData ?? this.ticketData,
      ajustes: ajustes ?? this.ajustes,
    );
  }
}

class AppController extends StateNotifier<AsyncValue<Config>> {
  final ConfigRepositoryImpl configRepo;
  final BalanceoRepositoryImpl balanceoRepo;
  final ProcessTicketUseCase processTicket;
  final GenerateBalanceoPdfUseCase pdfUseCase;

  BalanceoDraft draft = BalanceoDraft.empty();

  AppController({
    required this.configRepo,
    required this.balanceoRepo,
    required this.processTicket,
    required this.pdfUseCase,
  }) : super(const AsyncValue.loading()) {
    loadConfig();
  }

  Future<void> loadConfig() async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(await configRepo.load());
  }

  Future<void> saveConfig(Config config) async {
    await configRepo.save(config);
    state = AsyncValue.data(config);
  }

  void startDraft({required ATM atm, required DateTime fecha, String? turno}) {
    draft = BalanceoDraft.empty().copyWith(atm: atm, fecha: fecha, turno: turno);
  }

  Future<void> captureImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.camera, imageQuality: 90);
    if (file != null) {
      draft = draft.copyWith(image: File(file.path));
    }
  }

  Future<void> runOcr() async {
    if (draft.image == null || draft.atm == null) return;
    final ticket = await processTicket(imagePath: draft.image!.path, atmId: draft.atm!.id);
    draft = draft.copyWith(ticketData: ticket);
  }

  void updateTicketData(TicketData data) => draft = draft.copyWith(ticketData: data);

  void addAjuste(Ajuste ajuste) => draft = draft.copyWith(ajustes: [...draft.ajustes, ajuste]);

  double get diferenciaFinal => (draft.ticketData?.diferencia ?? 0) + draft.ajustes.fold(0.0, (a, b) => a + b.monto);

  Future<String?> saveBalanceoAndPdf({String? observaciones}) async {
    final config = state.value;
    if (config == null || draft.atm == null || draft.ticketData == null) return null;

    final balanceo = Balanceo(
      id: const Uuid().v4(),
      atmId: draft.atm!.id,
      fecha: draft.fecha,
      turno: draft.turno,
      ticketData: draft.ticketData!,
      ajustes: draft.ajustes,
      estadoConforme: diferenciaFinal == 0,
      observaciones: observaciones,
      timestamp: DateTime.now(),
    );

    await balanceoRepo.save(balanceo);
    final path = await pdfUseCase(config: config, balanceo: balanceo, atmName: draft.atm!.nombre);
    draft = BalanceoDraft.empty();
    return path;
  }
}

final appControllerProvider = StateNotifierProvider<AppController, AsyncValue<Config>>((ref) {
  return AppController(
    configRepo: ref.read(configRepositoryProvider),
    balanceoRepo: ref.read(balanceoRepositoryProvider),
    processTicket: ref.read(processTicketProvider),
    pdfUseCase: ref.read(pdfUseCaseProvider),
  );
});
