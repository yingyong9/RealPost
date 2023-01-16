// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/widgets/widget_text.dart';

class WidgetContenBoxWhite extends StatelessWidget {
  const WidgetContenBoxWhite({
    Key? key,
    required this.head,
    required this.width,
    required this.contentWidget,
  }) : super(key: key);

  final String head;
  final double width;
  final Widget contentWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      width: width,
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          WidgetText(
            text: head,
            textStyle: AppConstant().h2Style(color: Colors.black),
          ),
          contentWidget,
        ],
      ),
    );
  }
}
