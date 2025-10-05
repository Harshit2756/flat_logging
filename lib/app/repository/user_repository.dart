import 'package:flat_logging/app/models/user_model.dart';
import 'package:flat_logging/app/repository/base_google_sheets_repository.dart';
import 'package:flat_logging/core/utils/constants/constants.dart';
import 'package:flat_logging/core/utils/constants/enums.dart';

class UserRepository extends BaseGoogleSheetsRepository {
  @override
  SheetType get sheetType => SheetType.user;

  /// Add user
  Future<bool> addUser(UserModel user) async {
    return await insertRow(user.toList());
  }

  /// Get all users
  Future<List<UserModel>> getAllUsers({bool isFromApi = false}) async {
    if (isFromApi) {
      final rows = await getAllValues();
      return rows.map((row) => UserModel.fromList(row)).toList();
    }
    return HConstants.user;
  }

  /// Delete user
  Future<bool> deleteUser(int index) async {
    return await deleteRowByIndex(index);
  }

  /// Update user
  Future<bool> updateUser(int index, UserModel user) async {
    return await updateRow(index, user.toList());
  }

  /// Check if user exists by name
  Future<bool> userExists(String name) async {
    final users = await getAllUsers();
    return users.any((user) => user.name.toLowerCase() == name.toLowerCase());
  }

  /// Find user by name
  Future<UserModel?> findUserByName(String name) async {
    final users = await getAllUsers();
    try {
      return users.firstWhere((user) => user.name.toLowerCase() == name.toLowerCase());
    } catch (e) {
      return null;
    }
  }
}
