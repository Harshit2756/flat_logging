import 'package:flat_logging/core/utils/constants/enums.dart';
import 'package:gsheets/gsheets.dart';

import '../../core/utils/config/google_sheets_config.dart';

class GoogleSheetsService {
  final String _credentials = GoogleSheetsConfig.credentials;
  final String _spreadsheetId = GoogleSheetsConfig.spreadsheetId;

  final Map<SheetType, Worksheet?> _worksheets = {};
  GSheets? _gsheets;
  Spreadsheet? _spreadsheet;

  final SheetType sheetType;
  bool _isInitialized = false;
  bool _isInitializing = false;

  GoogleSheetsService({required this.sheetType});

  bool get isInitialized => _isInitialized;
  bool get isInitializing => _isInitializing;

  Future<void> init() async {
    if (_isInitialized) {
      return;
    }

    if (_isInitializing) {
      return;
    }

    _isInitializing = true;

    try {
      _gsheets = GSheets(_credentials);
      _spreadsheet = await _gsheets!.spreadsheet(_spreadsheetId);

      // Get worksheet for the specified type
      final worksheetTitle = GoogleSheetsConfig.worksheetTitles[sheetType]!;
      _worksheets[sheetType] = await _getWorkSheet(_spreadsheet!, title: worksheetTitle);

      // Create headers if they don't exist
      final headers = GoogleSheetsConfig.worksheetHeaders[sheetType]!;
      final firstRow = await _worksheets[sheetType]!.values.row(1);
      if (firstRow.isEmpty) {
        await _worksheets[sheetType]!.values.insertRow(1, headers);
      }

      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
      rethrow;
    } finally {
      _isInitializing = false;
    }
  }

  Future<Worksheet> _getWorkSheet(Spreadsheet spreadsheet, {required String title}) async {
    try {
      // Try to get existing worksheet first
      final existingWorksheet = spreadsheet.worksheetByTitle(title);
      if (existingWorksheet != null) {
        return existingWorksheet;
      }

      // If not found, create new worksheet

      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<List<String>>> getAllValues() async {
    try {
      if (!_isInitialized) await init();

      final worksheet = _worksheets[sheetType];
      if (worksheet == null) {
        throw Exception('Worksheet not found for $sheetType');
      }

      final rows = await worksheet.values.allRows();

      // Skip header row and return data rows
      return rows.isEmpty ? [] : rows.skip(1).toList();
    } catch (e) {
      return [];
    }
  }

  /// Accepts a list of dynamic values representing a row
  Future<bool> insertRow(List<dynamic> row) async {
    try {
      if (!_isInitialized) await init();

      final worksheet = _worksheets[sheetType];
      if (worksheet == null) {
        throw Exception('Worksheet not found for $sheetType');
      }

      await worksheet.values.appendRow(row);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateRow(int rowIndex, List<dynamic> row) async {
    try {
      if (!_isInitialized) await init();

      final worksheet = _worksheets[sheetType];
      if (worksheet == null) {
        throw Exception('Worksheet not found for $sheetType');
      }

      // Add 1 because Google Sheets is 1-indexed
      await worksheet.values.insertRow(rowIndex + 1, row);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteRowByIndex(int rowIndex) async {
    try {
      if (!_isInitialized) await init();

      final worksheet = _worksheets[sheetType];
      if (worksheet == null) {
        throw Exception('Worksheet not found for $sheetType');
      }

      // Add 1 because Google Sheets is 1-indexed
      await worksheet.deleteRow(rowIndex + 1);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteRowById(String id) async {
    try {
      if (!_isInitialized) await init();

      final worksheet = _worksheets[sheetType];
      if (worksheet == null) {
        throw Exception('Worksheet not found for $sheetType');
      }

      // Add 1 because Google Sheets is 1-indexed
      final rows = await worksheet.values.allRows();

      final rowIndex = rows.indexWhere((r) => r[0] == id);
      await worksheet.deleteRow(rowIndex + 1);
      //
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<int> getTotalCount() async {
    try {
      if (!_isInitialized) await init();

      final worksheet = _worksheets[sheetType];
      if (worksheet == null) {
        throw Exception('Worksheet not found for $sheetType');
      }

      final rows = await worksheet.values.allRows();
      final count = rows.length > 1 ? rows.length - 1 : 0;

      return count;
    } catch (e) {
      return 0;
    }
  }

  // Method to refresh/reload data
  Future<void> refresh() async {
    try {
      if (!_isInitialized) await init();

      // Force reload by clearing cache if needed
    } catch (e) {
      rethrow;
    }
  }

  // Method to check if service is ready
  bool get isReady => _isInitialized && _worksheets[sheetType] != null;

  // Method to get worksheet info
  String? get worksheetTitle => GoogleSheetsConfig.worksheetTitles[sheetType];

  // Method to dispose resources
  void dispose() {
    _worksheets.clear();
    _gsheets = null;
    _spreadsheet = null;
    _isInitialized = false;
    _isInitializing = false;
  }
}
