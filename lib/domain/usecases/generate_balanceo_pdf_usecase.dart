import '../entities/balanceo.dart';
import '../entities/config.dart';
import '../repositories/pdf_repository.dart';

class GenerateBalanceoPdfUseCase {
  final PdfRepository repository;

  const GenerateBalanceoPdfUseCase(this.repository);

  Future<String> call({
    required Config config,
    required Balanceo balanceo,
    required String atmName,
  }) {
    return repository.generateAndSave(
      config: config,
      balanceo: balanceo,
      atmName: atmName,
    );
  }
}
