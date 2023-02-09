// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/widgets/widget_circular_image.dart';
import 'package:realpost/widgets/widget_text.dart';

class WidgetListMessageLogin extends StatelessWidget {
  const WidgetListMessageLogin({
    Key? key,
    this.height,
    this.marginLeft,
    required this.status,
  }) : super(key: key);

  final double? height;
  final double? marginLeft;
  final bool status;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
      return GetX(
          init: AppController(),
          builder: (AppController appController) {
            return SizedBox(
              width: boxConstraints.maxWidth,
              height: height ??
                  boxConstraints.maxHeight - (boxConstraints.maxHeight * 0.4),
              child: ListView.builder(
                reverse: true,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: appController.chatModels.length,
                itemBuilder: (context, index) {
                  bool? myCondition; // ต่้องเป็น false ถึงจะแสดงผล
                  // status -> false PostLogin, true Geast
                  if (status) {
                    //การทำงานแสดง Post ของคนที่ Guest
                    myCondition = appController.chatModels[index].uidChat ==
                        appController
                            .roomModels[
                                appController.indexBodyMainPageView.value]
                            .uidCreate;
                  } else {
                    //การทำงานแสดง Post ของคนที่ login
                    myCondition = appController.chatModels[index].uidChat !=
                        appController
                            .roomModels[
                                appController.indexBodyMainPageView.value]
                            .uidCreate;
                  }

                  // myCondition = status ||
                  //     (appController.chatModels[index].uidChat == user!.uid);

                  print(
                      '##9jan status, myCondition ==> $status , $myCondition');
                  // print(
                  //     '##9jan uidLogin ==> ${user!.uid} ==== uidPost ==> ${appController.chatModels[index].uidChat}');

                  return myCondition
                      ? const SizedBox()
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            status
                                ? Container(
                                    margin: EdgeInsets.only(
                                      left: marginLeft ?? 16,
                                      // right: 4,
                                    ),
                                    child: WidgetCircularImage(
                                      urlImage: appController
                                          .chatModels[index].urlAvatar,
                                      radius: 14,
                                    ),
                                  )
                                : const SizedBox(
                                    width: 16,
                                  ),
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth: boxConstraints.maxWidth * 0.5),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 12),
                              margin: const EdgeInsets.only(top: 4),
                              decoration: AppConstant().boxChatGuest(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  WidgetText(
                                    text: appController
                                        .chatModels[index].disPlayName,
                                    textStyle: AppConstant()
                                        .h3Style(fontWeight: FontWeight.bold),
                                  ),
                                  WidgetText(
                                      text: appController
                                          .chatModels[index].message),
                                ],
                              ),
                            ),
                          ],
                        );
                },
              ),
            );
          });
    });
  }
}
