// ignore_for_file: avoid_print

import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realpost/states/private_chat.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_circular_image.dart';
import 'package:realpost/widgets/widget_progress.dart';
import 'package:realpost/widgets/widget_progress_animation.dart';
import 'package:realpost/widgets/widget_text.dart';

class ListFriend extends StatefulWidget {
  const ListFriend({super.key});

  @override
  State<ListFriend> createState() => _ListFriendState();
}

class _ListFriendState extends State<ListFriend> {
  @override
  void initState() {
    super.initState();
    AppService().findArrayFriendUid();
    AppService().delayListFriend();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      appBar: AppBar(
        title: WidgetText(
          text: 'List Friend',
          textStyle: AppConstant().h2Style(),
        ),
      ),
      body: GetX(
          init: AppController(),
          builder: (AppController appController) {
            print(
                '##11april uid ที่ login อยู่ ---> ${appController.mainUid.value}');
            print(
                '##11april uidFriend ===> ${appController.uidFriends.length}');
            print('##12april unReads ===> ${appController.unReads.length}');
            return ((appController.uidFriends.isNotEmpty) &&
                    (appController.userModelPrivateChats.isNotEmpty) &&
                    (appController.unReads.isNotEmpty))
                ? appController.load.value
                    ? const WidgetProgress()
                    : appController.listFriendLoad.value
                        ? const WidgetProgessAnimation()
                        : ListView.builder(
                            itemCount:
                                appController.userModelPrivateChats.length,
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                appController.listFriendLoad.value = true;
                                Get.to(PrivateChat(
                                        uidFriend:
                                            appController.uidFriends[index]))!
                                    .then((value) {
                                  AppService().findArrayFriendUid();
                                  AppService().delayListFriend();
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    WidgetCircularImage(
                                        urlImage: appController
                                            .userModelPrivateChats[index]
                                            .urlAvatar!),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    WidgetText(
                                      text: appController
                                          .userModelPrivateChats[index]
                                          .displayName!,
                                      textStyle: AppConstant()
                                          .h3Style(fontWeight: FontWeight.w700),
                                    ),
                                    const Spacer(),
                                    appController.unReads.isEmpty
                                        ? const SizedBox()
                                        : appController.unReads[index] == 0
                                            ? const SizedBox()
                                            : BubbleNormal(
                                                text: appController
                                                    .unReads[index]
                                                    .toString(),
                                                isSender: false,
                                                tail: false,
                                                color: Colors.green.shade700,
                                                textStyle: AppConstant()
                                                    .h3Style(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                  ],
                                ),
                              ),
                            ),
                          )
                : const SizedBox();
          }),
    );
  }
}
