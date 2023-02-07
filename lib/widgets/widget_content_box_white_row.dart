// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/widgets/widget_text.dart';

class WidgetContenBoxWhiteRow extends StatelessWidget {
  const WidgetContenBoxWhiteRow({
    Key? key,
    required this.head,
    required this.width,
    required this.contentWidget,
    this.subHead,
  }) : super(key: key);

  final String head;
  final double width;
  final Widget contentWidget;
  final String? subHead;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      width: width,
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              WidgetText(
                text: head,
                textStyle: AppConstant().h2Style(color: Colors.black, size: 16),
              ),
              subHead == null
                  ? const SizedBox()
                  : WidgetText(
                      text: subHead!,
                      textStyle: AppConstant().h3Style(color: Colors.grey),
                    ),
            ],
          ),
          contentWidget,
        ],
      ),
    );
  }
}
