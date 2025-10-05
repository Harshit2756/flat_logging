import 'package:flat_logging/app/services/google_sheets_service.dart';
import 'package:flat_logging/app/services/google_sheets_service_manager.dart';
import 'package:flat_logging/core/utils/constants/enums.dart';
import 'package:flat_logging/core/utils/helpers/logger.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

/// Base repository class for Google Sheets operations
/// This provides a template for creating repositories for different sheet types
abstract class BaseGoogleSheetsRepository {
  final GoogleSheetsServiceManager _serviceManager = Get.find<GoogleSheetsServiceManager>();

  /// Get the specific sheet type for this repository
  SheetType get sheetType;

  /// Get the Google Sheets service for this repository's sheet type
  GoogleSheetsService get _service => _serviceManager.getService(sheetType);

  /// Check if service is ready
  bool get isServiceReady => _serviceManager.isServiceReady(sheetType);

  /// Get all values from the sheet
  Future<List<List<String>>> getAllValues() async {
    try {
      if (!isServiceReady) {
        HLoggerHelper.error('$sheetType service not ready');
        return [];
      }

      final rows = await _service.getAllValues();
      HLoggerHelper.info('Retrieved ${rows.length} rows from $sheetType sheet');
      return rows;
    } catch (e) {
      HLoggerHelper.error('Error getting all values for $sheetType: $e');
      return [];
    }
  }

  /// Insert a row
  Future<bool> insertRow(List<dynamic> row) async {
    try {
      if (!isServiceReady) {
        HLoggerHelper.error('$sheetType service not ready');
        return false;
      }

      final response = await _service.insertRow(row);

      if (response) {
        HLoggerHelper.info('Row inserted successfully for $sheetType');
      } else {
        HLoggerHelper.error('Failed to insert row for $sheetType');
      }

      return response;
    } catch (e) {
      HLoggerHelper.error('Error inserting row for $sheetType: $e');
      return false;
    }
  }

  /// Update a row
  Future<bool> updateRow(int rowIndex, List<dynamic> row) async {
    try {
      if (!isServiceReady) {
        HLoggerHelper.error('$sheetType service not ready');
        return false;
      }

      final response = await _service.updateRow(rowIndex, row);

      if (response) {
        HLoggerHelper.info('Row updated successfully at index $rowIndex for $sheetType');
      } else {
        HLoggerHelper.error('Failed to update row at index $rowIndex for $sheetType');
      }

      return response;
    } catch (e) {
      HLoggerHelper.error('Error updating row for $sheetType: $e');
      return false;
    }
  }

  /// Delete a row
  Future<bool> deleteRowByIndex(int rowIndex) async {
    try {
      if (!isServiceReady) {
        HLoggerHelper.error('$sheetType service not ready');
        return false;
      }

      final response = await _service.deleteRowByIndex(rowIndex);
      return response;
    } catch (e) {
      HLoggerHelper.error('Error deleting row for $sheetType: $e');
      return false;
    }
  }

  Future<bool> deleteRowById(String id) async {
    try {
      if (!isServiceReady) {
        HLoggerHelper.error('$sheetType service not ready');
        return false;
      }

      final response = await _service.deleteRowById(id);

      return response;
    } catch (e) {
      HLoggerHelper.error('Error deleting row for $sheetType: $e');
      return false;
    }
  }

  /// Get total count
  Future<int> getTotalCount() async {
    try {
      if (!isServiceReady) {
        HLoggerHelper.error('$sheetType service not ready');
        return 0;
      }

      final count = await _service.getTotalCount();

      return count;
    } catch (e) {
      HLoggerHelper.error('Error getting total count for $sheetType: $e');
      return 0;
    }
  }

  /// Refresh data
  Future<void> refreshData() async {
    try {
      await _serviceManager.refreshService(sheetType);
      HLoggerHelper.info('Data refreshed successfully for $sheetType');
    } catch (e) {
      HLoggerHelper.error('Error refreshing data for $sheetType: $e');
    }
  }
}
