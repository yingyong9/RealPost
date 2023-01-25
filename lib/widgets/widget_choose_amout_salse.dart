import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/widgets/widget_icon_button.dart';
import 'package:realpost/widgets/widget_text.dart';

class WidgetChooseAmountSalse extends StatefulWidget {
  const WidgetChooseAmountSalse({super.key});

  @override
  State<WidgetChooseAmountSalse> createState() =>
      _WidgetChooseAmountSalseState();
}

class _WidgetChooseAmountSalseState extends State<WidgetChooseAmountSalse> {
  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          return Row(
            children: [
              WidgetText(
                text: 'จำนวน',
                textStyle: AppConstant().h3Style(color: Colors.grey.shade700),
              ),
              WidgetIconButton(
                iconData: Icons.remove,
                color: Colors.grey.shade700,
                pressFunc: () {
                  if (appController.amountSalse.value > 1) {
                    appController.amountSalse.value--;
                  }
                },
              ),
              WidgetText(
                text: appController.amountSalse.toString(),
                textStyle: AppConstant().h3Style(color: Colors.grey.shade700),
              ),
              WidgetIconButton(
                iconData: Icons.add,
                color: Colors.grey.shade700,
                pressFunc: () {
                  appController.amountSalse.value++;
                },
              ),
            ],
          );
        });
  }
}
