import 'package:flat_logging/app/models/user_model.dart';

class UserTiffinEntry {
  final UserModel user;
  final String date;
  final int shares;
  final bool isSelected;

  UserTiffinEntry({required this.user, required this.date, required this.shares, this.isSelected = false});

  UserTiffinEntry copyWith({UserModel? user, String? date, int? quantity, bool? isSelected}) {
    return UserTiffinEntry(user: user ?? this.user, date: date ?? this.date, shares: quantity ?? shares, isSelected: isSelected ?? this.isSelected);
  }

  static double calculateQuantity(int shares, int totalShares, int totalTiffins) {
    if (totalShares == 0) return 0;
    return (shares / totalShares) * totalTiffins;
  }

  @override
  String toString() {
    return 'UserTiffinEntry{user: ${user.name}, date: $date, quantity: $shares, isSelected: $isSelected}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserTiffinEntry && other.user == user && other.date == date && other.shares == shares && other.isSelected == isSelected;
  }

  @override
  int get hashCode {
    return user.hashCode ^ date.hashCode ^ shares.hashCode ^ isSelected.hashCode;
  }

}
