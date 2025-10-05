import 'package:flat_logging/app/services/google_sheets_service_manager.dart';
import 'package:flat_logging/core/utils/helpers/logger.dart';
import 'package:get/get.dart';

/// Initialize critical services before app starts (call in main)
Future<void> initCriticalServices() async {
  try {
    HLoggerHelper.info('Initializing critical services...');

    // Put the instance first without waiting
    Get.put<GoogleSheetsServiceManager>(GoogleSheetsServiceManager.instance, permanent: true);

    HLoggerHelper.info('Critical services initialized');
  } catch (e) {
    HLoggerHelper.error('Error initializing critical services: $e');
    rethrow;
  }
}

/// Initialize all services (call in splash screen)
Future<void> initServices() async {
  try {
    HLoggerHelper.info('Initializing all services...');

    // Get the already registered instance
    final manager = Get.find<GoogleSheetsServiceManager>();

    // Initialize the services
    await manager.initAllServices();

    HLoggerHelper.info('All services initialized successfully');
  } catch (e) {
    HLoggerHelper.error('Error initializing services: $e');
    rethrow;
  }
}
