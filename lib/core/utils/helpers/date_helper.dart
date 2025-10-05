import 'package:intl/intl.dart';

class DateHelper {
  static DateTime? excelDateToDateTime(dynamic excelDate) {
    // HLoggerHelper.info('value excel: $excelDate');
    try {
      if (excelDate == null) return null;

      // Convert string to number if needed
      final double dateNum = excelDate is String ? double.tryParse(excelDate) ?? 0 : excelDate.toDouble();

      // Excel's date system starts from December 30, 1899
      final DateTime baseDate = DateTime(1899, 12, 30);

      // Convert Excel date number to Duration and add to base date
      // HLoggerHelper.info('value after :${baseDate.add(Duration(days: dateNum.round()))}');
      return baseDate.add(Duration(days: dateNum.round()));
    } catch (e) {
      return null;
    }
  }

  static String formatDate(DateTime? date) {
    if (date == null) return '';

    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
  }

  static String toReadableDate(String? date) {
    if (date == null || date.isEmpty) return '';

    try {
      DateTime parsedDate;
      // Auto-detect format based on separator
      if (date.contains('-')) {
        parsedDate = DateFormat('dd-MM-yyyy').parse(date);
      } else {
        parsedDate = DateFormat('dd/MM/yyyy').parse(date);
      }

      // Format like: "Sun, 05 Oct 2025"
      return DateFormat('EEE, dd MMM yyyy').format(parsedDate);
    } catch (e) {
      return '';
    }
  }
}
