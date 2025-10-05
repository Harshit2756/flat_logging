import 'package:flat_logging/app/models/tiffin_model.dart';
import 'package:flat_logging/app/models/user_model.dart';
import 'package:flat_logging/app/models/user_tiffin_entry.dart';
import 'package:flat_logging/app/repository/user_repository.dart';
import 'package:flat_logging/app/views/tiffin/repository/tiffin_repository.dart';
import 'package:flat_logging/core/routes/route_name.dart';
import 'package:flat_logging/core/utils/helpers/helper_functions.dart';
import 'package:flat_logging/core/utils/helpers/logger.dart';
import 'package:flat_logging/core/widgets/snackbar/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

class TiffinController extends GetxController {
  static TiffinController get instance => Get.find();
  final TiffinRepository _tiffinRepository = Get.put(TiffinRepository());
  final UserRepository _userRepository = Get.put(UserRepository());

  /// Variables
  final isLoading = false.obs;
  final isLoadingList = false.obs;
  final isRefreshing = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final allTiffinList = <TiffinModel>[].obs;
  final filteredTiffinList = <TiffinModel>[].obs;
  final allUsers = <UserModel>[].obs;
  final userTiffinEntries = <UserTiffinEntry>[].obs;
  final formKey = GlobalKey<FormState>();
  final searchController = SearchController();
  final totalTiffinsCount = 1.obs;

  // Filter variables
  final selectedMonth = DateTime.now().month.obs;
  final selectedYear = DateTime.now().year.obs;
  final selectedUser = Rxn<String>();
  final userMonthlyCounts = <String, num>{}.obs;

