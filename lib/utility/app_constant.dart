import 'package:flutter/material.dart';

class AppConstant {
  static int timeCountsec = 30;

  static String key = '1758532022818591';
  static String secret = '6ee4cbc8611eaa7c3e4ed60b071badf7';

  static Color spColor = const Color(0xff512da8);
  static Color dark = Colors.white;
  static Color bgColor = const Color.fromARGB(255, 1, 50, 50);
  static Color lightColor = const Color.fromARGB(255, 1, 88, 79);
  static Color spcialColor = Colors.white;
  static Color grey = const Color.fromARGB(255, 164, 159, 159);
  static Color bgGrey = const Color.fromARGB(255, 240, 236, 236);

  static String appName = 'Real Post.';
  static String urlAvatar =
      'https://firebasestorage.googleapis.com/v0/b/realpost-19dd3.appspot.com/o/icon%2FReal%20post3.png?alt=media&token=ac968787-b252-4157-9f55-75b2ebec354a';

  static String pagePhoneNumber = '/phoneNumber';
  static String pageMainHome = '/mainHome';

  BoxDecoration borderBox() => BoxDecoration(
      border: Border.all(width: 1), borderRadius: BorderRadius.circular(10));

  BoxDecoration boxBlack({Color? color}) =>
      BoxDecoration(color: color ?? Colors.black12);

  BoxDecoration boxCurve({Color? color}) => BoxDecoration(
      color: color ?? Colors.pink.shade300,
      border: Border.all(),
      borderRadius: BorderRadius.circular(10));

  BoxDecoration boxChatLogin() {
    return BoxDecoration(
      color: lightColor,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10),
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      ),
    );
  }

  BoxDecoration boxChatGuest({Color? bgColor}) {
    return BoxDecoration(
      color: bgColor ?? lightColor.withOpacity(0.5),
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(10),
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

  TextStyle h3Style({Color? color, double? size, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: size ?? 14,
      color: color ?? dark,
      fontWeight: fontWeight ?? FontWeight.normal,
      fontFamily: 'Sarabun',
    );
  }
}
