// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_button.dart';
import 'package:realpost/widgets/widget_form.dart';
import 'package:realpost/widgets/widget_text.dart';

class OtpCheck extends StatefulWidget {
  const OtpCheck({
    Key? key,
    required this.verificationId,
  }) : super(key: key);

  final String verificationId;

  @override
  State<OtpCheck> createState() => _OtpCheckState();
}

class _OtpCheckState extends State<OtpCheck> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: WidgetText(
          text: AppConstant.appName,
          textStyle:
              AppConstant().h2Style(size: 30, color: AppConstant.spcialColor),
        ),
      ),
      body: Column(
        children: [
          const WidgetText(
            text: 'กรุณากรอก OTP from SMS',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OTPTextField(
                style: AppConstant().h3Style(size: 36),
                otpFieldStyle: OtpFieldStyle(
                  disabledBorderColor: AppConstant.dark,
                  enabledBorderColor: AppConstant.dark,
                ),
                fieldStyle: FieldStyle.underline,
                length: 6,
                width: 300,
                fieldWidth: 40,
                onCompleted: (value) {
                  AppService().verifyPhone(
                      verificationId: widget.verificationId, smsCode: value);
                },
              ),
            ],
          ),
        ],
      ),

      // Column(
      //   children: [
      //     WidgetForm(
      //       changeFunc: (p0) {
      //         pinCode = p0.trim();
      //       },
      //     ),
      //     WidgetButton(
      //       label: 'Check OTP',
      //       pressFunc: () {
      //         AppService().verifyPhone(
      //             verificationId: widget.verificationId, smsCode: pinCode!);
      //       },
      //     )
      //   ],
      // ),
    );
  }
}
