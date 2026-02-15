import 'package:flutter/widgets.dart';

import '../../app/app_controller.dart';
import '../../core/parsers/parser_engine.dart';
import '../../core/services/local_store_service.dart';
import '../../core/services/offline_ocr_service.dart';
import '../../core/services/pdf_service.dart';

class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key, required this.child});

  final Widget child;

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  late final AppController controller;

  @override
  void initState() {
    super.initState();
    controller = AppController(
      localStore: LocalStoreService(),
      ocrService: OfflineOcrService(),
      parserEngine: ParserEngine(),
      pdfService: PdfService(),
    )..init();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(controller: controller, child: widget.child);
  }
}

class AppScope extends InheritedNotifier<AppController> {
  const AppScope({
    super.key,
    required AppController controller,
    required super.child,
  }) : super(notifier: controller);

  static AppController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope no encontrado en el árbol');
    return scope!.notifier!;
  }
}
