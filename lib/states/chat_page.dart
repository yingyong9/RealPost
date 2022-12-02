// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realpost/models/chat_model.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_form.dart';
import 'package:realpost/widgets/widget_icon_button.dart';
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
                              : ListView.builder(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  itemCount: appController.chatModels.length,
                                  itemBuilder: (context, index) => Row(
                                    mainAxisAlignment: appController
                                                .chatModels[index].uidChat ==
                                            user!.uid
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        margin: const EdgeInsets.only(top: 8),
                                        decoration:
                                            AppConstant().boxChatLogin(),
                                        child: WidgetText(
                                            text: appController
                                                .chatModels[index].message),
                                      ),
                                    ],
                                  ),
                                ),
                      contentForm(),
                    ],
                  ),
                ),
              );
            });
      }),
    );
  }

  Column contentForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        WidgetForm(
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
              pressFunc: () {
                if (textEditingController.text.isEmpty) {
                  print('No Text form');
                } else {
                  print('text = ${textEditingController.text}');
                  ChatModel chatModel = ChatModel(
                      message: textEditingController.text,
                      timestamp: Timestamp.fromDate(DateTime.now()),
                      uidChat: user!.uid);
                  AppService()
                      .processInsertChat(
                          chatModel: chatModel, docIdRoom: widget.docIdRoom)
                      .then((value) {
                    return null;
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
