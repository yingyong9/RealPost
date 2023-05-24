import 'package:flutter/material.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/widgets/widget_text.dart';

class WidgetDisplayUp extends StatelessWidget {
  const WidgetDisplayUp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return WidgetText(
      text: '123',
      textStyle: AppConstant().h3Style(size: 15, color: AppConstant.realFront),
    );
  }
}
