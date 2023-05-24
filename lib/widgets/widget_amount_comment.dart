// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/widgets/widget_image.dart';
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
       const WidgetImage(path: 'images/comment.jpg',size: 36,),
        // const SizedBox(
        //   width: 2,
        // ),
        WidgetText(
          text: amountComment.toString(),
          textStyle: AppConstant().h3Style(color: AppConstant.realFront),
        )
      ],
    );
  }
}
