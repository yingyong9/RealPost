// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:realpost/utility/app_constant.dart';

class WidgetIconButton extends StatelessWidget {
  const WidgetIconButton({
    Key? key,
    this.iconData,
    required this.pressFunc,
    this.color,
    this.iconWidget,
    this.size,
    this.padding,
  }) : super(key: key);

  final IconData? iconData;
  final Function() pressFunc;
  final Color? color;
  final Widget? iconWidget;
  final double? size;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        padding:  EdgeInsets.all(padding ?? 4),
        onPressed: pressFunc,
        icon: iconWidget ??
            Icon(
              iconData,
              color: color ?? AppConstant.dark,
              size: size,
            ));
  }
}
