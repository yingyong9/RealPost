import 'package:flutter/material.dart';

class AppConstant {
  static Color dark = Colors.white;
  static Color bgColor = Color.fromARGB(255, 1, 50, 50);
  static Color lightColor = Color.fromARGB(255, 1, 88, 79);
  static Color spcialColor = Colors.white;
  static Color grey = Colors.grey.shade700;

  static String appName = 'Real Post.';

  static String pagePhoneNumber = '/phoneNumber';
  static String pageMainHome = '/mainHome';

  BoxDecoration boxChatLogin() {
    return BoxDecoration(
      color: lightColor,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      ),
    );
  }

  BoxDecoration boxChatGuest() {
    return BoxDecoration(
      color: lightColor,
      borderRadius: BorderRadius.only(topRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      ),
    );
  }

  TextStyle h1Style({Color? color, double? size}) {
    return TextStyle(
      fontSize: size ?? 36,
      color: color ?? dark,
      fontWeight: FontWeight.bold,
      fontFamily: 'Sarabun',
    );
  }

  TextStyle h2Style({Color? color, double? size, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: size ?? 20,
      color: color ?? dark,
      fontWeight: fontWeight ?? FontWeight.w700,
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
