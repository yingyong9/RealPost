// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realpost/states/comment_chat.dart';
import 'package:realpost/utility/app_constant.dart';

import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_amount_comment.dart';
import 'package:realpost/widgets/widget_image.dart';
import 'package:realpost/widgets/widget_text.dart';

class WidgetScoreFaverite extends StatelessWidget {
  const WidgetScoreFaverite({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          return Row(
            children: [
              WidgetImage(
                path: appController.processUps[index]
                    ? 'images/redup.jpg'
                    : 'images/arrowup.jpg',
                size: 35,
                tapFunc: () {
                  AppService().addFavorite(
                      docIdChat: appController.docIdChats[index],
                      chatModel: appController.chatModels[index],
                      increse: true,
                      index: index);
                },
              ),
              const SizedBox(
                width: 10,
              ),
              WidgetText(
                text: appController.chatModels[index].favorit.toString(),
                textStyle: AppConstant()
                    .h3Style(size: 20, color: AppConstant.realFront),
              ),
              const SizedBox(
                width: 10,
              ),
              WidgetImage(
                path: appController.processDowns[index]
                    ? 'images/bluedown.jpg'
                    : 'images/arrowdown.jpg',
                size: 35,
                tapFunc: () {
                  AppService().addFavorite(
                      docIdChat: appController.docIdChats[index],
                      chatModel: appController.chatModels[index],
                      increse: false,
                      index: index);
                },
              ),
            
              const SizedBox(
                width: 20,
              ),

             
             
              WidgetText(text: 'จำนวนคนในห้อง', textStyle: AppConstant()
                    .h3Style(size: 10, color: AppConstant.realFront),),
              const SizedBox(
                width: 20,
              ),
              WidgetText(
                text: appController.chatModels[index].traffic.toString(),
                textStyle: AppConstant()
                    .h3Style(size: 20, color: AppConstant.realFront),
              ),

               WidgetAmountComment(amountComment: appController.amountComments[index],),
             
            ],
          );
        });
  }
}
