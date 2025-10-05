import 'package:flat_logging/app/services/google_sheets_service_manager.dart';
import 'package:flat_logging/app/services/local_db/storage_service.dart';
import 'package:flat_logging/core/utils/helpers/logger.dart';
import 'package:get/get.dart';

Future<void> initServices() async {
  try {
    HLoggerHelper.info('Starting service initialization...');

    // Initialize storage service first
    await Get.putAsync<StorageService>(() async => StorageService().init(), permanent: true);
    HLoggerHelper.info('Storage service initialized successfully');

    // Initialize Google Sheets Service Manager
    await Get.putAsync<GoogleSheetsServiceManager>(() async {
      final manager = GoogleSheetsServiceManager.instance;
      await manager.initAllServices();
      return manager;
    }, permanent: true);
    HLoggerHelper.info('Google Sheets Service Manager initialized successfully');

    HLoggerHelper.info('All services initialized successfully');
  } catch (e) {
    HLoggerHelper.error('Error initializing services: $e');
    rethrow;
  }
}
