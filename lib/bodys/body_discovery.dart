// ignore_for_file: avoid_print

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realpost/states/chat_page.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_icon_button.dart';
import 'package:realpost/widgets/widget_image_internet.dart';
import 'package:realpost/widgets/widget_progress.dart';
import 'package:realpost/widgets/widget_text.dart';

class BodyDiscovery extends StatefulWidget {
  const BodyDiscovery({super.key});

  @override
  State<BodyDiscovery> createState() => _BodyDiscoveryState();
}

class _BodyDiscoveryState extends State<BodyDiscovery> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
      return GetX(
          init: AppController(),
          builder: (AppController appController) {
            // print('##27nov roomModels ==> ${appController.roomModels}');
            return appController.roomModels.isEmpty
                ? const WidgetProgress()
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 32),
                    itemCount: appController.roomModels.length,
                    itemBuilder: (context, index) => Column(
                      children: [
                        InkWell(
                          onTap: () {
                            // print('You Tap index = $index');
                            Get.to(ChatPage(
                              docIdRoom: appController.docIdRooms[index],
                            ))!
                                .then((value) {
                              if (appController.urlAvatarChooses.isNotEmpty) {
                                appController.urlAvatarChooses.clear();
                              }

                              if (appController.urlRealPostChooses.isNotEmpty) {
                                appController.urlRealPostChooses.clear();
                              }
                            });
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, top: 4, right: 8),
                                child: WidgetImageInternet(
                                  width: 72,
                                  height: 72,
                                  urlImage:
                                      appController.roomModels[index].urlRoom,
                                  boxFit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                width: boxConstraints.maxWidth - 88,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: boxConstraints.maxWidth - 188,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              WidgetText(
                                                text: appController
                                                    .roomModels[index].room,
                                                textStyle: AppConstant()
                                                    .h2Style(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        size: 18),
                                              ),
                                              WidgetIconButton(
                                                iconWidget: Badge(
                                                  position: const BadgePosition(
                                                      bottom: 14, start: 14),
                                                  padding:
                                                      const EdgeInsets.all(3),
                                                  badgeContent:
                                                      const WidgetText(
                                                          text: '12'),
                                                  child: Icon(
                                                    Icons.add_box_sharp,
                                                    color: AppConstant.dark,
                                                  ),
                                                ),
                                                pressFunc: () {},
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: WidgetText(
                                            text: AppService()
                                                .timeStampToString(
                                                    timestamp: appController
                                                        .roomModels[index]
                                                        .timestamp),
                                            textStyle: AppConstant().h3Style(
                                                color: AppConstant.grey),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: AppConstant.grey,
                        )
                      ],
                    ),
                  );
          });
    });
  }
}
