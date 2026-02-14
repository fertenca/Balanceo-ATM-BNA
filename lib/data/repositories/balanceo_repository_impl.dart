import '../../domain/entities/balanceo.dart';
import '../../domain/repositories/balanceo_repository.dart';
import '../services/secure_local_store.dart';

class BalanceoRepositoryImpl implements BalanceoRepository {
  final SecureLocalStore store;
  BalanceoRepositoryImpl(this.store);

  @override
  Future<List<Balanceo>> list() async {
    final data = await store.readJson('balanceos.enc.json');
    final items = List<Map<String, dynamic>>.from(data?['items'] ?? []);
    return items.map(Balanceo.fromJson).toList();
  }

  @override
  Future<void> save(Balanceo balanceo) => store.appendJsonList('balanceos.enc.json', balanceo.toJson());
}
