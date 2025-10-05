import 'dart:math';

class HHelperFunctions {
  /// Generates a globally unique ID for Google Sheets rows.
  /// Example output: USR-20251005-8G4X9KQW
  static String generateUniqueId({String prefix = 'USR'}) {
    final now = DateTime.now();
    final datePart = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';

    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    final randomPart = List.generate(8, (_) => chars[rand.nextInt(chars.length)]).join();

    return '$prefix-$datePart-$randomPart';
  }
}
