# Balanceo ATM BNA - MVP Offline (Flutter)

## 1) Elección de stack: **Flutter**

Se elige **Flutter** sobre React Native para este MVP por:

- **Mejor consistencia UI cross-platform** (Android/iOS) con menos variaciones visuales.
- **Rendimiento sólido en tareas on-device** (flujo OCR + procesamiento local + PDF).
- Ecosistema maduro para:
  - OCR offline con `google_mlkit_text_recognition`.
  - Captura de imagen con `image_picker` (y migrable a `camera` para guías avanzadas).
  - Persistencia local con SQLite (`drift` + `sqlcipher_flutter_libs` para cifrado).
  - PDF con `pdf` + `printing`.
- Facilita arquitectura limpia (Domain/Data/Presentation) y test unitarios de parsers.

> Todo el diseño del MVP es **100% offline** y preparado para integrar plantilla real de planilla luego.

---

## 2) Plan de implementación

1. **Arquitectura base + navegación**
   - Clean-ish architecture: `core`, `data`, `domain`, `presentation`.
   - Gestión de estado con **Riverpod** (simple y escalable).
2. **Configuración inicial**
   - Sucursal + ABM ATMs con layout/modelo asignado.
3. **Nuevo balanceo**
   - Selección ATM, fecha, turno, captura de ticket.
4. **OCR + parsers pluggables**
   - OCR on-device.
   - Detección de layout y parseo por modelo (`NCR`, `Diebold`) + `Fallback`.
   - Pantalla de revisión/corrección.
5. **Ajustes por gaveta**
   - Carga de ajustes en cantidad de billetes por denominación.
   - Re-cálculo de diferencias y estado conforme/no conforme.
6. **PDF por ATM/fecha/turno**
   - Estrategia placeholder lista para conectar plantilla real.
   - Guardado local y compartir.
7. **Persistencia local**
   - SQLite cifrado para config/balanceos.
8. **Tests parsers**
   - Fixtures de texto inventados y unit tests.

---

## 3) Árbol de carpetas (propuesto)

```text
lib/
  main.dart
  app.dart
  core/
    constants/
    errors/
    utils/
  domain/
    entities/
      atm.dart
      config.dart
      ticket_data.dart
      ajuste.dart
      balanceo.dart
    repositories/
      config_repository.dart
      balanceo_repository.dart
      ocr_repository.dart
      pdf_repository.dart
    services/
      parser_ticket.dart
      parser_registry.dart
      parsers/
        ncr_parser.dart
        diebold_parser.dart
        generic_parser.dart
    usecases/
      process_ticket_usecase.dart
      generate_balanceo_pdf_usecase.dart
  data/
    db/
      app_database.dart
      tables.dart
    repositories/
      config_repository_impl.dart
      balanceo_repository_impl.dart
      ocr_repository_impl.dart
      pdf_repository_impl.dart
    services/
      image_preprocessor.dart
      ocr_service.dart
  presentation/
    providers/
      app_providers.dart
    screens/
      config_screen.dart
      new_balanceo_screen.dart
      review_ticket_screen.dart
      ajustes_screen.dart
      summary_screen.dart
    widgets/
      atm_form_dialog.dart
      capture_guide_overlay.dart
      ajuste_form.dart

test/
  parser/
    fixtures.dart
    parser_registry_test.dart
```

---

## 4) Build y ejecución

### Requisitos
- Flutter SDK estable (>= 3.22)
- Android Studio / Xcode
- CocoaPods (iOS)

### Instalar dependencias

```bash
flutter pub get
```

### Ejecutar en Android

```bash
flutter run -d android
```

### Ejecutar en iOS

```bash
cd ios && pod install && cd ..
flutter run -d ios
```

### Tests

```bash
flutter test
```

---

## 5) Estrategia PDF y planilla real (Excel)

### Implementado en MVP (placeholder serio)
- Generador PDF con layout estable y mapeo de campos por coordenadas lógicas.
- Incluye: sucursal, ATM, fecha, turno, campos parseados, ajustes, total final, observaciones, timestamp.
- Nombre archivo: `[Sucursal]-[ATM]-[Fecha].pdf`.

### Integración futura de plantilla real (sin reescribir)
- Se centraliza en `PdfTemplateEngine` y `FieldMap`.
- Cuando llegue el Excel:
  1. Exportar/convertir hoja a base PDF o imagen (A4).
  2. Definir `template.json` con coordenadas/campos.
  3. Reemplazar `PlaceholderTemplate` por `ExcelTemplateAdapter`.
  4. Mantener intactos: dominio, parsers, cálculos, flujo UI.

Pendientes cuando se entregue Excel:
- Ajuste fino de tipografías, offsets y line heights.
- Validación visual “pixel-perfect” contra planilla oficial.
- Bloqueo de edición de campos que deban quedar fijos por compliance.

