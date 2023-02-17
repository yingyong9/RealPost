import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackBar {
  void normalSnackBar({
    required String title,
    required String message,
    int? second,
    Color? bgColor,
    Color? textColor,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: second ?? 1),
      backgroundColor: bgColor,
      colorText: textColor,
    );
  }
}
