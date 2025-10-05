import 'package:flat_logging/app/models/user_model.dart';

class UserLaundryEntry {
  final UserModel user;
  final String date;
  final int quantity;
  final bool isSelected;

  UserLaundryEntry({required this.user, required this.date, required this.quantity, this.isSelected = false});

  UserLaundryEntry copyWith({UserModel? user, String? date, int? quantity, bool? isSelected}) {
    return UserLaundryEntry(user: user ?? this.user, date: date ?? this.date, quantity: quantity ?? this.quantity, isSelected: isSelected ?? this.isSelected);
  }

  @override
  String toString() {
    return 'UserLaundryEntry{user: ${user.name}, date: $date, quantity: $quantity, isSelected: $isSelected}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserLaundryEntry && other.user == user && other.date == date && other.quantity == quantity && other.isSelected == isSelected;
  }

  @override
  int get hashCode {
    return user.hashCode ^ date.hashCode ^ quantity.hashCode ^ isSelected.hashCode;
  }
}
