// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:realpost/models/chat_model.dart';
import 'package:realpost/states/display_photo_view.dart';
import 'package:realpost/utility/app_bottom_sheet.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_dialog.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_button.dart';
import 'package:realpost/widgets/widget_circular_image.dart';
import 'package:realpost/widgets/widget_form.dart';
import 'package:realpost/widgets/widget_icon_button.dart';
import 'package:realpost/widgets/widget_image.dart';
import 'package:realpost/widgets/widget_image_internet.dart';
import 'package:realpost/widgets/widget_score_faverite.dart';
import 'package:realpost/widgets/widget_text.dart';

import 'package:badges/badges.dart' as badges;

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
  AppController controller = Get.put(AppController());

  @override
  void initState() {
    super.initState();

    controller.listAnswerModels.clear;

    AppService().readCommentChat(docIdChat: widget.docIdChat).then((value) {
      AppService().increaseDecrestTraffic(
          docIdChat: widget.docIdChat,
          increase: true,
          chatModel: widget.chatModel);

      AppService().checkInOwnerChat(
          docIdChat: widget.docIdChat,
          chatModel: widget.chatModel,
          checkIn: controller.checkIn.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      appBar: mainAppBar(),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints boxConstraints) {
          return GetX(
              init: AppController(),
              builder: (AppController appController) {
                print(
                    '##6june listAnswerModels -----> ${appController.listAnswerModels.length}');

                return SizedBox(
                  width: boxConstraints.maxWidth,
                  height: boxConstraints.maxHeight,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: appController.userModelsLogin.last.uidUser ==
                                widget.chatModel.uidChat
                            ? boxConstraints.maxHeight - 70
                            : boxConstraints.maxHeight,
                        child: ListView(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              decoration: AppConstant().realBox(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
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
                                  // widget.chatModel.urlMultiImages.isNotEmpty
                                  //     ? ListView.builder(
                                  //         physics: const ScrollPhysics(),
                                  //         shrinkWrap: true,
                                  //         itemCount: widget
                                  //             .chatModel.urlMultiImages.length,
                                  //         itemBuilder: (context, index) =>
                                  //             Padding(
                                  //           padding: const EdgeInsets.all(8.0),
                                  //           child: WidgetImageInternet(
                                  //             urlImage: widget.chatModel
                                  //                 .urlMultiImages[index],
                                  //             tapFunc: () {
                                  //               displayFullScreen(
                                  //                   url: widget.chatModel
                                  //                       .urlMultiImages[index]);
                                  //             },
                                  //           ),
                                  //         ),
                                  //       )
                                  //     : widget.chatModel.urlRealPost.isEmpty
                                  //         ? const SizedBox()
                                  //         : WidgetImageInternet(
                                  //             urlImage:
                                  //                 widget.chatModel.urlRealPost,
                                  //             height: boxConstraints.maxWidth *
                                  //                 0.75,
                                  //             width: boxConstraints.maxWidth,
                                  //             boxFit: BoxFit.cover,
                                  //             tapFunc: () {
                                  //               displayFullScreen(
                                  //                   url: widget
                                  //                       .chatModel.urlRealPost);
                                  //             },
                                  //           ),
                                  WidgetScoreFaverite(
                                    index: widget.index,
                                    chatModel: widget.chatModel,
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            appController.commentChatModels.isEmpty
                                ? const SizedBox()
                                : ListView.builder(
                                    physics: const ScrollPhysics(),
                                    shrinkWrap: true,
                                    reverse: true,
                                    itemCount:
                                        appController.commentChatModels.length,
                                    itemBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16, bottom: 10),
                                      child: Container(
                                        decoration: AppConstant().boxBlack(
                                            color: const Color.fromARGB(
                                                255, 26, 22, 22)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                WidgetCircularImage(
                                                  urlImage: appController
                                                      .commentChatModels[index]
                                                      .urlAvatar,
                                                  radius: 15,
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                WidgetText(
                                                    text: appController
                                                        .commentChatModels[
                                                            index]
                                                        .disPlayName),
                                              ],
                                            ),
                                            appController
                                                    .commentChatModels[index]
                                                    .urlRealPost
                                                    .isEmpty
                                                ? const SizedBox()
                                                : appController
                                                        .commentChatModels[
                                                            index]
                                                        .urlMultiImages
                                                        .isEmpty
                                                    ? WidgetImageInternet(
                                                        urlImage: appController
                                                            .commentChatModels[
                                                                index]
                                                            .urlRealPost,
                                                        width: 180,
                                                        height: 150,
                                                        boxFit: BoxFit.cover,
                                                        tapFunc: () {
                                                          displayFullScreen(
                                                              url: appController
                                                                  .commentChatModels[
                                                                      index]
                                                                  .urlRealPost);
                                                        },
                                                      )
                                                    : const SizedBox(),
                                            appController
                                                    .commentChatModels[index]
                                                    .urlMultiImages
                                                    .isEmpty
                                                ? const SizedBox()
                                                : ListView.builder(
                                                    physics:
                                                        const ScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: appController
                                                        .commentChatModels[
                                                            index]
                                                        .urlMultiImages
                                                        .length,
                                                    itemBuilder:
                                                        (context, index2) =>
                                                            Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child:
                                                              WidgetImageInternet(
                                                            urlImage: appController
                                                                .commentChatModels[
                                                                    index]
                                                                .urlMultiImages[index2],
                                                            width: 180,
                                                            height: 150,
                                                            boxFit:
                                                                BoxFit.cover,
                                                            tapFunc: () {
                                                              displayFullScreen(
                                                                  url: appController
                                                                      .commentChatModels[
                                                                          index]
                                                                      .urlMultiImages[index2]);
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                            WidgetText(
                                              text: appController
                                                  .commentChatModels[index]
                                                  .message,
                                              textStyle: AppConstant()
                                                  .h3Style(size: 16),
                                            ),
                                            // appController
                                            //         .listAnswerModels.isEmpty
                                            //     ? const SizedBox()
                                            //     : appController
                                            //             .listAnswerModels[index]
                                            //             .isEmpty
                                            //         ? const SizedBox()
                                            //         : Container(
                                            //             margin: const EdgeInsets
                                            //                     .only(
                                            //                 left: 32, top: 8),
                                            //             child: ListView.builder(
                                            //               physics:
                                            //                   const ScrollPhysics(),
                                            //               shrinkWrap: true,
                                            //               itemCount: appController
                                            //                   .listAnswerModels[
                                            //                       index]
                                            //                   .length,
                                            //               itemBuilder: (context,
                                            //                   index3) {
                                            //                 print(
                                            //                     '##1june index = $index, index3 = $index3');
                                            //                 print(
                                            //                     '##1june listAnswerModles at index = $index ==> ${appController.listAnswerModels[index].length}');
                                            //                 return Padding(
                                            //                   padding:
                                            //                       const EdgeInsets
                                            //                               .only(
                                            //                           bottom:
                                            //                               12),
                                            //                   child: Row(
                                            //                     crossAxisAlignment:
                                            //                         CrossAxisAlignment
                                            //                             .start,
                                            //                     children: [
                                            //                       WidgetCircularImage(
                                            //                         urlImage: appController
                                            //                             .listAnswerModels[
                                            //                                 index]
                                            //                                 [
                                            //                                 index3]
                                            //                             .avatarAnswer,
                                            //                         radius: 12,
                                            //                       ),
                                            //                       const SizedBox(
                                            //                         width: 8,
                                            //                       ),
                                            //                       Expanded(
                                            //                           child: WidgetTextRich(
                                            //                               head: appController
                                            //                                   .listAnswerModels[index][
                                            //                                       index3]
                                            //                                   .nameAnswer,
                                            //                               value: appController
                                            //                                   .listAnswerModels[index][index3]
                                            //                                   .answer)),
                                            //                     ],
                                            //                   ),
                                            //                 );
                                            //               },
                                            //             ),
                                            //           ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Row(
                                                  children: [
                                                    WidgetImage(
                                                      path:
                                                          'images/arrowup.jpg',
                                                      size: 24,
                                                    ),
                                                    WidgetText(text: '5'),
                                                    WidgetImage(
                                                      path:
                                                          'images/arrowdown.jpg',
                                                      size: 24,
                                                    ),
                                                    WidgetText(text: '8'),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                   appController.commentChatModels[index].phone!.isEmpty ? const SizedBox() : const WidgetImage(
                                                      path: 'images/phone.jpg',
                                                      size: 36,
                                                    ),
                                                    appController.commentChatModels[index].amount!.isEmpty ? const SizedBox() :  badges.Badge(
                                                      badgeContent:
                                                          WidgetText(text: appController.commentChatModels[index].amount ?? ''),
                                                      child: const Icon(Icons.shopping_cart, color: Colors.white,),
                                                    ),
                                                    const SizedBox(width: 12,),
                                                    appController.commentChatModels[index].line!.isEmpty ? const SizedBox() :  const WidgetImage(
                                                      path: 'images/line.jpg',
                                                      size: 36,
                                                    ),
                                                    WidgetButton(
                                                      label: 'สนทนา',
                                                      pressFunc: () {
                                                        AppDialog(
                                                                context:
                                                                    context)
                                                            .answerDialog(
                                                                docIdComment:
                                                                    appController
                                                                            .docIdCommentChats[
                                                                        index],
                                                                docIdChat: widget
                                                                    .docIdChat);
                                                      },
                                                      iconWidget: const Icon(
                                                        Icons.turn_left,
                                                        color: Colors.white,
                                                      ),
                                                      bgColor: Colors.black,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                            // WidgetScoreFaverite(index: index),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ),
                      appController.userModelsLogin.last.uidUser ==
                              widget.chatModel.uidChat
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                appController.displayListEmoji.value
                                    ? SizedBox(
                                        height: 80,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          physics:
                                              const ClampingScrollPhysics(),
                                          itemCount:
                                              appController.stampModels.length,
                                          itemBuilder: (context, index) =>
                                              Container(
                                            decoration: AppConstant().boxCurve(
                                                color: appController
                                                        .tapStamps[index]
                                                    ? Colors.red
                                                    : Colors.black),
                                            padding:
                                                const EdgeInsets.only(left: 4),
                                            child: WidgetImageInternet(
                                                tapFunc: () {
                                                  clearAllTabStamp(
                                                      appController);

                                                  appController
                                                      .tapStamps[index] = true;
                                                  appController.urlEmojiChooses
                                                      .add(appController
                                                          .stampModels[index]
                                                          .url);
                                                  setState(() {});
                                                },
                                                width: 70,
                                                urlImage: appController
                                                    .stampModels[index].url),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                Row(
                                  children: [
                                    WidgetIconButton(
                                      pressFunc: () {
                                        AppService()
                                            .processTakePhoto(
                                                source: ImageSource.camera)
                                            .then((value) {
                                          AppService()
                                              .processUploadPhoto(
                                                  file: value!, path: 'comment')
                                              .then((value) {
                                            String urlImageComment = value!;

                                            AppBottomSheet().dipsplayImage(
                                                urlImage: urlImageComment,
                                                docIdChat: widget.docIdChat);
                                          });
                                        });
                                      },
                                      iconData: Icons.add_a_photo,
                                      color: AppConstant.realFront,
                                    ),
                                    WidgetIconButton(
                                      pressFunc: () {
                                        AppService()
                                            .processChooseMultiImageChat()
                                            .then((value) {
                                          print(
                                              '##29may xFiles ---> ${controller.xFiles.length}');
                                          AppBottomSheet()
                                              .bottomSheetMultiImage(
                                                  docIdChat: widget.docIdChat,
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
                                        hintStyle: AppConstant()
                                            .h3Style(color: Colors.white),
                                        textStyle: AppConstant()
                                            .h3Style(color: Colors.white),
                                        suffixIcon: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            WidgetImage(
                                              path: 'images/emoj.jpg',
                                              size: 36,
                                              tapFunc: () {
                                                print(
                                                    'Click Emoji ${appController.stampModels.length}');
                                                appController.displayListEmoji
                                                        .value =
                                                    !appController
                                                        .displayListEmoji.value;
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
                                        print(
                                            '##4june uidCreate ---> ${widget.chatModel.uidChat}');

                                        if ((textEditingController
                                                .text.isNotEmpty) ||
                                            (appController
                                                .urlEmojiChooses.isNotEmpty)) {
                                          AppDialog(context: context)
                                              .dialogProcess();

                                          ChatModel chatModel = ChatModel(
                                            message: textEditingController.text,
                                            timestamp: Timestamp.fromDate(
                                                DateTime.now()),
                                            uidChat:
                                                appController.mainUid.value,
                                            disPlayName: appController
                                                .userModelsLogin
                                                .last
                                                .displayName!,
                                            urlAvatar: appController
                                                .userModelsLogin
                                                .last
                                                .urlAvatar!,
                                            urlRealPost: appController
                                                    .urlEmojiChooses.isEmpty
                                                ? ''
                                                : appController
                                                    .urlEmojiChooses.last,
                                            albums: [],
                                            urlMultiImages: [],
                                            up: 0,
                                            amountComment: 0,
                                            amountGraph: 0,
                                          );

                                          AppService()
                                              .insertCommentChat(
                                                  docIdChat: widget.docIdChat,
                                                  commentChatModel: chatModel)
                                              .then((value) async {
                                            await AppService()
                                                .findUserModel(
                                                    uid: widget
                                                        .chatModel.uidChat)
                                                .then((value) {
                                              print(
                                                  '##4june userModel ของเจ้าของ post --> ${value!.toMap()}');

                                              AppService()
                                                  .processSentNoti(
                                                      title:
                                                          'คุณมี Comment ใหม่',
                                                      body:
                                                          '${textEditingController.text}%23${widget.index}',
                                                      token: value.token!)
                                                  .then((value) {
                                                Get.back();

                                                AppService()
                                                    .increaseValueComment(
                                                        docIdChat:
                                                            widget.docIdChat,
                                                        chatModel:
                                                            widget.chatModel);

                                                textEditingController.text = '';
                                                appController.urlAvatarChooses
                                                    .clear();
                                                clearAllTabStamp(appController);
                                                appController.displayListEmoji
                                                    .value = false;
                                              });
                                            });
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }

  void displayFullScreen({required String url}) {
    Get.to(DisplayPhotoView(urlImage: url));
  }

  AppBar mainAppBar() {
    return AppBar(
      leading: WidgetIconButton(
        iconData: Icons.arrow_back,
        pressFunc: () {
          controller.checkIn.value = false;
          AppService()
              .checkInOwnerChat(
                  docIdChat: widget.docIdChat,
                  chatModel: widget.chatModel,
                  checkIn: controller.checkIn.value)
              .then((value) {
            Get.back();
          });
        },
      ),
      title: Row(
        children: [
          WidgetText(
            text: widget.chatModel.disPlayName,
            textStyle: AppConstant().h2Style(),
          ),
        ],
      ),
      actions: [
        WidgetCircularImage(
            urlImage: controller.userModelsLogin.last.urlAvatar!)
      ],
    );
  }

  void clearAllTabStamp(AppController appController) {
    for (var i = 0; i < appController.tapStamps.length; i++) {
      appController.tapStamps[i] = false;
    }
  }
}
