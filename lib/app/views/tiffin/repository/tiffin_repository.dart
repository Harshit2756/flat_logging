import 'package:flat_logging/app/models/tiffin_model.dart';
import 'package:flat_logging/app/repository/base_google_sheets_repository.dart';
import 'package:flat_logging/core/utils/constants/enums.dart';

class TiffinRepository extends BaseGoogleSheetsRepository {
  @override
  SheetType get sheetType => SheetType.tiffin;

  /// Add Tiffin
  Future<bool> addTiffin(TiffinModel tiffin) async {
    return await insertRow(tiffin.toList());
  }

  /// Get all tiffins
  Future<List<TiffinModel>> getAllTiffin() async {
    final rows = await getAllValues();
    final tiffins = rows.map((row) => TiffinModel.fromList(row)).toList();
    return tiffins;
  }

  /// Delete Tiffin
  Future<bool> deleteTiffin({int? index, String? id}) async {
    if (index != null) {
      return await deleteRowByIndex(index);
    }
    if (id != null) {
      return await deleteRowById(id);
    }

    throw ArgumentError('At least one of "id" or "name" must be provided.');
  }

  /// Update Tiffin
  Future<bool> updateTiffin(int index, TiffinModel tiffin) async {
    return await updateRow(index, tiffin.toList());
  }
}
