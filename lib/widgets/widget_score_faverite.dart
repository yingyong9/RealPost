// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:realpost/models/chat_model.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_amount_comment.dart';
import 'package:realpost/widgets/widget_display_up.dart';
import 'package:realpost/widgets/widget_image.dart';
import 'package:realpost/widgets/widget_text.dart';

class WidgetScoreFaverite extends StatelessWidget {
  const WidgetScoreFaverite({
    Key? key,
    required this.index,
    required this.chatModel,
  }) : super(key: key);

  final int index;
  final ChatModel chatModel;

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          return Row(
            children: [
              WidgetText(
                text: 'จำนวนคนในห้อง',
                textStyle: AppConstant()
                    .h3Style(size: 15, color: AppConstant.realFront),
              ),
              const SizedBox(
                width: 5,
              ),
              WidgetText(
                text: appController.chatModels[index].traffic.toString(),
                textStyle: AppConstant()
                    .h3Style(size: 15, color: AppConstant.realFront),
              ),
              const SizedBox(
                width: 20,
              ),
              WidgetAmountComment(
                // amountComment: chatModel.amountComment,
                amountComment: appController.chatModels[index].amountComment,
              ),
              const SizedBox(
                width: 20,
              ),
              WidgetImage(
                path: 'images/up.jpg',
                size: 36,
                tapFunc: () {
                  increaseUpMehod(appController).then((value) {});
                },
              ),
              const SizedBox(
                width: 5,
              ),
              WidgetDisplayUp(
                indexChat: index,
              ),
            ],
          );
        });
  }

  Future<void> increaseUpMehod(AppController appController) async {
    AppService()
        .increaseValueUp(
            docIdChat: appController.docIdChats[index], chatModel: chatModel)
        .then((value) {});
  }
}
