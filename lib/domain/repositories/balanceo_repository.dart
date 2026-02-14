import '../entities/balanceo.dart';

abstract class BalanceoRepository {
  Future<List<Balanceo>> list();
  Future<void> save(Balanceo balanceo);
}
