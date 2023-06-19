// ignore_for_file: public_member_api_docs, sort_constructors_first, unrelated_type_equality_checks, avoid_print
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:realpost/models/chat_model.dart';
import 'package:realpost/utility/app_bottom_sheet.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_circular_image.dart';
import 'package:realpost/widgets/widget_form.dart';
import 'package:realpost/widgets/widget_icon_button.dart';
import 'package:realpost/widgets/widget_image.dart';
import 'package:realpost/widgets/widget_image_internet.dart';
import 'package:realpost/widgets/widget_text.dart';

class AnswerChat extends StatefulWidget {
  const AnswerChat({
    Key? key,
    required this.docIdComment,
    required this.commentChatModel,
  }) : super(key: key);

  final String docIdComment;
  final ChatModel commentChatModel;

  @override
  State<AnswerChat> createState() => _AnswerChatState();
}

class _AnswerChatState extends State<AnswerChat> {
  AppController appController = Get.put(AppController());

  var textEditingController = TextEditingController();
  Map<String, dynamic> map = {};

  @override
  void initState() {
    super.initState();
    map = widget.commentChatModel.toMap();
    AppService().readAnswer(docIdComment: widget.docIdComment);
    AppService().checkOwnerComment(
        docIdComment: widget.docIdComment,
        commentChatModel: widget.commentChatModel,
        readed: true,
        map: map);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      appBar: AppBar(
        leading: WidgetIconButton(
          pressFunc: () {
            Get.back();

            // AppService()
            //     .checkOwnerComment(
            //         docIdComment: widget.docIdComment,
            //         commentChatModel: widget.commentChatModel,
            //         readed: false, map: map)
            //     .then((value) => Get.back());
          },
          iconData:
              GetPlatform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
        ),
      ),
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return SizedBox(
          width: boxConstraints.maxWidth,
          height: boxConstraints.maxHeight,
          child: Stack(
            children: [
              Obx(() {
                return appController.answerChatModels.isEmpty
                    ? const SizedBox()
                    : ListView.builder(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: appController.answerChatModels.length,
                        itemBuilder: (context, index) => Column(
                          children: [
                            Row(
                              mainAxisAlignment: appController.mainUid ==
                                      appController
                                          .answerChatModels[index].uidChat
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: appController.mainUid ==
                                      appController
                                          .answerChatModels[index].uidChat
                                  ? [
                                      BubbleSpecialThree(
                                        text:
                                            '${appController.answerChatModels[index].message}\n${AppService().timeStampToString(timestamp: appController.answerChatModels[index].timestamp, newPattern: "dd MMM HH:mm")}',
                                        isSender: appController.mainUid.value ==
                                            appController
                                                .answerChatModels[index]
                                                .uidChat, //true -> right, false ==> left
                                        color: Colors.blue,
                                        textStyle:
                                            AppConstant().h3Style(size: 16),
                                      ),
                                      WidgetCircularImage(
                                          radius: 10,
                                          urlImage: appController
                                              .answerChatModels[index]
                                              .urlAvatar),
                                    ]
                                  : [
                                      WidgetCircularImage(
                                          radius: 10,
                                          urlImage: appController
                                              .answerChatModels[index]
                                              .urlAvatar),
                                      BubbleSpecialThree(
                                        text:
                                            '${appController.answerChatModels[index].message}\n${AppService().timeStampToString(timestamp: appController.answerChatModels[index].timestamp, newPattern: "dd MMM HH:mm")}',
                                        isSender: appController.mainUid.value ==
                                            appController
                                                .answerChatModels[index]
                                                .uidChat, //true -> right, false ==> left
                                        color: Colors.blue,
                                        textStyle:
                                            AppConstant().h3Style(size: 16),
                                      ),
                                    ],
                            ),
                            Row(
                              mainAxisAlignment: appController.mainUid ==
                                      appController
                                          .answerChatModels[index].uidChat
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                WidgetText(
                                  text: appController
                                      .answerChatModels[index].disPlayName,
                                  textStyle: AppConstant().h3Style(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
              }),
              panalFormChat(),
            ],
          ),
        );
      }),
    );
  }

  Widget panalFormChat() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          appController.displayListEmoji.value
              ? SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: appController.stampModels.length,
                    itemBuilder: (context, index) => Container(
                      decoration: AppConstant().boxCurve(
                          color: appController.tapStamps[index]
                              ? Colors.red
                              : Colors.black),
                      padding: const EdgeInsets.only(left: 4),
                      child: WidgetImageInternet(
                          tapFunc: () {
                            // clearAllTabStamp(appController);

                            // appController.tapStamps[index] = true;
                            // appController.urlEmojiChooses
                            //     .add(appController.stampModels[index].url);
                            // setState(() {});
                          },
                          width: 70,
                          urlImage: appController.stampModels[index].url),
                    ),
                  ),
                )
              : const SizedBox(),
          Row(
            children: [
              WidgetIconButton(
                pressFunc: () {
                  AppService()
                      .processTakePhoto(source: ImageSource.camera)
                      .then((value) {
                    AppService()
                        .processUploadPhoto(file: value!, path: 'comment')
                        .then((value) {
                      String urlImageComment = value!;

                      AppBottomSheet().dipsplayImage(
                          urlImage: urlImageComment,
                          docIdChat: appController.docIdChats[0]);
                    });
                  });
                },
                iconData: Icons.add_a_photo,
                color: AppConstant.realFront,
              ),
              WidgetIconButton(
                pressFunc: () {
                  AppService().processChooseMultiImageChat().then((value) {
                    print('##29may xFiles ---> ${appController.xFiles.length}');
                    AppBottomSheet().bottomSheetMultiImage(
                       
                        context: context);
                  });
                },
                iconData: Icons.add_photo_alternate,
                color: AppConstant.realFront,
              ),
              SizedBox(
                width: 200,
                child: WidgetForm(
                  fillColor: AppConstant.realMid,
                  controller: textEditingController,
                  hint: 'Live Post',
                  hintStyle: AppConstant().h3Style(color: Colors.white),
                  textStyle: AppConstant().h3Style(color: Colors.white),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      WidgetImage(
                        path: 'images/emoj.jpg',
                        size: 36,
                        tapFunc: () {
                          print(
                              'Click Emoji ${appController.stampModels.length}');
                          appController.displayListEmoji.value =
                              !appController.displayListEmoji.value;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              WidgetImage(
                path: 'images/rocket.png',
                size: 48,
                tapFunc: () {
                  if ((textEditingController.text.isNotEmpty) ||
                      (appController.urlEmojiChooses.isNotEmpty)) {
                    // AppDialog(context: context).dialogProcess();

                    ChatModel chatModel = ChatModel(
                      message: textEditingController.text,
                      timestamp: Timestamp.fromDate(DateTime.now()),
                      uidChat: appController.mainUid.value,
                      disPlayName:
                          appController.userModelsLogin.last.displayName!,
                      urlAvatar: appController.userModelsLogin.last.urlAvatar!,
                      urlRealPost: appController.urlEmojiChooses.isEmpty
                          ? ''
                          : appController.urlEmojiChooses.last,
                      albums: [],
                      urlMultiImages: [],
                      up: 0,
                      amountComment: 0,
                      amountGraph: 0,
                    );

                    print('##11june chatModel ----> ${chatModel.toMap()}');

                    AppService()
                        .insertAnswer(
                            chatModel: chatModel,
                            docIdComment: widget.docIdComment)
                        .then((value) {
                      print('##14june map before $map');

                      var answers = <String>[];
                      answers.addAll(map['answers']);
                      answers.add(textEditingController.text);
                      map['answers'] = answers;

                      var avatars = <String>[];
                      avatars.addAll(map['avatars']);
                      avatars
                          .add(appController.userModelsLogin.last.urlAvatar!);
                      map['avatars'] = avatars;

                      var names = <String>[];
                      names.addAll(map['names']);
                      names
                          .add(appController.userModelsLogin.last.displayName!);
                      map['names'] = names;

                      print('##14june map after $map');

                      AppService()
                          .updateCommentChat(
                              map: map, docIdComment: widget.docIdComment)
                          .then((value) {
                        textEditingController.text = '';
                      });
                    });
                  }
                },
              ),
            ],
          ),
        ],
      );
}
