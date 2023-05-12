import 'package:flutter/material.dart';

class AppConstant {
  static int amountLoadPage = 1;

  static String conditionTh =
      'ข้อตกลงและเงื่อนไขการใช้งาน: \n \n 1. แอปนี้เป็นแพลตฟอร์มสำหรับโพสต์เฉพาะเรื่องอาหาร เช่น อาหาร ของกิน พืช ผลไม้ ข้าว ของเกษตรทุกชนิด ขนม นม เนย และอื่นๆที่เกี่ยวข้องกับอาหารเท่านั้น\n 2. แอพไม่อนุญาตให้โพสต์เรื่องการเมือง ความเชื่อศาสนา ความรุนแรง หรือสินค้าที่ไม่เกี่ยวกับอาหาร เช่น ยา อาหารเสริม วิตามิน และสิ่งอื่นๆที่ไม่เกี่ยวข้องกับอาหาร\n 3. ผู้ใช้ตกลงว่าจะไม่โพสต์ข้อมูลที่ละเมิดลิขสิทธิ์ ทรัพย์สินทางปัญญา หรือกฎหมาย และจะไม่โพสต์เนื้อหาที่ไม่เหมาะสม หรือก่อให้เกิดความไม่สงบสุขในชุมชน\n 4. แอปไม่มีส่วนเกี่ยวข้องกับผู้ใช้และไม่มีส่วนรับผิดชอบใดๆเกี่ยวกับความเสียหายหรือการสูญเสียที่เกิดขึ้นจากการใช้งานแอป\n 5.  การใช้งานแอปถือเป็นการยอมรับข้อตกลงและเงื่อนไขการใช้งานทั้งหมด\n \n หากคุณเห็นด้วยกับข้อตกลงและเงื่อนไขการใช้งานทั้งหมด โปรดกด "OK" เพื่อยืนยัน หากไม่เห็นด้วย โปรดกด "Cancel" และหยุดการใช้งานแอปนี้';
  static String conditionEn =
      'Terms and Conditions:\n \n 1. This app is a platform for posting food-related content such as food, vegetables, fruits, all kinds of agricultural products, desserts, milk, butter, and other food-related items.\n 2. sers are not allowed to post political, religious, violent content or products that are not related to food such as medicine, supplements, vitamins, and other non-food-related items.\n 3. Users agree not to post content that violates copyright, intellectual property, or the law, and will not post inappropriate content or cause unrest in the community.\n 4. The app is not responsible for any damage or loss incurred from the use of the app, and is not associated with the users in any way.\n 5. Using the app implies agreement to all terms and conditions.\n \n If you agree to all the terms and conditions, please click "OK" to confirm. If you do not agree, please click "Cancel" and stop using the app.';

  static int timeCountsec = 30;
  static String key = '1758532022818591';
  static String secret = '6ee4cbc8611eaa7c3e4ed60b071badf7';
  static Color spColor = const Color(0xff512da8);
  static Color dark = Colors.white;
  // static Color bgColor = const Color.fromARGB(255, 1, 50, 50);
  static Color bgColor = Colors.black;
  static Color lightColor = const Color.fromARGB(255, 1, 88, 79);
  static Color spcialColor = Colors.white;
  static Color grey = const Color.fromARGB(255, 164, 159, 159);
  static Color bgGrey = const Color.fromARGB(255, 240, 236, 236);
  static Color bgChat = Colors.white;

  static Color realBg = const Color.fromARGB(255, 21, 20, 20);
  static Color realMid = Color.fromARGB(255, 38, 36, 36);
  static Color realFront = Color.fromARGB(255, 137, 129, 129);

  static String appName = 'Real Post.';
  static String urlAvatar =
      'https://firebasestorage.googleapis.com/v0/b/realpost-19dd3.appspot.com/o/icon%2FReal%20post3.png?alt=media&token=ac968787-b252-4157-9f55-75b2ebec354a';

  static String pagePhoneNumber = '/phoneNumber';
  static String pageMainHome = '/mainHome';

  BoxDecoration realBox() => BoxDecoration(
      color: AppConstant.realBg, borderRadius: BorderRadius.circular(10));

  BoxDecoration gradientColor() => BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 234, 43, 215),
            Color.fromARGB(255, 114, 50, 232)
          ],
          // colors: [Color.fromARGB(255, 16, 218, 76), Color.fromARGB(255, 65, 50, 232)],
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
        ),
      );

  BoxDecoration borderBox() => BoxDecoration(
      border: Border.all(width: 1), borderRadius: BorderRadius.circular(10));

  BoxDecoration boxBlack({Color? color}) =>
      BoxDecoration(color: color ?? Colors.black12);

  BoxDecoration boxCurve({Color? color, double? radius}) => BoxDecoration(
      color: color ?? Colors.pink.shade300,
      border: Border.all(),
      borderRadius: BorderRadius.circular(radius ?? 10));

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
