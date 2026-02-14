import '../entities/config.dart';

abstract class ConfigRepository {
  Future<Config> load();
  Future<void> save(Config config);
}
