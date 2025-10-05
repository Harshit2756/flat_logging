import 'package:intl/intl.dart';

class DateHelper {
  static DateTime? excelDateToDateTime(dynamic excelDate) {
    //
    try {
      if (excelDate == null) return null;

      // Convert string to number if needed
      final double dateNum = excelDate is String ? double.tryParse(excelDate) ?? 0 : excelDate.toDouble();

      // Excel's date system starts from December 30, 1899
      final DateTime baseDate = DateTime(1899, 12, 30);

      // Convert Excel date number to Duration and add to base date
      //
      return baseDate.add(Duration(days: dateNum.round()));
    } catch (e) {
      return null;
    }
  }

  static String convertToGsheetFormat(String date) {
    try {
      // Handle both / and - delimiters
      final dateParts = date.contains('-') ? date.split('-') : date.split('/');

      if (dateParts.length != 3) {
        throw Exception('Invalid date format');
      }

      final day = dateParts[0].padLeft(2, '0');
      final month = dateParts[1].padLeft(2, '0');
      final year = dateParts[2];

      return '$month-$day-$year'; // MM-dd-yyyy format with hyphens
    } catch (e) {
      return date; // Return original if conversion fails
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
