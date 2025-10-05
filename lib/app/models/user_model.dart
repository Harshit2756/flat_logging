class UserModel {
  final String name;

  UserModel({required this.name});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(name: json['name'] as String);
  }

  // Convert from List (for Google Sheets rows)
  static UserModel fromList(List<String> row) {
    return UserModel(name: row[0]);
  }

  // Convert to List (for Google Sheets rows)
  List<String> toList() {
    return [name];
  }

  @override
  String toString() {
    return 'UserModel{name: $name}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
