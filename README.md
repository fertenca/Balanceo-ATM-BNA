# Balanceo ATM (MVP Offline)

Aplicación móvil Flutter para Android (preparada para iOS) orientada al flujo de balanceo de tickets de ATM, 100% offline.

## Diagnóstico del repo

El repositorio ya tenía una base funcional en Flutter con OCR on-device, ajustes por gaveta, generación PDF y persistencia local. En esta iteración se reorganizó en una arquitectura modular por features para acercarla al objetivo de producto solicitado y dejar puntos de extensión claros para futuros parsers y plantilla PDF real.

## Plan técnico aplicado

1. Reorganizar el código hacia módulos por feature (`config`, `scan`, `review`, `adjustments`, `pdf`, `history`).
2. Definir y consolidar modelos de dominio: `ATM`, `Config`, `TicketData`, `Balanceo`, `Ajuste`.
3. Implementar flujo MVP end-to-end offline:
   - Configuración
   - Escaneo
   - OCR
   - Revisión manual
   - Ajustes
   - PDF
   - Compartir
   - Historial
4. Implementar sistema de parsers modular con `TicketParser` + parser genérico fallback.
5. Agregar tests unitarios para cálculo de ajustes y parser genérico.
6. Documentar setup y build para Windows / Android físico / release.

## Árbol de archivos (arquitectura actual)

```text
lib/
 ├── app/
 │    ├── app_controller.dart
 │    └── balanceo_app.dart
 ├── core/
 │    ├── models/
 │    │    ├── atm.dart
 │    │    ├── config.dart
 │    │    ├── ticket_data.dart
 │    │    ├── balanceo.dart
 │    │    └── ajuste.dart
 │    ├── parsers/
 │    │    ├── ticket_parser.dart
 │    │    ├── parser_engine.dart
 │    │    └── generic_ticket_parser.dart
 │    ├── services/
 │    │    ├── offline_ocr_service.dart
 │    │    ├── local_store_service.dart
 │    │    └── pdf_service.dart
 │    └── utils/
 │         └── adjustments_calculator.dart
 ├── features/
 │    ├── config/config_screen.dart
 │    ├── scan/scan_screen.dart
 │    ├── review/review_screen.dart
 │    ├── adjustments/adjustments_screen.dart
 │    ├── pdf/pdf_screen.dart
 │    ├── history/history_screen.dart
 │    └── shared/app_scope.dart
 └── main.dart
```

## Stack y decisiones técnicas

- **Flutter**: una sola base para Android/iOS con alto rendimiento local y buen time-to-market.
- **OCR offline: `google_mlkit_text_recognition`**
  - estable y mantenido,
  - procesamiento on-device sin servidor,
  - adecuado para MVP donde prima velocidad de implementación.
- **Cámara: `image_picker`**
  - API simple para captura rápida,
  - ampliamente usado y mantenido,
  - suficiente para MVP (si luego se requiere control fino se puede migrar a `camera`).
- **Almacenamiento local: JSON en documents directory (`path_provider`)**
  - simple, robusto para MVP single-user,
  - totalmente offline,
  - fácil migración posterior a DB si escala.
- **PDF y compartir: `pdf` + `printing`**
  - generación programática de planilla,
  - soporte de compartir adjuntos desde móvil,
  - listo para integrar plantilla real más adelante.

## Funcionalidades MVP implementadas

1. **Configuración**
   - sucursal nombre
   - sucursal número
   - email usuario
   - ABM simple de ATMs
2. **Escaneo**
   - selección de ATM
   - captura de foto de ticket
3. **OCR + revisión**
   - extracción de texto offline
   - edición manual de texto y campos clave
4. **Ajustes**
   - alta de gaveta
   - denominación y cantidad
   - monto automático por ajuste
5. **PDF**
   - sucursal, ATM, fecha, datos ticket, ajustes, total y timestamp
6. **Compartir**
   - botón para compartir PDF (incluye email si app de correo está disponible)
7. **Historial**
   - listado local de balanceos generados

## Extensibilidad preparada

- Parser modular con `abstract class TicketParser` y `GenericTicketParser` fallback.
- `ParserEngine` listo para registrar parsers por modelo de ticket/ATM.
- `PdfService` desacoplado para reemplazar layout por plantilla institucional real.

## Ejecutar en Windows (desarrollo)

1. Instalar Flutter estable y Android Studio.
2. Verificar entorno:
   ```bash
   flutter doctor
   ```
3. Instalar dependencias:
   ```bash
   flutter pub get
   ```
4. Ejecutar app:
   ```bash
   flutter run
   ```

## Ejecutar en Android físico

1. Activar **Opciones de desarrollador** y **Depuración USB** en el teléfono.
2. Conectar por USB.
3. Verificar dispositivo:
   ```bash
   flutter devices
   ```
4. Ejecutar:
   ```bash
   flutter run -d <deviceId>
   ```

## Build release Android

1. Generar APK release:
   ```bash
   flutter build apk --release
   ```
2. (Opcional) Generar App Bundle para Play Store:
   ```bash
   flutter build appbundle --release
   ```

> Nota: para distribución real se debe configurar firma (`key.properties`, keystore, `build.gradle`).

## Tests

```bash
flutter test
```

Incluye tests de:
- cálculo de ajustes
- parser genérico

## Restricciones de seguridad / alcance MVP

- Sin login
- 1 usuario local
- Sin conexión a sistemas bancarios
- Sin backend
- Sin datos bancarios reales hardcodeados
