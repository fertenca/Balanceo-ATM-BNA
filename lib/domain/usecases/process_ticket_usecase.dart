import '../entities/ticket_data.dart';
import '../repositories/ocr_repository.dart';
import '../services/parser_registry.dart';

class ProcessTicketUseCase {
  final OcrRepository ocrRepository;
  final ParserRegistry parserRegistry;

  const ProcessTicketUseCase({
    required this.ocrRepository,
    required this.parserRegistry,
  });

  Future<TicketData> call({required String imagePath, required String atmId}) async {
    final text = await ocrRepository.recognizeText(imagePath);
    final parser = parserRegistry.select(text);
    return parser.parse(ocrText: text, atmId: atmId).ticketData;
  }
}
