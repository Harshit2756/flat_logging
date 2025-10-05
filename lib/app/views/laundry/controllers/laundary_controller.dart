import 'package:flat_logging/app/models/laundry_model.dart';
import 'package:flat_logging/app/models/user_laundry_entry.dart';
import 'package:flat_logging/app/models/user_model.dart';
import 'package:flat_logging/app/repository/user_repository.dart';
import 'package:flat_logging/app/views/laundry/repository/laundry_repository.dart';
import 'package:flat_logging/core/routes/route_name.dart';
import 'package:flat_logging/core/utils/helpers/helper_functions.dart';
import 'package:flat_logging/core/utils/helpers/logger.dart';
import 'package:flat_logging/core/widgets/snackbar/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

class LaundryController extends GetxController {
  static LaundryController get instance => Get.find();
  final LaundryRepository _laundryRepository = Get.put(LaundryRepository());
  final UserRepository _userRepository = Get.put(UserRepository());

  /// Variables
  final isLoading = false.obs;
  final isLoadingList = false.obs;
  final isRefreshing = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final allLaundryList = <LaundryModel>[].obs;
  final filteredLaundryList = <LaundryModel>[].obs;
  final allUsers = <UserModel>[].obs;
  final userLaundryEntries = <UserLaundryEntry>[].obs;
  final formKey = GlobalKey<FormState>();
  final searchController = SearchController();

  // Filter variables
  final selectedMonth = DateTime.now().month.obs;
  final selectedYear = DateTime.now().year.obs;
  final selectedUser = Rxn<String>(); // null means "All Users"
  final userMonthlyCounts = <String, num>{}.obs;

  void clearForm() {
    userLaundryEntries.clear();
  }

  void clearError() {
    hasError.value = false;
    errorMessage.value = '';
  }

