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
  }) : super(key: key);

  final String label;
  final Function() pressFunc;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: pressFunc,
          child: WidgetText(
            text: label,
            textStyle: AppConstant().h2Style(),
          )),
    );
  }
}
