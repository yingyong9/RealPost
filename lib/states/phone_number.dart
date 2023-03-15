// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:realpost/states/otp_check.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_button.dart';
import 'package:realpost/widgets/widget_form.dart';
import 'package:realpost/widgets/widget_text.dart';

class PhoneNumber extends StatefulWidget {
  const PhoneNumber({
    Key? key,
  }) : super(key: key);

  @override
  State<PhoneNumber> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  MaskTextInputFormatter maskTextInputFormatter =
      MaskTextInputFormatter(mask: '### ### ####');

  String? phonNumber;

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
      body: SafeArea(child:
          LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return SizedBox(
          width: boxConstraints.maxWidth,
          child: Column(
            children: [
              WidgetText(
                text: 'กรอกเบอร์โทรศัพท์ เริ่มใช้งาน',
                textStyle: AppConstant().h2Style(size: 18),
              ),
              WidgetForm(
                textInputFormatters: [maskTextInputFormatter],
                textInputType: TextInputType.phone,
                hint: '081 123 4567',
                autoFocus: true,
                textStyle: AppConstant().h1Style(),
                hintStyle: AppConstant().h1Style(color: Colors.grey),
                width: 250,
                maginTop: 16,
                changeFunc: (p0) {
                  phonNumber = p0.trim();
                },
              ),
              const Spacer(),
              SizedBox(
                width: 250,
                child: WidgetText(
                  text:
                      'ถ้าคุณ tab "ไปต่อ" หมายถึง คุณยอมรับ Privacy Policy และ Terms of Service.',
                  textStyle: AppConstant().h3Style(color: Colors.grey.shade700),
                ),
              ),
              WidgetButton(
                width: 250,
                label: 'ไปต่อ',
                pressFunc: () {
                  phonNumber = maskTextInputFormatter.getUnmaskedText();

                  if ((!(phonNumber?.isEmpty ?? true)) &&
                      (phonNumber!.length == 10)) {
                    print('##22feb phoneNumber ==> $phonNumber');
                    // AppService().processSentSMS(fullPhoneNumber: phonNumber!);

                    AppService()
                        .processSentSmsThaibulk(phoneNumber: phonNumber!)
                        .then((value) {
                      print('##22feb ค่าที่ได้รับกลับ --> ${value.token}');

                      Get.offAll(OtpCheck(token: value.token, phoneNumber: phonNumber!,));
                    });
                  }
                },
              )
            ],
          ),
        );
      })),
    );
  }
}
