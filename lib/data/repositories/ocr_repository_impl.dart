import '../../domain/repositories/ocr_repository.dart';
import '../services/image_preprocessor.dart';
import '../services/ocr_service.dart';

class OcrRepositoryImpl implements OcrRepository {
  final OcrService service;
  final ImagePreprocessor preprocessor;

  OcrRepositoryImpl({required this.service, required this.preprocessor});

  @override
  Future<String> recognizeText(String imagePath) async {
    final processed = await preprocessor.preprocess(imagePath);
    return service.recognize(processed);
  }
}
