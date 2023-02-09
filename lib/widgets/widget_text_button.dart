// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/widgets/widget_text.dart';

class WidgetTextButton extends StatelessWidget {
  const WidgetTextButton({
    Key? key,
    required this.text,
    required this.pressFunc,
    this.color,
  }) : super(key: key);

  final String text;
  final Function() pressFunc;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: pressFunc,
        child: WidgetText(
          text: text,
          textStyle: AppConstant().h3Style(color: color ?? AppConstant.grey),
        ));
  }
}
