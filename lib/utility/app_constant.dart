import 'package:flutter/material.dart';

class AppConstant {
  static Color dark = Colors.white;
  static Color bgColor = Colors.black;
  static Color yellowColor = const Color.fromARGB(255, 210, 228, 106);

  static String appName = 'Real Post.';
  static String pageDisplayName = '/displayName';

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
