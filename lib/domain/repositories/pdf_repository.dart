import '../entities/balanceo.dart';
import '../entities/config.dart';

abstract class PdfRepository {
  Future<String> generateAndSave({
    required Config config,
    required Balanceo balanceo,
    required String atmName,
  });
}
