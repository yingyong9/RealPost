// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realpost/states/chat_page.dart';
import 'package:realpost/states/display_album.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/widgets/widget_circular_image.dart';
import 'package:realpost/widgets/widget_form.dart';
import 'package:realpost/widgets/widget_image_internet.dart';
import 'package:realpost/widgets/widget_progress.dart';
import 'package:realpost/widgets/widget_text.dart';

class BodyDiscovery extends StatefulWidget {
  const BodyDiscovery({super.key});

  @override
  State<BodyDiscovery> createState() => _BodyDiscoveryState();
}

class _BodyDiscoveryState extends State<BodyDiscovery> {
  var user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
      return GetX(
          init: AppController(),
          builder: (AppController appController) {
            // print('##29dec docIdRoomChooses ==> ${appController.docIdRoomChooses}');
            return (appController.roomModels.isEmpty) ||
                    (appController.listChatModels.isEmpty)
                ? const WidgetProgress()
                : ListView.builder(
                    itemCount: appController.roomModels.length,
                    itemBuilder: (context, index) => Column(
                      children: [
                        mainContent(appController, index, boxConstraints),
                        lastUserLoginPost(boxConstraints, appController, index),
                        SizedBox(
                          height: boxConstraints.maxHeight -
                              boxConstraints.maxWidth * 0.5,
                          child: listChatMessage(
                              appController, index, boxConstraints),
                        ),
                        WidgetText(text: 'form Poat Here'),
                        WidgetForm(
                          textStyle: AppConstant().h3Style(color: Colors.white),
                        ),
                      ],
                    ),
                  );
          });
    });
  }

  Container lastUserLoginPost(BoxConstraints boxConstraints, AppController appController, int index) {
    return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: boxConstraints.maxWidth,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            WidgetText(
                              text: appController
                                  .lastChatModelLogins[index].message,
                              textStyle: AppConstant()
                                  .h3Style(color: AppConstant.bgColor),
                            ),
                            appController.lastChatModelLogins[index].urlRealPost.isEmpty ? const SizedBox() : WidgetImageInternet(urlImage: appController.lastChatModelLogins[index].urlRealPost, width: 50, height: 50,)
                          ],
                        ),
                      );
  }

  ListView listChatMessage(
      AppController appController, int index, BoxConstraints boxConstraints) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      reverse: true,
      itemCount: appController.listChatModels[index].length,
      itemBuilder: (context, index2) => Row(
        children: [
          const SizedBox(width: 32),
          WidgetCircularImage(
              urlImage: appController.listChatModels[index][index2].urlAvatar),
          const SizedBox(width: 8),
          Column(
            children: [
              WidgetText(
                  text: appController.listChatModels[index][index2].uidChat ==
                          user!.uid
                      ? 'ฉัน'
                      : appController
                          .listChatModels[index][index2].disPlayName),
              Container(
                constraints:
                    BoxConstraints(maxWidth: boxConstraints.maxWidth * 0.4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                margin: const EdgeInsets.only(top: 8),
                decoration: AppConstant().boxChatLogin(),
                child: WidgetText(
                    text: appController.listChatModels[index][index2].message),
              ),
              const SizedBox(
                height: 8,
              ),
              appController.listChatModels[index][index2].albums.isNotEmpty
                  ? WidgetImageInternet(
                      urlImage:
                          appController.listChatModels[index][index2].albums[0],
                      width: boxConstraints.maxWidth * 0.4,
                      tapFunc: () {
                        Get.to(DisplayAlbum(
                          chatModel: appController.chatModels[index],
                        ));
                      },
                    )
                  : const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }

  Widget mainContent(
      AppController appController, int index, BoxConstraints boxConstraints) {
    return InkWell(
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
      child: Stack(
        children: [
          WidgetImageInternet(
            width: boxConstraints.maxWidth,
            height: boxConstraints.maxWidth * 0.5,
            urlImage: appController.roomModels[index].urlRoom,
            boxFit: BoxFit.cover,
            radius: 0,
          ),
          Positioned(
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
              width: boxConstraints.maxWidth,
              child: WidgetText(
                text: appController.roomModels[index].room,
                textStyle: AppConstant()
                    .h2Style(fontWeight: FontWeight.w400, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
