// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/bubbles/bubble_special_two.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:realpost/models/chat_model.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_bubble.dart';
import 'package:realpost/widgets/widget_circular_image.dart';
import 'package:realpost/widgets/widget_form.dart';
import 'package:realpost/widgets/widget_icon_button.dart';
import 'package:realpost/widgets/widget_image_internet.dart';
import 'package:realpost/widgets/widget_score_faverite.dart';
import 'package:realpost/widgets/widget_text.dart';

class CommentChat extends StatefulWidget {
  const CommentChat({
    Key? key,
    required this.docIdChat,
    required this.chatModel,
    required this.index,
  }) : super(key: key);

  final String docIdChat;
  final ChatModel chatModel;
  final int index;

  @override
  State<CommentChat> createState() => _CommentChatState();
}

class _CommentChatState extends State<CommentChat> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AppService().readCommentChat(docIdChat: widget.docIdChat);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      appBar: AppBar(),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints boxConstraints) {
          return GetX(
              init: AppController(),
              builder: (AppController appController) {
                print(
                    'commentChats -----> ${appController.commentChatModels.length}');
                return SizedBox(
                  width: boxConstraints.maxWidth,
                  height: boxConstraints.maxHeight,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: boxConstraints.maxHeight - 70,
                        child: ListView(
                          children: [
                            widget.chatModel.message.isEmpty
                                ? const SizedBox()
                                : WidgetText(
                                    text: widget.chatModel.message,
                                    textStyle: AppConstant().h3Style(
                                        color: Colors.white,
                                        size: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                            const SizedBox(
                              height: 16,
                            ),
                            widget.chatModel.urlRealPost.isEmpty
                                ? const SizedBox()
                                : WidgetImageInternet(
                                    urlImage: widget.chatModel.urlRealPost,
                                    height: boxConstraints.maxWidth * 0.75,
                                    boxFit: BoxFit.cover,
                                  ),
                            WidgetScoreFaverite(index: widget.index),
                            const SizedBox(
                              height: 16,
                            ),
                            appController.commentChatModels.isEmpty
                                ? const SizedBox()
                                : ListView.builder(
                                    physics: const ScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount:
                                        appController.commentChatModels.length,
                                    itemBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16, bottom: 10),
                                      child: Container(decoration: AppConstant().boxBlack(color: Color.fromARGB(255, 26, 22, 22)),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            WidgetCircularImage(
                                                urlImage: appController
                                                    .commentChatModels[index]
                                                    .urlAvatar),
                                                    const SizedBox(width: 8,),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                WidgetText(text: '${appController.commentChatModels[index].disPlayName} : \n${appController.commentChatModels[index].message}'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        child: SizedBox(
                          width: boxConstraints.maxWidth,
                          child: WidgetForm(
                            controller: textEditingController,
                            hint: 'Comment',
                            hintStyle:
                                AppConstant().h3Style(color: Colors.white),
                            textStyle:
                                AppConstant().h3Style(color: Colors.white),
                            suffixIcon: WidgetIconButton(
                              pressFunc: () {
                                if (textEditingController.text.isNotEmpty) {
                                  ChatModel chatModel = ChatModel(
                                      message: textEditingController.text,
                                      timestamp:
                                          Timestamp.fromDate(DateTime.now()),
                                      uidChat: appController.mainUid.value,
                                      disPlayName: appController
                                          .userModelsLogin.last.displayName!,
                                      urlAvatar: appController
                                          .userModelsLogin.last.urlAvatar!,
                                      urlRealPost: '',
                                      albums: []);

                                  print('chatModel ---> ${chatModel.toMap()}');

                                  AppService()
                                      .insertCommentChat(
                                          docIdChat: widget.docIdChat,
                                          commentChatModel: chatModel)
                                      .then((value) {
                                    textEditingController.text = '';
                                  });
                                }
                              },
                              iconData: Icons.send,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
