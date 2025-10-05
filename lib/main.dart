import 'package:flat_logging/core/routes/route_name.dart';
import 'package:flat_logging/core/routes/routes.dart';
import 'package:flat_logging/init_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Pre-initialize critical services before app starts
  await initCriticalServices();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flat Logging',
      debugShowCheckedModeBanner: false,
      theme: HAppTheme.lightTheme,
      initialRoute: HAppRoutes.initial,
      getPages: HAppRoutes.routes,
      defaultTransition: Transition.fade,
      unknownRoute: HAppRoutes.routes.firstWhere((page) => page.name == HRoutesName.notFound),
    );
  }
}
