// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/widgets/widget_text.dart';

class WidgetDisplayUp extends StatefulWidget {
  const WidgetDisplayUp({
    Key? key,
    required this.indexChat,
  }) : super(key: key);

  final int indexChat;

  @override
  State<WidgetDisplayUp> createState() => _WidgetDisplayUpState();
}

class _WidgetDisplayUpState extends State<WidgetDisplayUp> {
  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          return WidgetText(
            // text: appController.chatModels[widget.indexChat].up.toString(),
            text: appController.chatModels[widget.indexChat].up.toString(),
            textStyle:
                AppConstant().h3Style(size: 15, color: AppConstant.realFront),
          );
        });
  }
}
