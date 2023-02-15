import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realpost/states/phone_number.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/widgets/widget_button.dart';

class DisplayProfile extends StatelessWidget {
  const DisplayProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      appBar: AppBar(),
      body: WidgetButton(
        label: 'ออกจากระบบ',
        pressFunc: () async {
          await FirebaseAuth.instance
              .signOut()
              .then((value) => Get.offAll(const PhoneNumber()));
        },
      ),
    );
  }
}