  void clearForm() {
    userTiffinEntries.clear();
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

      // Initialize user tiffin entries
      _initializeUserTiffinEntries(users);
    } catch (e) {
      HLoggerHelper.error('Error loading users: $e');
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  int get totalShares => userTiffinEntries.where((entry) => entry.isSelected).fold(0, (sum, entry) => sum + entry.shares);

  /// Initialize user tiffin entries with default values
  void _initializeUserTiffinEntries(List<UserModel> users) {
    final today = DateTime.now();
    final formattedDate = '${today.day.toString().padLeft(2, '0')}/${today.month.toString().padLeft(2, '0')}/${today.year}';

    userTiffinEntries.value = users
        .map(
          (user) => UserTiffinEntry(
            user: user,
            date: formattedDate,
            shares: 1, // Default to 1 share instead of 0
            isSelected: false,
          ),
        )
        .toList();
  }

  /// Set total tiffins count
  void setTotalTiffins(int count) {
    if (count > 0) {
      totalTiffinsCount.value = count;
    }
  }

  /// Get calculated quantity for a user based on their shares
  double getUserQuantity(int index) {
    if (index < 0 || index >= userTiffinEntries.length) return 0;

    final entry = userTiffinEntries[index];
    if (!entry.isSelected) return 0;

    final total = totalShares;
    if (total == 0) return 0;

    return (entry.shares / total) * totalTiffinsCount.value;
  }

  /// Get all users' calculated quantities
  Map<String, double> getAllUserQuantities() {
    final quantities = <String, double>{};
    final total = totalShares;

    if (total == 0) return quantities;

    for (var entry in userTiffinEntries) {
      if (entry.isSelected && entry.shares > 0) {
        quantities[entry.user.name] = (entry.shares / total) * totalTiffinsCount.value;
      }
    }

    return quantities;
  }

  /// Add Tiffin with sharing logic
  Future<void> addTiffin() async {
    if (isLoading.value) return;

    isLoading.value = true;
    clearError();

    try {
      if (!_tiffinRepository.isServiceReady) {
        throw Exception('Google Sheets service is not ready. Please try again.');
      }

      // Get selected entries
      final selectedEntries = userTiffinEntries.where((entry) => entry.isSelected && entry.shares > 0).toList();

      if (selectedEntries.isEmpty) {
        throw Exception('Please select at least one user with shares greater than 0');
      }

      // Calculate total shares
      final total = totalShares;
      if (total == 0) {
        throw Exception('Total shares cannot be 0');
      }

      // Validate that shares add up correctly
      final quantities = getAllUserQuantities();
      final totalQuantity = quantities.values.fold(0.0, (sum, qty) => sum + qty);

      if ((totalQuantity - totalTiffinsCount.value).abs() > 0.01) {
        HLoggerHelper.warning('Total calculated: $totalQuantity, Expected: ${totalTiffinsCount.value}');
      }

      // Add each selected entry with calculated shares
      int successCount = 0;
      for (final entry in selectedEntries) {
        final calculatedQuantity = (entry.shares / total) * totalTiffinsCount.value;

        final tiffin = TiffinModel(
          id: HHelperFunctions.generateUniqueId(prefix: entry.user.name),
          date: entry.date,
          user: entry.user.name,
          quantity: calculatedQuantity, // Store the calculated split shares
        );

        final success = await _tiffinRepository.addTiffin(tiffin);
        if (success) {
          successCount++;
        }
      }

      if (successCount == selectedEntries.length) {
        clearForm();
        Get.back();
        await getAllTiffin();
        HSnackbars.showSnackbar(type: SnackbarType.success, message: 'Successfully split $totalTiffinsCount tiffins among $successCount users');
      } else {
        throw Exception('Failed to add some tiffin entries');
      }
    } catch (e) {
      HLoggerHelper.error('Error adding Tiffin: $e');
      hasError.value = true;
      errorMessage.value = e.toString();
      HSnackbars.showSnackbar(type: SnackbarType.error, message: 'Failed to add Tiffin: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Update user selection
  void toggleUserSelection(int index) {
    if (index >= 0 && index < userTiffinEntries.length) {
      userTiffinEntries[index] = userTiffinEntries[index].copyWith(isSelected: !userTiffinEntries[index].isSelected);
    }
  }

  /// Update user date
  void updateUserDate(int index, String date) {
    if (index >= 0 && index < userTiffinEntries.length) {
      userTiffinEntries[index] = userTiffinEntries[index].copyWith(date: date);
    }
  }

  /// Update user quantity
  void updateUserQuantity(int index, int quantity) {
    if (index >= 0 && index < userTiffinEntries.length) {
      userTiffinEntries[index] = userTiffinEntries[index].copyWith(quantity: quantity);
    }
  }

  /// Increase user quantity
  void increaseUserQuantity(int index) {
    if (index >= 0 && index < userTiffinEntries.length) {
      final currentQuantity = userTiffinEntries[index].shares;
      userTiffinEntries[index] = userTiffinEntries[index].copyWith(quantity: currentQuantity + 1);
    }
  }

  /// Decrease user quantity
  void decreaseUserQuantity(int index) {
    if (index >= 0 && index < userTiffinEntries.length) {
      final currentQuantity = userTiffinEntries[index].shares;
      if (currentQuantity > 0) {
        userTiffinEntries[index] = userTiffinEntries[index].copyWith(quantity: currentQuantity - 1);
      }
    }
  }

  /// Filter tiffin by month/year and user
  void applyFilters() {
    filteredTiffinList.value = allTiffinList.where((tiffin) {
      // Parse date - check which delimiter is used
      HLoggerHelper.debug('all the values at start of flter: $tiffin');

      final dateParts = tiffin.date.contains('-') ? tiffin.date.split('-') : tiffin.date.split('/');

      if (dateParts.length != 3) return false;

      final day = int.tryParse(dateParts[0]);
      final month = int.tryParse(dateParts[1]);
      final year = int.tryParse(dateParts[2]);

      if (day == null || month == null || year == null) return false;

      // Filter by month and year
      bool matchesDate = month == selectedMonth.value && year == selectedYear.value;

      // Filter by user (if selected)
      bool matchesUser = selectedUser.value == null || tiffin.user == selectedUser.value;

      HLoggerHelper.debug('all ${matchesDate && matchesUser}=> $month:$selectedMonth | ${tiffin.user}:$selectedUser ');

      return matchesDate && matchesUser;
    }).toList();

    // Calculate monthly counts per user
    calculateUserMonthlyCounts();
  }

  /// Calculate total count for each user in selected month
  void calculateUserMonthlyCounts() {
    final counts = <String, num>{};

    for (var tiffin in allTiffinList) {
      // Parse date - check which delimiter is used
      HLoggerHelper.debug('count : $tiffin');

      final dateParts = tiffin.date.contains('-') ? tiffin.date.split('-') : tiffin.date.split('/');

      if (dateParts.length != 3) continue;

      final month = int.tryParse(dateParts[1]);
      final year = int.tryParse(dateParts[2]);

      if (month == null || year == null) continue;

      // Only count if matches selected month/year
      HLoggerHelper.debug('count for user: ${tiffin.user}');
      if (month == selectedMonth.value && year == selectedYear.value) {
        HLoggerHelper.debug('true for ${tiffin.user}');
        counts[tiffin.user] = (counts[tiffin.user] ?? 0) + tiffin.quantity;
        HLoggerHelper.info('Count for ${tiffin.user}: ${counts[tiffin.user]}');
      }
    }

    // HLoggerHelper.info('Final counts: $counts');
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

  /// Get All Tiffin
  Future<void> getAllTiffin({bool isFromApi = false}) async {
    if (isLoadingList.value) return;

    isLoadingList.value = true;
    clearError();

    try {
      // Check if service is ready
      if (!_tiffinRepository.isServiceReady) {
        throw Exception('Google Sheets service is not ready. Please try again.');
      }

      final tiffins = await _tiffinRepository.getAllTiffin();
      HLoggerHelper.debug('apply filters called $tiffins ');

      allTiffinList.value = tiffins;
      HLoggerHelper.debug('apply filters called for: $allTiffinList ');

      applyFilters();
    } catch (e) {
      HLoggerHelper.error('Error getting tiffins: $e');
      hasError.value = true;
      errorMessage.value = e.toString();
      HSnackbars.showSnackbar(type: SnackbarType.error, message: 'Failed to load tiffins: ${e.toString()}');
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
      await _tiffinRepository.refreshData();
      await getAllTiffin(isFromApi: true);
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
    getAllTiffin();
    loadUsers();
  }

  /// Add Tiffin
  // Future<void> addTiffin() async {
  //   if (isLoading.value) return;

  //   isLoading.value = true;
  //   clearError();

  //   try {
  //     // Check if service is ready
  //     if (!_tiffinRepository.isServiceReady) {
  //       throw Exception('Google Sheets service is not ready. Please try again.');
  //     }

  //     // Get selected entries with quantity > 0
  //     final selectedEntries = userTiffinEntries.where((entry) => entry.isSelected && entry.shares > 0).toList();

  //     if (selectedEntries.isEmpty) {
  //       throw Exception('Please select at least one user with quantity greater than 0');
  //     }

  //     // Add each selected entry
  //     int successCount = 0;
  //     for (final entry in selectedEntries) {
  //       final tiffin = TiffinModel(
  //         id: HHelperFunctions.generateUniqueId(prefix: entry.user.name),
  //         date: entry.date,
  //         user: entry.user.name,
  //         quantity: entry.shares,
  //       );

  //       final success = await _tiffinRepository.addTiffin(tiffin);
  //       if (success) {
  //         successCount++;
  //       }
  //     }

  //     if (successCount == selectedEntries.length) {
  //       clearForm();
  //       Get.back();
  //       await getAllTiffin();
  //       HSnackbars.showSnackbar(type: SnackbarType.success, message: 'Successfully added $successCount tiffin entries');
  //     } else {
  //       throw Exception('Failed to add some tiffin entries');
  //     }
  //   } catch (e) {
  //     HLoggerHelper.error('Error adding Tiffin: $e');
  //     hasError.value = true;
  //     errorMessage.value = e.toString();
  //     HSnackbars.showSnackbar(type: SnackbarType.error, message: 'Failed to add Tiffin: ${e.toString()}');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  /// Delete Tiffin
  Future<void> deleteTiffin(String id, String user) async {
    if (isLoading.value) return;

    isLoading.value = true;
    clearError();

    try {
      // Check if service is ready
      if (!_tiffinRepository.isServiceReady) {
        throw Exception('Google Sheets service is not ready. Please try again.');
      }

      final success = await _tiffinRepository.deleteTiffin(id: id);
      if (success) {
        await getAllTiffin();
        HSnackbars.showSnackbar(type: SnackbarType.success, message: 'Tiffin record for $user deleted successfully');
      } else {
        throw Exception('Failed to delete Tiffin');
      }
    } catch (e) {
      HLoggerHelper.error('Error deleting Tiffin: $e');
      hasError.value = true;
      errorMessage.value = e.toString();
      HSnackbars.showSnackbar(type: SnackbarType.error, message: 'Failed to delete Tiffin: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void showAddTiffin() async {
    clearForm();
    clearError();
    await loadUsers();

    Get.toNamed(HRoutesName.addTiffin);
  }

  /// Retry loading data
  Future<void> retryLoading() async {
    await getAllTiffin(isFromApi: true);
  }

  /// Get total count
  Future<int> getTotalCount() async {
    try {
      return await _tiffinRepository.getTotalCount();
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
