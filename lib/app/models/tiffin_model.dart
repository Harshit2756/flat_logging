import 'package:flat_logging/core/utils/helpers/date_helper.dart';

class TiffinModel {
  final String id;
  final String date;
  final String user;
  final num quantity;

  TiffinModel({required this.date, required this.id, required this.user, required this.quantity});

  static TiffinModel fromList(List<String> row) {
    // Convert Excel date number to readable date
    final dateTime = DateHelper.excelDateToDateTime(row.length > 1 ? row[1] : '');
    final formattedDate = DateHelper.formatDate(dateTime == DateTime(1899, 12, 30) ? null : dateTime);

    return TiffinModel(id: row[0], date: row.length > 1 ? formattedDate : '', user: row.length > 2 ? row[2] : '', quantity: row.length > 3 ? num.tryParse(row[3]) ?? 0 : 0);
  }

  List<String> toList() {
    return [id, date, user, quantity.toString()];
  }

  @override
  String toString() {
    return 'id:$id date:$date user:$user quantity:$quantity';
  }
}