  /// Load users for dropdown
  Future<void> loadUsers() async {
    try {
      if (!_userRepository.isServiceReady) {
        throw Exception('User service is not ready. Please try again.');
      }

      final users = await _userRepository.getAllUsers();
      HLoggerHelper.debug('$users');
      allUsers.value = users;

      // Initialize user laundry entries
      _initializeUserLaundryEntries(users);
    } catch (e) {
      HLoggerHelper.error('Error loading users: $e');
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  /// Initialize user laundry entries with default values
  void _initializeUserLaundryEntries(List<UserModel> users) {
    final today = DateTime.now();
    final formattedDate = '${today.day.toString().padLeft(2, '0')}/${today.month.toString().padLeft(2, '0')}/${today.year}';

    userLaundryEntries.value = users.map((user) => UserLaundryEntry(user: user, date: formattedDate, quantity: 0, isSelected: false)).toList();
  }

  /// Update user selection
  void toggleUserSelection(int index) {
    if (index >= 0 && index < userLaundryEntries.length) {
      userLaundryEntries[index] = userLaundryEntries[index].copyWith(isSelected: !userLaundryEntries[index].isSelected);
    }
  }

  /// Update user date
  void updateUserDate(int index, String date) {
    if (index >= 0 && index < userLaundryEntries.length) {
      userLaundryEntries[index] = userLaundryEntries[index].copyWith(date: date);
    }
  }

  /// Update user quantity
  void updateUserQuantity(int index, int quantity) {
    if (index >= 0 && index < userLaundryEntries.length) {
      userLaundryEntries[index] = userLaundryEntries[index].copyWith(quantity: quantity);
    }
  }

  /// Increase user quantity
  void increaseUserQuantity(int index) {
    if (index >= 0 && index < userLaundryEntries.length) {
      final currentQuantity = userLaundryEntries[index].quantity;
      userLaundryEntries[index] = userLaundryEntries[index].copyWith(quantity: currentQuantity + 1);
    }
  }

  /// Decrease user quantity
  void decreaseUserQuantity(int index) {
    if (index >= 0 && index < userLaundryEntries.length) {
      final currentQuantity = userLaundryEntries[index].quantity;
      if (currentQuantity > 0) {
        userLaundryEntries[index] = userLaundryEntries[index].copyWith(quantity: currentQuantity - 1);
      }
    }
  }

  /// Filter laundry by month/year and user
  void applyFilters() {
    filteredLaundryList.value = allLaundryList.where((laundry) {
      // Parse date - check which delimiter is used
      final dateParts = laundry.date.contains('-') ? laundry.date.split('-') : laundry.date.split('/');

      if (dateParts.length != 3) return false;

      final day = int.tryParse(dateParts[0]);
      final month = int.tryParse(dateParts[1]);
      final year = int.tryParse(dateParts[2]);
      // HLoggerHelper.debug('$selectedUser => $month : $selectedMonth | $year : $selectedYear');

      if (day == null || month == null || year == null) return false;

      // Filter by month and year
      bool matchesDate = month == selectedMonth.value && year == selectedYear.value;

      // Filter by user (if selected)
      bool matchesUser = selectedUser.value == null || laundry.user == selectedUser.value;

      return matchesDate && matchesUser;
    }).toList();

    // Calculate monthly counts per user
    calculateUserMonthlyCounts();
  }

  /// Calculate total count for each user in selected month
  void calculateUserMonthlyCounts() {
    final counts = <String, num>{};

    for (var laundry in allLaundryList) {
      // Parse date - check which delimiter is used
      final dateParts = laundry.date.contains('-') ? laundry.date.split('-') : laundry.date.split('/');

      if (dateParts.length != 3) continue;

      final month = int.tryParse(dateParts[1]);
      final year = int.tryParse(dateParts[2]);

      if (month == null || year == null) continue;

      // HLoggerHelper.info('Processing: ${laundry.user} - Month: $month, Year: $year');

      // Only count if matches selected month/year
      if (month == selectedMonth.value && year == selectedYear.value) {
        counts[laundry.user] = (counts[laundry.user] ?? 0) + laundry.quantity;
        HLoggerHelper.info('Count for ${laundry.user}: ${counts[laundry.user]}');
      }
    }

    HLoggerHelper.info('Final counts: $counts');
    userMonthlyCounts.value = counts;
  }

  /// Update selected month
  void updateMonth(int month) {
    selectedMonth.value = month;
    applyFilters();
  }

  /// Update selected year
  void updateYear(int year) {
    selectedYear.value = year;
    applyFilters();
  }

  /// Update selected user filter
  void updateUserFilter(String? user) {
    selectedUser.value = user;
    applyFilters();
  }

  /// Reset filters to current month
  void resetFilters() {
    selectedMonth.value = DateTime.now().month;
    selectedYear.value = DateTime.now().year;
    selectedUser.value = null;
    applyFilters();
  }

  /// Get All Laundry
  Future<void> getAllLaundry({bool isFromApi = false}) async {
    if (isLoadingList.value) return;

    isLoadingList.value = true;
    clearError();

    try {
      // Check if service is ready
      if (!_laundryRepository.isServiceReady) {
        throw Exception('Google Sheets service is not ready. Please try again.');
      }

      final laundries = await _laundryRepository.getAllLaundry();

      allLaundryList.value = laundries;
      HLoggerHelper.debug('apply filters called $laundries ');
      applyFilters(); // Apply filters after loading data
    } catch (e) {
      HLoggerHelper.error('Error getting laundries: $e');
      hasError.value = true;
      errorMessage.value = e.toString();
      HSnackbars.showSnackbar(type: SnackbarType.error, message: 'Failed to load laundries: ${e.toString()}');
    } finally {
      isLoadingList.value = false;
    }
  }

  /// Refresh data
  Future<void> refreshData() async {
    if (isRefreshing.value) return;

    isRefreshing.value = true;
    clearError();

    try {
      await _laundryRepository.refreshData();
      await getAllLaundry(isFromApi: true);
    } catch (e) {
      HLoggerHelper.error('Error refreshing data: $e');
      hasError.value = true;
      errorMessage.value = e.toString();
      HSnackbars.showSnackbar(type: SnackbarType.error, message: 'Failed to refresh data: ${e.toString()}');
    } finally {
      isRefreshing.value = false;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    getAllLaundry();
    loadUsers();
  }

  /// Add Laundry
  Future<void> addLaundry() async {
    if (isLoading.value) return;

    isLoading.value = true;
    clearError();

    try {
      // Check if service is ready
      if (!_laundryRepository.isServiceReady) {
        throw Exception('Google Sheets service is not ready. Please try again.');
      }

      // Get selected entries with quantity > 0
      final selectedEntries = userLaundryEntries.where((entry) => entry.isSelected && entry.quantity > 0).toList();

      if (selectedEntries.isEmpty) {
        throw Exception('Please select at least one user with quantity greater than 0');
      }

      // Add each selected entry
      int successCount = 0;
      for (final entry in selectedEntries) {
        final laundry = LaundryModel(
          id: HHelperFunctions.generateUniqueId(prefix: entry.user.name),
          date: entry.date,
          user: entry.user.name,
          quantity: entry.quantity,
        );

        final success = await _laundryRepository.addLaundry(laundry);
        if (success) {
          successCount++;
        }
      }

      if (successCount == selectedEntries.length) {
        clearForm();
        Get.back();
        await getAllLaundry();
        HSnackbars.showSnackbar(type: SnackbarType.success, message: 'Successfully added $successCount laundry entries');
      } else {
        throw Exception('Failed to add some laundry entries');
      }
    } catch (e) {
      HLoggerHelper.error('Error adding Laundry: $e');
      hasError.value = true;
      errorMessage.value = e.toString();
      HSnackbars.showSnackbar(type: SnackbarType.error, message: 'Failed to add Laundry: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete Laundry
  Future<void> deleteLaundry(String id, String user) async {
    if (isLoading.value) return;

    isLoading.value = true;
    clearError();

    try {
      // Check if service is ready
      if (!_laundryRepository.isServiceReady) {
        throw Exception('Google Sheets service is not ready. Please try again.');
      }

      final success = await _laundryRepository.deleteLaundry(id: id);
      if (success) {
        await getAllLaundry();
        HSnackbars.showSnackbar(type: SnackbarType.success, message: 'Laundry record for $user deleted successfully');
      } else {
        throw Exception('Failed to delete Laundry');
      }
    } catch (e) {
      HLoggerHelper.error('Error deleting Laundry: $e');
      hasError.value = true;
      errorMessage.value = e.toString();
      HSnackbars.showSnackbar(type: SnackbarType.error, message: 'Failed to delete Laundry: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void showAddLaundry() async {
    clearForm();
    clearError();
    await loadUsers();

    Get.toNamed(HRoutesName.addLaundry);
  }

  /// Retry loading data
  Future<void> retryLoading() async {
    await getAllLaundry(isFromApi: true);
  }

  /// Get total count
  Future<int> getTotalCount() async {
    try {
      return await _laundryRepository.getTotalCount();
    } catch (e) {
      HLoggerHelper.error('Error getting total count: $e');
      return 0;
    }
  }

  /// Get month name
  String getMonthName(int month) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return months[month - 1];
  }
}
