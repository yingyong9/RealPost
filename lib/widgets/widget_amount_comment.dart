// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/widgets/widget_text.dart';

class WidgetAmountComment extends StatelessWidget {
  const WidgetAmountComment({
    Key? key,
    required this.amountComment,
  }) : super(key: key);

  final int amountComment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.comment,
          color: AppConstant.realFront,
        ),
        const SizedBox(
          width: 8,
        ),
        WidgetText(
          text: amountComment.toString(),
          textStyle: AppConstant().h3Style(color: AppConstant.realFront),
        )
      ],
    );
  }
}
