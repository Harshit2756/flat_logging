import 'package:flat_logging/core/routes/route_name.dart';
import 'package:flat_logging/core/theme/theme_extensions.dart';
import 'package:flat_logging/init_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [context.colorScheme.primary, Colors.white], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: FutureBuilder(
          future: Future.wait([initServices()]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary,
                        borderRadius: BorderRadius.circular(60),
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
                      ),
                      child: const Center(
                        child: FlutterLogo(size: 80, style: FlutterLogoStyle.stacked, textColor: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Pls Wait till all the services are initialized...',
                      style: context.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: context.colorScheme.primary),
                    ),
                    const SizedBox(height: 20),
                    const CircularProgressIndicator(),
                  ],
                ),
              );
            } else {
              // Once initialization is complete, navigate to the home screen
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Get.offAllNamed(HRoutesName.home);
              });
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
