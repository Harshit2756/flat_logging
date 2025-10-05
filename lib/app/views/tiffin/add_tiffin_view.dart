import 'package:flat_logging/app/views/tiffin/controllers/tiffin_controller.dart';
import 'package:flat_logging/app/views/tiffin/widget/user_tiffin_row.dart';
import 'package:flat_logging/core/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddTiffinView extends StatelessWidget {
  const AddTiffinView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TiffinController());

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
              child: Column(
                children: [
                  Text(
                    'Split tiffins by shares among users',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).primaryColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: HSizes.spacingMD),

                  // Total Tiffins Counter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Total Tiffins:', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(width: HSizes.spacingMD),

                      // Decrease
                      GestureDetector(
                        onTap: () {
                          if (controller.totalTiffinsCount.value > 1) {
                            controller.setTotalTiffins(controller.totalTiffinsCount.value - 1);
                          }
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: const Icon(Icons.remove, size: 18),
                        ),
                      ),
                      const SizedBox(width: HSizes.spacingMD),

                      // Count Display
                      Obx(
                        () => Container(
                          constraints: const BoxConstraints(minWidth: 50),
                          padding: const EdgeInsets.symmetric(horizontal: HSizes.spacingMD, vertical: HSizes.spacingSM),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            controller.totalTiffinsCount.value.toString(),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(width: HSizes.spacingMD),

                      // Increase
                      GestureDetector(
                        onTap: () => controller.setTotalTiffins(controller.totalTiffinsCount.value + 1),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: const Icon(Icons.add, size: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Shares Summary
            Obx(() {
              final totalShares = controller.totalShares;
              if (totalShares > 0) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(HSizes.spacingMD),
                  color: Colors.blue.shade50,
                  child: Text(
                    'Total Shares: $totalShares | Each share = ${(controller.totalTiffinsCount.value / totalShares).toStringAsFixed(2)} tiffins',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.blue.shade900, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            // User List
            Expanded(
              child: Obx(() {
                if (controller.userTiffinEntries.isEmpty) {
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
                  itemCount: controller.userTiffinEntries.length,
                  itemBuilder: (context, index) {
                    final entry = controller.userTiffinEntries[index];
                    final calculatedQty = controller.getUserQuantity(index);

                    return UserTiffinRow(
                      user: entry.user,
                      date: entry.date,
                      quantity: entry.shares, // This is now "shares"
                      calculatedQuantity: calculatedQty, // Add this parameter
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
                  onPressed: controller.isLoading.value ? null : controller.addTiffin,
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

  Future<void> _showDatePicker(BuildContext context, TiffinController controller, int index) async {
    final entry = controller.userTiffinEntries[index];

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
