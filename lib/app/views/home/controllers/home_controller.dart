import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find<HomeController>(tag: 'home_controller');

  //  start loading data through gsheet service on a dfferent

  /// Variables
  final isLoading = false.obs;
  String userName = "User";

  /// Functions
}
