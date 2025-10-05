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
          future: initServices(),
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
                      'Please wait while services are initialized...',
                      style: context.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: context.colorScheme.primary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const CircularProgressIndicator(),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              // Show error state
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: context.colorScheme.error),
                      const SizedBox(height: 16),
                      Text('Initialization Failed', style: context.textTheme.headlineSmall?.copyWith(color: context.colorScheme.error)),
                      const SizedBox(height: 8),
                      Text(snapshot.error.toString(), style: context.textTheme.bodyMedium, textAlign: TextAlign.center),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Restart the app or retry initialization
                          Get.offAllNamed(HRoutesName.splash);
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              // Successfully initialized, navigate to home
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
