// ignore_for_file: public_member_api_docs, sort_constructors_first, unrelated_type_equality_checks, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
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
import 'package:realpost/widgets/widget_text_button.dart';

class AnswerChat extends StatefulWidget {
  const AnswerChat({
    Key? key,
    required this.docIdComment,
    required this.commentChatModel,
    required this.owner,
  }) : super(key: key);

  final String docIdComment;
  final ChatModel commentChatModel;
  final bool owner;

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

    print('##24june owner at answerCaht ----> ${widget.owner}');

    AppService().readAnswer(
        docIdComment: widget.docIdComment,
        uidOwner: widget.commentChatModel.uidChat);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      appBar: AppBar(),
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: SizedBox(
            width: boxConstraints.maxWidth,
            height: boxConstraints.maxHeight,
            child: Stack(
              children: [
                Obx(() {
                  return appController.answerChatModelsForOwner.isEmpty
                      ? const SizedBox()
                      : appController.listUrlImageAnswerOwners.isEmpty
                          ? Center(
                              child: WidgetText(
                                text: 'ไม่มีภาพ',
                                textStyle:
                                    AppConstant().h2Style(color: Colors.white),
                              ),
                            )
                          : SizedBox(
                              width: double.infinity,
                              height: boxConstraints.maxHeight * 0.7 - 70,
                              child: Stack(
                                children: [
                                  ImageSlideshow(
                                      height:
                                          boxConstraints.maxHeight * 0.7 - 70,
                                      children: appController
                                          .listUrlImageAnswerOwners.last
                                          .map((e) => WidgetImageInternet(
                                                urlImage: e,
                                                boxFit: BoxFit.cover,
                                              ))
                                          .toList()),
                                  appController.listMessageAnswerOwners.isEmpty
                                      ? const SizedBox()
                                      : Container(
                                          margin: const EdgeInsets.all(8),
                                          padding: const EdgeInsets.all(4),
                                          decoration: AppConstant().boxCurve(
                                              color: Colors.black
                                                  .withOpacity(0.5)),
                                          child: WidgetText(
                                            text: appController
                                                .listMessageAnswerOwners.last,
                                            textStyle: AppConstant()
                                                .h2Style(color: Colors.white),
                                          ),
                                        ),
                                  Positioned(bottom: 0,right: 0,
                                    child: WidgetIconButton(size: 45,
                                      pressFunc: () {}, iconData:  Icons.add_box,
                                    ),
                                  ),
                                ],
                              ),
                            );
                }),
                listChatAnswer(boxConstraints),
                panalFormChat(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget listChatAnswer(BoxConstraints boxConstraints) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: double.infinity,
          // height: boxConstraints.maxHeight - 60,
          height: boxConstraints.maxHeight * 0.3,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ownerListView(),
              // const SizedBox(
              //   width: 8,
              // ),
              guestListView(),
            ],
          ),
        ),
        const SizedBox(
          height: 60,
        )
      ],
    );
  }

  Widget ownerListView() {
    return Obx(() {
      return appController.answerChatModelsForOwner.isEmpty
          ? const Expanded(child: SizedBox())
          : Expanded(
              child: ListView.builder(
                itemCount: appController.answerChatModelsForOwner.length,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) => Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: AppConstant().boxChatLogin(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      appController.answerChatModelsForOwner[index]
                              .urlMultiImages.isEmpty
                          ? const SizedBox()
                          : ListView.builder(
                              itemCount: appController
                                  .answerChatModelsForOwner[index]
                                  .urlMultiImages
                                  .length,
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemBuilder: (context, index2) => Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: WidgetImageInternet(
                                    urlImage: appController
                                        .answerChatModelsForOwner[index]
                                        .urlMultiImages[index2]),
                              ),
                            ),
                      WidgetText(
                          text: appController
                              .answerChatModelsForOwner[index].message),
                    ],
                  ),
                ),
              ),
            );
    });
  }

  Widget guestListView() {
    return Obx(() {
      return Expanded(
        child: ListView.builder(
          itemCount: appController.answerChatModelsForGuest.length,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemBuilder: (context, index) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: AppConstant().boxChatGuest(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetCircularImage(
                  urlImage:
                      appController.answerChatModelsForGuest[index].urlAvatar,
                  radius: 10,
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetText(
                        text: appController
                            .answerChatModelsForGuest[index].disPlayName),
                    Row(
                      children: [
                        WidgetText(
                            text: appController
                                .answerChatModelsForGuest[index].message),
                                WidgetTextButton(text: 'ตอบ', pressFunc: () {
                                  
                                },)
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
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
                  print('##22june work');
                  AppService().processChooseMultiImageChat().then((value) {
                    print(
                        '##22june xFiles ---> ${appController.xFiles.length}');
                    AppBottomSheet().bottomSheetMultiImage(
                        context: context, docIdComment: widget.docIdComment);
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

                    map = widget.commentChatModel.toMap();

                    print('##20june chatModel ----> ${chatModel.toMap()}');

                    AppService()
                        .insertAnswer(
                            chatModel: chatModel,
                            docIdComment: widget.docIdComment)
                        .then((value) {
                      print('##20june map before $map');

                      var answers = <String>[];
                      answers.addAll(map['answers']);
                      answers.add(textEditingController.text);
                      map['answers'] = answers;

                      // var avatars = <String>[];
                      // avatars.addAll(map['avatars']);
                      // avatars
                      //     .add(appController.userModelsLogin.last.urlAvatar!);
                      // map['avatars'] = avatars;

                      // var names = <String>[];
                      // names.addAll(map['names']);
                      // names
                      //     .add(appController.userModelsLogin.last.displayName!);
                      // map['names'] = names;

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
