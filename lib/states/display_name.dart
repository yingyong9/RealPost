import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realpost/states/phone_number.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/widgets/widget_button.dart';
import 'package:realpost/widgets/widget_form.dart';
import 'package:realpost/widgets/widget_text.dart';

class DisplayName extends StatefulWidget {
  const DisplayName({super.key});

  @override
  State<DisplayName> createState() => _DisplayNameState();
}

class _DisplayNameState extends State<DisplayName> {
  String? displayName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: WidgetText(
          text: AppConstant.appName,
          textStyle:
              AppConstant().h2Style(size: 30, color: AppConstant.yellowColor),
        ),
      ),
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return SizedBox(
          width: boxConstraints.maxWidth,
          child: Column(
            children: [
              WidgetText(
                text: 'เริ่ม Start App คุณชื่อ อะไร ?',
                textStyle: AppConstant().h2Style(size: 18),
              ),
              WidgetForm(
                autoFocus: true,
                textStyle: AppConstant().h1Style(),
                width: 250,
                maginTop: 16,
                changeFunc: (p0) {
                  displayName = p0.trim();
                },
              ),
              const Spacer(),
              WidgetButton(
                width: 250,
                label: 'ไปต่อ',
                pressFunc: () {
                  if (!(displayName?.isEmpty ?? true)) {
                    Get.off(PhoneNumber(displayName: displayName!));
                  }
                },
              )
            ],
          ),
        );
      }),
    );
  }
}
