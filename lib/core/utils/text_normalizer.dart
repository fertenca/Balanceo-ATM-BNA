class TextNormalizer {
  static String normalize(String input) {
    return input
        .toUpperCase()
        .replaceAll('O', '0')
        .replaceAll('I', '1')
        .replaceAll('S', '5');
  }

  static double extractAmount(String text, RegExp pattern) {
    final match = pattern.firstMatch(text);
    if (match == null) return 0;
    final raw = (match.group(1) ?? '0').replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(raw) ?? 0;
  }
}
