import 'package:flat_logging/app/models/tiffin_model.dart';
import 'package:flat_logging/app/views/tiffin/controllers/tiffin_controller.dart';
import 'package:flat_logging/core/theme/theme_extensions.dart';
import 'package:flat_logging/core/utils/constants/sizes.dart';
import 'package:flat_logging/core/utils/helpers/date_helper.dart';
import 'package:flat_logging/core/utils/media/icons_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;

class TiffinListView extends StatelessWidget {
  const TiffinListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TiffinController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tiffin List'),
        actions: [
          Obx(
            () => controller.isRefreshing.value
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                : IconButton(icon: const Icon(Icons.refresh), onPressed: controller.refreshData),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: controller.showAddTiffin, icon: const Icon(HIcons.addUser), label: const Text('Add Tiffin')),
      body: SafeArea(
        child: Obx(() {
          // Show error state
          if (controller.hasError.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: 16),
                  Text('Something went wrong', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(controller.errorMessage.value, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(onPressed: controller.retryLoading, icon: const Icon(Icons.refresh), label: const Text('Retry')),
                ],
              ),
            );
          }

          // Show loading state
          if (controller.isLoadingList.value) {
            return const Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Loading laundries...')]),
            );
          }

          // Show data
          return Column(
            children: [
              // Filter Section
              _buildFilterSection(context, controller),

              // User Monthly Counts Cards
              _buildUserCountsSection(context, controller),

              // const SizedBox(height: HSizes.spacingSM),
              Divider(),

              // Tiffin List
              Expanded(
                child: controller.filteredTiffinList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.fastfood, size: 64),
                            const SizedBox(height: 16),
                            Text(
                              controller.selectedUser.value != null
                                  ? 'No tiffin records found for ${controller.selectedUser.value}'
                                  : 'No tiffin records found for ${controller.getMonthName(controller.selectedMonth.value)} ${controller.selectedYear.value}',
                            ),
                            const SizedBox(height: 8),
                            const Text('Tap the + button to add tiffin'),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(HSizes.spacingMD),
                        separatorBuilder: (context, index) => const SizedBox(height: HSizes.spacingSM),
                        itemCount: controller.filteredTiffinList.length,
                        itemBuilder: (context, index) {
                          final tiffin = controller.filteredTiffinList[index];
                          return Card(
                            elevation: HSizes.elevationLevel3,
                            color: context.colorScheme.primaryContainer,
                            child: ListTile(
                              leading: const Icon(Icons.fastfood, size: HSizes.avatarSize),
                              title: Text(tiffin.user, style: context.textTheme.titleLarge),
                              subtitle: Text(DateHelper.toReadableDate(tiffin.date)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Qty: ${tiffin.quantity.toStringAsFixed(2)}', style: context.textTheme.titleLarge),
                                  const SizedBox(width: 8),
                                  Obx(
                                    () => IconButton(
                                      icon: controller.isLoading.value ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.delete),
                                      onPressed: controller.isLoading.value ? null : () => _showDeleteConfirmation(context, controller, tiffin),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildFilterSection(BuildContext context, TiffinController controller) {
    return Container(
      padding: const EdgeInsets.all(HSizes.spacingMD),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Filters', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const Spacer(),
              TextButton.icon(onPressed: controller.resetFilters, icon: const Icon(Icons.clear, size: 18), label: const Text('Reset')),
            ],
          ),
          const SizedBox(height: HSizes.spacingSM),
          Row(
            children: [
              // Month Dropdown
              Expanded(
                child: Obx(
                  () => DropdownButtonFormField<int>(
                    initialValue: controller.selectedMonth.value,
                    decoration: const InputDecoration(labelText: 'Month', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                    items: List.generate(12, (index) {
                      final month = index + 1;
                      return DropdownMenuItem(value: month, child: Text(controller.getMonthName(month)));
                    }),
                    onChanged: (value) {
                      if (value != null) controller.updateMonth(value);
                    },
                  ),
                ),
              ),
              const SizedBox(width: HSizes.spacingSM),
              // Year Dropdown
              Expanded(
                child: Obx(
                  () => DropdownButtonFormField<int>(
                    initialValue: controller.selectedYear.value,
                    decoration: const InputDecoration(labelText: 'Year', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                    items: List.generate(5, (index) {
                      final year = DateTime.now().year - 2 + index;
                      return DropdownMenuItem(value: year, child: Text(year.toString()));
                    }),
                    onChanged: (value) {
                      if (value != null) controller.updateYear(value);
                    },
                  ),
                ),
              ),
            ],
          ),
          // const SizedBox(height: HSizes.spacingSM),
          // // User Filter Dropdown
          // Obx(
          //   () => DropdownButtonFormField<String?>(
          //     initialValue: controller.selectedUser.value,
          //     decoration: const InputDecoration(labelText: 'Filter by User', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
          //     items: [
          //       const DropdownMenuItem(value: null, child: Text('All Users')),
          //       ...controller.allUsers.map((user) {
          //         return DropdownMenuItem(value: user.name, child: Text(user.name));
          //       }),
          //     ],
          //     onChanged: (value) => controller.updateUserFilter(value),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildUserCountsSection(BuildContext context, TiffinController controller) {
    return Obx(() {
      if (controller.userMonthlyCounts.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: HSizes.spacingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Summary - ${controller.getMonthName(controller.selectedMonth.value)} ${controller.selectedYear.value}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: HSizes.spacingSM),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.userMonthlyCounts.length,
                separatorBuilder: (context, index) => const SizedBox(width: HSizes.spacingXS / 2),
                itemBuilder: (context, index) {
                  final entry = controller.userMonthlyCounts.entries.elementAt(index);
                  final userName = entry.key;
                  final count = entry.value.toStringAsFixed(2);

                  final isSelected = controller.selectedUser.value == userName;

                  return GestureDetector(
                    onTap: () {
                      if (isSelected) {
                        controller.updateUserFilter(null);
                      } else {
                        controller.updateUserFilter(userName);
                      }
                    },
                    child: Card(
                      elevation: isSelected ? 8 : 2,
                      color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
                      child: SizedBox(
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              userName,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : null),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '$count items',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.secondary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  void _showDeleteConfirmation(BuildContext context, TiffinController controller, TiffinModel tiffin) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Tiffin Record'),
          content: Text('Are you sure you want to delete the tiffin record for ${tiffin.user} on ${tiffin.date}?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.deleteTiffin(tiffin.id, tiffin.user);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
