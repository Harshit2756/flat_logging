import 'package:flat_logging/app/views/laundry/controllers/laundary_controller.dart';
import 'package:flat_logging/core/utils/constants/sizes.dart';
import 'package:flat_logging/app/views/laundry/widget/user_laundry_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddLaundryView extends StatelessWidget {
  const AddLaundryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LaundryController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Split by shares'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Get.back()),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(HSizes.spacingMD),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                border: Border(bottom: BorderSide(color: Theme.of(context).primaryColor.withValues(alpha: 0.2), width: 1)),
              ),
              child: Text(
                'Select users and set quantities for laundry',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).primaryColor),
                textAlign: TextAlign.center,
              ),
            ),

            // User List
            Expanded(
              child: Obx(() {
                if (controller.userLaundryEntries.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, size: 48, color: Colors.grey),
                        SizedBox(height: HSizes.spacingMD),
                        Text('No users available. Please add users first.'),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(HSizes.spacingMD),
                  itemCount: controller.userLaundryEntries.length,
                  itemBuilder: (context, index) {
                    final entry = controller.userLaundryEntries[index];

                    return UserLaundryRow(
                      user: entry.user,
                      date: entry.date,
                      quantity: entry.quantity,
                      isSelected: entry.isSelected,
                      onDateTap: () => _showDatePicker(context, controller, index),
                      onSelectionChanged: () => controller.toggleUserSelection(index),
                      onQuantityDecrease: () => controller.decreaseUserQuantity(index),
                      onQuantityIncrease: () => controller.increaseUserQuantity(index),
                    );
                  },
                );
              }),
            ),

            // Error Message
            Obx(() {
              if (controller.hasError.value) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(HSizes.spacingMD),
                  padding: const EdgeInsets.all(HSizes.spacingMD),
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.errorContainer, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Theme.of(context).colorScheme.onErrorContainer),
                      const SizedBox(width: HSizes.spacingSM),
                      Expanded(
                        child: Text(controller.errorMessage.value, style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer)),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            // Submit Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(HSizes.spacingMD),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.addLaundry,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: HSizes.spacingMD),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: controller.isLoading.value
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white))),
                            SizedBox(width: HSizes.spacingSM),
                            Text('Adding...'),
                          ],
                        )
                      : const Text('Add Selected Entries'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context, LaundryController controller, int index) async {
    final entry = controller.userLaundryEntries[index];

    // Parse current date
    final currentDateParts = entry.date.split('/');
    DateTime initialDate = DateTime.now();

    if (currentDateParts.length == 3) {
      try {
        initialDate = DateTime(
          int.parse(currentDateParts[2]), // year
          int.parse(currentDateParts[1]), // month
          int.parse(currentDateParts[0]), // day
        );
      } catch (e) {
        // If parsing fails, use current date
        initialDate = DateTime.now();
      }
    }

    final date = await showDatePicker(context: context, initialDate: initialDate, firstDate: DateTime(2020), lastDate: DateTime.now());

    if (date != null) {
      final formattedDate = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      controller.updateUserDate(index, formattedDate);
    }
  }
}
