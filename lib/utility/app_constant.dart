import 'package:flutter/material.dart';

class AppConstant {
  static Color dark = Colors.white;
  static Color bgColor = Colors.black;
  static Color spcialColor = Colors.white;
  static Color grey = Colors.grey.shade700;

  static String appName = 'Real Post.';

  static String pagePhoneNumber = '/phoneNumber';
  static String pageMainHome = '/mainHome';

  TextStyle h1Style({Color? color, double? size}) {
    return TextStyle(
      fontSize: size ?? 36,
      color: color ?? dark,
      fontWeight: FontWeight.bold,
      fontFamily: 'Sarabun',
    );
  }

  TextStyle h2Style({Color? color, double? size}) {
    return TextStyle(
      fontSize: size ?? 20,
      color: color ?? dark,
      fontWeight: FontWeight.w700,
      fontFamily: 'Sarabun',
    );
  }

  TextStyle h3Style({Color? color, double? size}) {
    return TextStyle(
      fontSize: size ?? 14,
      color: color ?? dark,
      fontWeight: FontWeight.normal,
      fontFamily: 'Sarabun',
    );
  }
}
