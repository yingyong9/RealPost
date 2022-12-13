// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_dialog.dart';
import 'package:realpost/widgets/widget_circular_image.dart';
import 'package:realpost/widgets/widget_form.dart';
import 'package:realpost/widgets/widget_google_map.dart';
import 'package:realpost/widgets/widget_icon_button.dart';
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
                          : appController.chatModels.isEmpty
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
                                      margin: const EdgeInsets.only(top: 16),
                                      child: Row(
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              WidgetCircularImage(
                                                  urlImage: appController
                                                      .chatModels[index]
                                                      .urlAvatar),
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
                                          appController.chatModels[index]
                                                      .geoPoint!.latitude !=
                                                  0
                                              ? SizedBox(
                                                  width: 100,
                                                  height: 100,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child: WidgetGoogleMap(
                                                      zoom: 12,
                                                      lat: appController
                                                          .chatModels[index]
                                                          .geoPoint!
                                                          .latitude,
                                                      lng: appController
                                                          .chatModels[index]
                                                          .geoPoint!
                                                          .longitude,
                                                    ),
                                                  ),
                                                )
                                              : appController.chatModels[index]
                                                      .urlRealPost.isEmpty
                                                  ? const SizedBox()
                                                  : WidgetImageInternet(
                                                      urlImage: appController
                                                          .chatModels[index]
                                                          .urlRealPost,
                                                      width: 100,
                                                      height: 100,
                                                    ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                      contentForm(
                          boxConstraints: boxConstraints,
                          appController: appController),
                    ],
                  ),
                ),
              );
            });
      }),
    );
  }

  Column contentForm(
      {required BoxConstraints boxConstraints,
      required AppController appController}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        WidgetForm(
          width: boxConstraints.maxWidth,
          hintStyle: AppConstant().h3Style(color: AppConstant.grey),
          hint: 'พิมพ์ข้อความ...',
          textStyle: AppConstant().h3Style(),
          controller: textEditingController,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 150,
              child: Row(
                children: [
                  WidgetIconButton(
                    iconData: Icons.add_a_photo,
                    pressFunc: () {},
                  ),
                  WidgetIconButton(
                    iconData: Icons.add_photo_alternate,
                    pressFunc: () {},
                  ),
                  WidgetIconButton(
                    iconData: Icons.emoji_emotions,
                    pressFunc: () {},
                  ),
                ],
              ),
            ),
            WidgetIconButton(
              iconData: Icons.send,
              pressFunc: () async {
                if (textEditingController.text.isEmpty) {
                  print('No Text form');

                  if (appController.userModels[0].urlAvatar!.isNotEmpty) {
                    // การทำงานครั้งที่สอง
                    AppDialog(context: context).realPostBottonSheet();
                  }
                } else {
                  print('text = ${textEditingController.text}');
                  if (appController.messageChats.isNotEmpty) {
                    appController.messageChats.clear();
                  }
                  appController.messageChats.add(textEditingController.text);

                  textEditingController.text = '';

                  print('userModel => ${appController.userModels[0].toMap()}');

                  if (appController.userModels[0].urlAvatar?.isEmpty ?? true) {
                    AppDialog(context: context).avatarBottonSheet();
                  } else {
                    AppDialog(context: context).realPostBottonSheet();
                  }
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
