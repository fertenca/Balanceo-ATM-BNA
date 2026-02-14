import 'package:flutter/widgets.dart';

import 'app/balanceo_app.dart';
import 'features/shared/app_scope.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppScope(child: BalanceoApp()));
}
