import 'package:get/get.dart';

class AppSnackBar {
  void normalSnackBar({required String title, required String message}) {
    Get.snackbar(title, message,
        snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 1));
  }
}
