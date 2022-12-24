// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:realpost/states/private_chat.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_dialog.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_circular_image.dart';
import 'package:realpost/widgets/widget_content_form.dart';
import 'package:realpost/widgets/widget_form.dart';
import 'package:realpost/widgets/widget_google_map.dart';
import 'package:realpost/widgets/widget_icon_button.dart';
import 'package:realpost/widgets/widget_image.dart';
import 'package:realpost/widgets/widget_image_internet.dart';
import 'package:realpost/widgets/widget_progress.dart';
import 'package:realpost/widgets/widget_text.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
    required this.docIdRoom,
  }) : super(key: key);

  final String docIdRoom;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String? docIdRoom;
  TextEditingController textEditingController = TextEditingController();
  var user = FirebaseAuth.instance.currentUser;

  AppController appController = Get.put(AppController());

  @override
  void initState() {
    super.initState();
    docIdRoom = widget.docIdRoom;
    print('docIdRoom ==> $docIdRoom');
    appController.readAllChat(docIdRoom: widget.docIdRoom);
    if (appController.docIdRoomChooses.isNotEmpty) {
      appController.docIdRoomChooses.clear();
    }
    appController.docIdRoomChooses.add(docIdRoom.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      appBar: AppBar(),
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return GetX(
            init: AppController(),
            builder: (AppController appController) {
              print('amount chatModels ==> ${appController.chatModels.length}');
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () =>
                    FocusScope.of(context).requestFocus(FocusScopeNode()),
                child: SizedBox(
                  width: boxConstraints.maxWidth,
                  height: boxConstraints.maxHeight,
                  child: Stack(
                    children: [
                      appController.load.value
                          ? const WidgetProgress()
                          : (appController.chatModels.isEmpty) ||
                                  (appController.addressMaps.isEmpty)
                              ? const SizedBox()
                              : SizedBox(
                                  width: boxConstraints.maxWidth,
                                  height: boxConstraints.maxHeight - 100,
                                  child: ListView.builder(
                                    reverse: true,
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16),
                                    itemCount: appController.chatModels.length,
                                    itemBuilder: (context, index) => Container(
                                      margin: const EdgeInsets.only(top: 32),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              WidgetCircularImage(
                                                urlImage: appController
                                                    .chatModels[index]
                                                    .urlAvatar,
                                                tapFunc: () {
                                                  String uid = appController
                                                      .chatModels[index]
                                                      .uidChat;
                                                  print(
                                                      'You tap avatar uid ---> $uid');

                                                  if (uid != user!.uid) {
                                                    print('Open Private Chat');
                                                    Get.to(PrivateChat(
                                                      uidFriend: uid,
                                                    ));
                                                  }
                                                },
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  WidgetText(
                                                      text: appController
                                                                  .chatModels[
                                                                      index]
                                                                  .uidChat ==
                                                              user!.uid
                                                          ? 'ฉัน'
                                                          : appController
                                                              .chatModels[index]
                                                              .disPlayName),
                                                  Container(
                                                    constraints:
                                                        const BoxConstraints(
                                                            maxWidth: 170),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16,
                                                        vertical: 6),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 8),
                                                    decoration: AppConstant()
                                                        .boxChatLogin(),
                                                    child: WidgetText(
                                                        text: appController
                                                                .chatModels[
                                                                    index]
                                                                .message
                                                                .isEmpty
                                                            ? '...'
                                                            : appController
                                                                .chatModels[
                                                                    index]
                                                                .message),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 16,
                                          ),
                                          ((appController
                                                              .chatModels[index]
                                                              .geoPoint!
                                                              .latitude !=
                                                          0) ||
                                                      (appController
                                                          .chatModels[index]
                                                          .link!
                                                          .isNotEmpty)) &&
                                                  (appController
                                                      .chatModels[index]
                                                      .urlRealPost
                                                      .isEmpty)
                                              ? imageMap(appController, index)
                                              : appController.chatModels[index]
                                                      .urlRealPost.isEmpty
                                                  ? const SizedBox()
                                                  : Column(
                                                      children: [
                                                        WidgetImageInternet(
                                                          urlImage:
                                                              appController
                                                                  .chatModels[
                                                                      index]
                                                                  .urlRealPost,
                                                          width: 100,
                                                          height: 100,
                                                        ),
                                                        Row(
                                                          children: [
                                                            appController
                                                                        .chatModels[
                                                                            index]
                                                                        .geoPoint!
                                                                        .latitude !=
                                                                    0
                                                                ? SizedBox(
                                                                    width: 30,
                                                                    height: 30,
                                                                    child: imageMap(
                                                                        appController,
                                                                        index),
                                                                  )
                                                                : const SizedBox(),
                                                            appController
                                                                    .chatModels[
                                                                        index]
                                                                    .link!
                                                                    .isNotEmpty
                                                                ? WidgetIconButton(
                                                                    iconData:
                                                                        Icons
                                                                            .link,
                                                                    pressFunc:
                                                                        () {
                                                                      AppService().processLunchUrl(
                                                                          url: appController
                                                                              .chatModels[index]
                                                                              .link!);
                                                                    },
                                                                  )
                                                                : const SizedBox(),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ), //here
                      WidgetContentForm(
                        boxConstraints: boxConstraints,
                        appController: appController,
                        textEditingController: textEditingController,
                      ),
                    ],
                  ),
                ),
              );
            });
      }),
    );
  }

  SizedBox imageMap(AppController appController, int index) {
    return SizedBox(
      width: 100,
      height: 100,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            WidgetImage(
              path: 'images/map.png',
              tapFunc: () {
                double? lat =
                    appController.chatModels[index].geoPoint!.latitude;
                double? lng =
                    appController.chatModels[index].geoPoint!.longitude;
                String url =
                    'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
                AppService().processLunchUrl(url: url);
              },
            ),
          ],
        ),
      ),
    );
  }
}
