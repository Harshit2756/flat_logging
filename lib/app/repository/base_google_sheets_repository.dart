import 'package:flat_logging/app/services/google_sheets_service.dart';
import 'package:flat_logging/app/services/google_sheets_service_manager.dart';
import 'package:flat_logging/core/utils/constants/enums.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

/// Base repository class for Google Sheets operations
/// This provides a template for creating repositories for different sheet types
abstract class BaseGoogleSheetsRepository {
  late final GoogleSheetsServiceManager _serviceManager;

  BaseGoogleSheetsRepository() {
    // Use Get.find() but check if it's ready first
    if (Get.isRegistered<GoogleSheetsServiceManager>()) {
      _serviceManager = Get.find<GoogleSheetsServiceManager>();
    } else {
      throw Exception('GoogleSheetsServiceManager not initialized. Please ensure initServices() completes before accessing repositories.');
    }
  }

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
        return [];
      }

      final rows = await _service.getAllValues();

      return rows;
    } catch (e) {
      return [];
    }
  }

  /// Insert a row
  Future<bool> insertRow(List<dynamic> row) async {
    try {
      if (!isServiceReady) {
        return false;
      }

      final response = await _service.insertRow(row);

      if (response) {
      } else {}

      return response;
    } catch (e) {
      return false;
    }
  }

  /// Update a row
  Future<bool> updateRow(int rowIndex, List<dynamic> row) async {
    try {
      if (!isServiceReady) {
        return false;
      }

      final response = await _service.updateRow(rowIndex, row);

      if (response) {
      } else {}

      return response;
    } catch (e) {
      return false;
    }
  }

  /// Delete a row
  Future<bool> deleteRowByIndex(int rowIndex) async {
    try {
      if (!isServiceReady) {
        return false;
      }

      final response = await _service.deleteRowByIndex(rowIndex);
      return response;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteRowById(String id) async {
    try {
      if (!isServiceReady) {
        return false;
      }

      final response = await _service.deleteRowById(id);

      return response;
    } catch (e) {
      return false;
    }
  }

  /// Get total count
  Future<int> getTotalCount() async {
    try {
      if (!isServiceReady) {
        return 0;
      }

      final count = await _service.getTotalCount();

      return count;
    } catch (e) {
      return 0;
    }
  }

  /// Refresh data
  Future<void> refreshData() async {
    try {
      await _serviceManager.refreshService(sheetType);
    } catch (e) {
      throw Exception('Failed to refresh data for $sheetType: $e');
    }
  }
}
