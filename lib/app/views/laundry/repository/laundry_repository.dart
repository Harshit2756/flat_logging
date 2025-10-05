import 'package:flat_logging/app/models/laundry_model.dart';
import 'package:flat_logging/app/repository/base_google_sheets_repository.dart';
import 'package:flat_logging/core/utils/constants/enums.dart';
import 'package:flat_logging/core/utils/helpers/logger.dart';

class LaundryRepository extends BaseGoogleSheetsRepository {
  @override
  SheetType get sheetType => SheetType.laundry;

  /// Add Laundry
  Future<bool> addLaundry(LaundryModel laundry) async {
    return await insertRow(laundry.toList());
  }

  /// Get all laundries
  Future<List<LaundryModel>> getAllLaundry() async {
    final rows = await getAllValues();
    HLoggerHelper.debug('Fetched ${rows.length} laundry records.');
    final laundries = rows.map((row) => LaundryModel.fromList(row)).toList();
    return laundries;
  }

  /// Delete Laundry
  Future<bool> deleteLaundry({int? index, String? id}) async {
    if (index != null) {
      return await deleteRowByIndex(index);
    }
    if (id != null) {
      return await deleteRowById(id);
    }

    throw ArgumentError('At least one of "id" or "name" must be provided.');
  }

  /// Update Laundry
  Future<bool> updateLaundry(int index, LaundryModel laundry) async {
    return await updateRow(index, laundry.toList());
  }
}
