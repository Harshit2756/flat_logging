import 'package:flat_logging/app/views/home/home_view.dart';
import 'package:flat_logging/app/views/laundry/add_laundry_view.dart';
import 'package:flat_logging/app/views/laundry/laundry_list_view.dart';
import 'package:flat_logging/app/views/splash_view.dart';
import 'package:flat_logging/app/views/tiffin/add_tiffin_view.dart';
import 'package:flat_logging/app/views/tiffin/tiffin_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'route_name.dart';

class HAppRoutes {
  // This is the initial route of your app
  static const initial = HRoutesName.splash;

  // App pages configuration
  static final routes = [
    // Auth Pages
    GetPage(name: HRoutesName.splash, page: () => const SplashView()),
    GetPage(name: HRoutesName.home, page: () => const HomeView()),
    GetPage(name: HRoutesName.laundryListView, page: () => const LaundryListView()),
    GetPage(name: HRoutesName.addLaundry, page: () => const AddLaundryView()),
    GetPage(name: HRoutesName.tiffinListView, page: () => const TiffinListView()),
    GetPage(name: HRoutesName.addTiffin, page: () => const AddTiffinView()),

    // Default route for undefined routes
    GetPage(
      name: HRoutesName.notFound,
      page: () => Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text('Screen does not exist: ${Get.currentRoute}', style: const TextStyle(fontSize: 18))),
      ),
    ),
  ];
}
