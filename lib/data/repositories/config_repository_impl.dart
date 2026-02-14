import '../../domain/entities/config.dart';
import '../../domain/repositories/config_repository.dart';
import '../services/secure_local_store.dart';

class ConfigRepositoryImpl implements ConfigRepository {
  final SecureLocalStore store;
  ConfigRepositoryImpl(this.store);

  @override
  Future<Config> load() async {
    final data = await store.readJson('config.enc.json');
    if (data == null) return Config.empty();
    return Config.fromJson(data);
  }

  @override
  Future<void> save(Config config) => store.writeJson('config.enc.json', config.toJson());
}
