import 'package:flutter/widgets.dart';

import '../../app/app_controller.dart';
import '../../core/parsers/parser_engine.dart';
import '../../core/services/local_store_service.dart';
import '../../core/services/offline_ocr_service.dart';
import '../../core/services/pdf_service.dart';

class AppScope extends StatefulWidget {
  const AppScope({super.key, required this.child});

  final Widget child;

  static AppController of(BuildContext context) {
    final inherited = context.dependOnInheritedWidgetOfExactType<_AppInherited>();
    assert(inherited != null, 'AppScope no encontrado en el árbol');
    return inherited!.controller;
  }

  @override
  State<AppScope> createState() => _AppScopeState();
}

class _AppScopeState extends State<AppScope> {
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
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) => _AppInherited(controller: controller, child: widget.child),
    );
  }
}

class _AppInherited extends InheritedWidget {
  const _AppInherited({required this.controller, required super.child});

  final AppController controller;

  @override
  bool updateShouldNotify(_AppInherited oldWidget) => oldWidget.controller != controller;
}
