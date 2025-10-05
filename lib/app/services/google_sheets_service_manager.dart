import 'package:flat_logging/app/services/google_sheets_service.dart';
import 'package:flat_logging/core/utils/constants/enums.dart';
import 'package:flat_logging/core/utils/helpers/logger.dart';
import 'package:get/get.dart';

/// Manager class to handle multiple Google Sheets services efficiently
/// This ensures proper initialization and management of different sheet types
class GoogleSheetsServiceManager {
  static GoogleSheetsServiceManager? _instance;
  static GoogleSheetsServiceManager get instance => _instance ??= GoogleSheetsServiceManager._();

  GoogleSheetsServiceManager._();

  final Map<SheetType, GoogleSheetsService> _services = {};
  bool _isInitialized = false;
  bool _isInitializing = false;

  bool get isInitialized => _isInitialized;
  bool get isInitializing => _isInitializing;

  /// Initialize all Google Sheets services
  Future<void> initAllServices() async {
    if (_isInitialized) {
      HLoggerHelper.debug('All Google Sheets services already initialized');
      return;
    }

    if (_isInitializing) {
      HLoggerHelper.debug('Google Sheets services initialization already in progress');
      return;
    }

    _isInitializing = true;

    try {
      HLoggerHelper.info('Initializing all Google Sheets services...');

      // Initialize services for all sheet types
      final futures = SheetType.values.map((sheetType) => _initService(sheetType));
      await Future.wait(futures);

      _isInitialized = true;
      HLoggerHelper.info('All Google Sheets services initialized successfully');
    } catch (e) {
      HLoggerHelper.error('Error initializing Google Sheets services: $e');
      _isInitialized = false;
      rethrow;
    } finally {
      _isInitializing = false;
    }
  }

  /// Initialize a specific service
  Future<void> _initService(SheetType sheetType) async {
    try {
      HLoggerHelper.debug('Initializing service for $sheetType');
      final service = GoogleSheetsService(sheetType: sheetType);
      await service.init();
      _services[sheetType] = service;

      // Register with GetX for dependency injection
      Get.put<GoogleSheetsService>(service, tag: sheetType.name);

      HLoggerHelper.debug('Service initialized successfully for $sheetType');
    } catch (e) {
      HLoggerHelper.error('Error initializing service for $sheetType: $e');
      rethrow;
    }
  }

  /// Get service for a specific sheet type
  GoogleSheetsService getService(SheetType sheetType) {
    if (!_isInitialized) {
      throw Exception('GoogleSheetsServiceManager not initialized. Call initAllServices() first.');
    }

    final service = _services[sheetType];
    if (service == null) {
      throw Exception('Service not found for $sheetType');
    }

    return service;
  }

  /// Check if a specific service is ready
  bool isServiceReady(SheetType sheetType) {
    final service = _services[sheetType];
    return service?.isReady ?? false;
  }

  /// Get all initialized services
  Map<SheetType, GoogleSheetsService> get allServices => Map.unmodifiable(_services);

  /// Refresh all services
  Future<void> refreshAllServices() async {
    if (!_isInitialized) {
      HLoggerHelper.warning('Cannot refresh services: not initialized');
      return;
    }

    try {
      HLoggerHelper.info('Refreshing all Google Sheets services...');
      final futures = _services.values.map((service) => service.refresh());
      await Future.wait(futures);
      HLoggerHelper.info('All services refreshed successfully');
    } catch (e) {
      HLoggerHelper.error('Error refreshing services: $e');
    }
  }

  /// Refresh a specific service
  Future<void> refreshService(SheetType sheetType) async {
    if (!_isInitialized) {
      HLoggerHelper.warning('Cannot refresh service: manager not initialized');
      return;
    }

    final service = _services[sheetType];
    if (service == null) {
      HLoggerHelper.warning('Cannot refresh service: service not found for $sheetType');
      return;
    }

    try {
      await service.refresh();
      HLoggerHelper.debug('Service refreshed successfully for $sheetType');
    } catch (e) {
      HLoggerHelper.error('Error refreshing service for $sheetType: $e');
    }
  }

  /// Get initialization status for all services
  Map<SheetType, bool> get initializationStatus {
    return Map.fromEntries(SheetType.values.map((sheetType) => MapEntry(sheetType, _services[sheetType]?.isInitialized ?? false)));
  }

  /// Dispose all services
  void dispose() {
    HLoggerHelper.info('Disposing all Google Sheets services...');

    for (final service in _services.values) {
      service.dispose();
    }

    _services.clear();
    _isInitialized = false;
    _isInitializing = false;

    HLoggerHelper.info('All Google Sheets services disposed');
  }

  /// Dispose a specific service
  void disposeService(SheetType sheetType) {
    final service = _services[sheetType];
    if (service != null) {
      service.dispose();
      _services.remove(sheetType);
      Get.delete<GoogleSheetsService>(tag: sheetType.name);
      HLoggerHelper.debug('Service disposed for $sheetType');
    }
  }
}
