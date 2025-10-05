import 'package:flat_logging/app/views/home/Widget/feature_card.dart';
import 'package:flat_logging/app/views/home/controllers/home_controller.dart';
import 'package:flat_logging/core/routes/arguments.dart';
import 'package:flat_logging/core/routes/route_name.dart';
import 'package:flat_logging/core/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController(), tag: 'home_controller');
    return Scaffold(
      appBar: AppBar(title: Text('Welcome ${controller.userName}')),
      body: Center(
        child: Obx(
          () => controller.isLoading.value
              ? const CircularProgressIndicator()
              : ListView(
                  padding: const EdgeInsets.all(HSizes.spacingMD),
                  children: [
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      childAspectRatio: 1,
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        FeatureCard(
                          title: "Laundry",
                          icon: Icons.local_laundry_service,
                          onTap: () => Get.toNamed(HRoutesName.laundryListView, arguments: LaundryServiceArguments(serviceType: "Laundry")),
                        ),
                        FeatureCard(
                          title: "Tiffin",
                          icon: Icons.fastfood,
                          onTap: () => Get.toNamed(HRoutesName.tiffinListView, arguments: TiffinServiceArguments(serviceType: "Tiffin")),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
