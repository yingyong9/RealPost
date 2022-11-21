import 'package:flutter/material.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/widgets/widget_form.dart';
import 'package:realpost/widgets/widget_text.dart';

class DisplayName extends StatelessWidget {
  const DisplayName({super.key});

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
              WidgetForm(width: 250,
                maginTop: 16,
                changeFunc: (p0) {},
              )
            ],
          ),
        );
      }),
    );
  }
}
