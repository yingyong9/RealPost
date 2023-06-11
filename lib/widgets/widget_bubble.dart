// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/material.dart';
import 'package:realpost/utility/app_constant.dart';

class WidgetBubble extends StatelessWidget {
  const WidgetBubble({
    Key? key,
    required this.string,
  }) : super(key: key);

  final String string;

  @override
  Widget build(BuildContext context) {
    return BubbleNormal(
      text: string,
      color: const Color.fromARGB(255, 54, 47, 47),
      textStyle: AppConstant().h3Style(color: Colors.white),
    );
  }
}
