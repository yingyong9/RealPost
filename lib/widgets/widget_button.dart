// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/widgets/widget_text.dart';

class WidgetButton extends StatelessWidget {
  const WidgetButton({
    Key? key,
    required this.label,
    required this.pressFunc,
    this.width,
    this.bgColor,
    this.textColor,
    this.circular,
    this.labelStyle,
    this.iconWidget,
  }) : super(key: key);

  final String label;
  final Function() pressFunc;
  final double? width;
  final Color? bgColor;
  final Color? textColor;
  final double? circular;
  final TextStyle? labelStyle;
  final Widget? iconWidget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(circular ?? 10)),
        ),
        onPressed: pressFunc,
        label: WidgetText(
          text: label,
          textStyle: labelStyle ?? AppConstant().h2Style(color: textColor),
        ),
        icon: iconWidget ?? const SizedBox(),
      ),
    );
  }
}
