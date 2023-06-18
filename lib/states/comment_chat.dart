// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:realpost/models/chat_model.dart';
import 'package:realpost/states/answer_chat.dart';
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
import 'package:realpost/widgets/widget_progress_animation.dart';
import 'package:realpost/widgets/widget_text.dart';

import 'package:badges/badges.dart' as badges;

class CommentChat extends StatefulWidget {
  const CommentChat({
    Key? key,
  }) : super(key: key);

  @override
  State<CommentChat> createState() => _CommentChatState();
}

class _CommentChatState extends State<CommentChat> {
  TextEditingController textEditingController = TextEditingController();
  AppController controller = Get.put(AppController());

  @override
  void initState() {
    super.initState();

    AppService().initialSetup(context: context);
    AppService().aboutNoti(context: context);
    AppService().readCommentChat();
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
                    '##14june listAnserModels -----> ${appController.listAnswerModels.length}');
                if (appController.listAnswerModels.isNotEmpty) {
                  for (var element in appController.listAnswerModels) {
                    print('##14june ans ---> $element');
                  }
                }

                return appController.chatModels.isEmpty
                    ? const WidgetProgessAnimation()
                    : SizedBox(
                        width: boxConstraints.maxWidth,
                        height: boxConstraints.maxHeight,
                        child: Stack(
                          children: [
                            contentMain(
                                appController: appController,
                                boxConstraints: boxConstraints),
                            Column(
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
                                                docIdChat: appController
                                                    .docIdChats[0]);
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
                                                  docIdChat: appController
                                                      .docIdChats[0],
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
                                        hint: 'Real Post',
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
                                            '##4june uidCreate ---> ${appController.chatModels[0].uidChat}');

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
                                                  docIdChat: appController
                                                      .docIdChats[0],
                                                  commentChatModel: chatModel)
                                              .then((value) async {
                                            await AppService()
                                                .findUserModel(
                                                    uid: appController
                                                        .chatModels[0].uidChat)
                                                .then((value) {
                                              print(
                                                  '##4june userModel ของเจ้าของ post --> ${value!.toMap()}');

                                              AppService()
                                                  .processSentNoti(
                                                      title:
                                                          'คุณมี Comment ใหม่',
                                                      body:
                                                          '${textEditingController.text}%230',
                                                      token: value.token!)
                                                  .then((value) {
                                                Get.back();

                                                AppService()
                                                    .increaseValueComment(
                                                        docIdChat: appController
                                                            .docIdChats[0],
                                                        chatModel: appController
                                                            .chatModels[0]);

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
                            ),
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
      title: WidgetForm(
        fillColor: AppConstant.realMid,
        prefixIcon: Icon(
          Icons.search,
          color: AppConstant.realFront,
        ),
        textStyle: AppConstant().h3Style(),
        height: 40,
      ),
      actions: [
        Obx(() {
          return controller.userModelsLogin.isEmpty
              ? const SizedBox()
              : WidgetCircularImage(
                  urlImage: controller.userModelsLogin.last.urlAvatar!);
        })
      ],
    );
  }

  void clearAllTabStamp(AppController appController) {
    for (var i = 0; i < appController.tapStamps.length; i++) {
      appController.tapStamps[i] = false;
    }
  }

  Widget contentMain(
      {required AppController appController,
      required BoxConstraints boxConstraints}) {
    return SizedBox(
      height: boxConstraints.maxHeight - 70,
      child: ListView(
        children: [
          appController.commentChatModels.isEmpty
              ? const SizedBox()
              : ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: appController.commentChatModels.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 10),
                    child: Container(
                      decoration: AppConstant().boxBlack(
                          color: const Color.fromARGB(255, 26, 22, 22)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          displayNameAvatar(appController, index),
                          singleImage(appController, index),
                          multiImage(appController, index),
                          messageText(appController, index),
                          answerList(appController, index),
                          displayPanal(appController, index, context),
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Row displayPanal(
      AppController appController, int index, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const WidgetImage(
              path: 'images/arrowup.jpg',
              size: 24,
            ),
            const WidgetText(text: '5'),
            const WidgetImage(
              path: 'images/arrowdown.jpg',
              size: 24,
            ),
            const WidgetText(text: '8'),
            const SizedBox(
              width: 8,
            ),
            InkWell(
              onTap: () {
                print(
                    '##18june docIdcomment ---> ${appController.docIdCommentChats[index]}');

                Map<String, dynamic> map =
                    appController.commentChatModels[index].toMap();
                map['timestamp'] = Timestamp.fromDate(DateTime.now());
                AppService()
                    .updateCommentChat(
                        map: map,
                        docIdComment: appController.docIdCommentChats[index])
                    .then((value) {
                  print('##18june Success');
                });
              },
              child: const WidgetImage(
                path: 'images/up.jpg',
                size: 24,
              ),
            )
          ],
        ),
        Row(
          children: [
            appController.commentChatModels[index].phone!.isEmpty
                ? const SizedBox()
                : const WidgetImage(
                    path: 'images/phone.jpg',
                    size: 33,
                  ),
            appController.commentChatModels[index].amount!.isEmpty
                ? const SizedBox()
                : InkWell(
                    onTap: () {
                      AppDialog(context: context).buyDialog(
                          commentChatModel:
                              appController.commentChatModels[index]);
                    },
                    child: badges.Badge(
                      badgeContent: WidgetText(
                          text: appController.commentChatModels[index].amount ??
                              ''),
                      child: const Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                    ),
                  ),
            const SizedBox(
              width: 12,
            ),
            appController.commentChatModels[index].line!.isEmpty
                ? const SizedBox()
                : const WidgetImage(
                    path: 'images/line.jpg',
                    size: 33,
                  ),
            WidgetButton(
              label: 'Live Chat',
              pressFunc: () {
                Get.to(AnswerChat(
                  docIdComment: appController.docIdCommentChats[index],
                  commentChatModel: appController.commentChatModels[index],
                ));
              },
              iconWidget: const Icon(
                Icons.turn_left,
                color: Colors.white,
              ),
              bgColor: Colors.red,
            ),
          ],
        ),
      ],
    );
  }

  Widget answerList(AppController appController, int index) {
    return appController.commentChatModels[index].answers!.isEmpty
        ? const SizedBox()
        : Container(
            height: 150,
            // constraints:  BoxConstraints(maxHeight: 150),
            padding: const EdgeInsets.all(8),
            decoration: AppConstant().boxBlack(color: Colors.white),
            child: ListView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: appController.commentChatModels[index].answers!.length,
              itemBuilder: (context, index2) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  appController.commentChatModels[index].avatars!.isEmpty
                      ? const SizedBox()
                      : WidgetCircularImage(
                          urlImage: appController
                              .commentChatModels[index].avatars![index2],
                          radius: 15,
                        ),
                  const SizedBox(
                    width: 4,
                  ),
                  appController.commentChatModels[index].names!.isEmpty
                      ? const SizedBox()
                      : WidgetText(
                          text:
                              '${appController.commentChatModels[index].names![index2]} : ',
                          textStyle: AppConstant().h3Style(color: Colors.red),
                        ),
                  Expanded(
                    child: WidgetText(
                      text: appController
                          .commentChatModels[index].answers![index2],
                      textStyle: AppConstant().h3Style(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  ExpandableText messageText(AppController appController, int index) {
    return ExpandableText(
      appController.commentChatModels[index].message,
      expandText: 'ดูเพิ่มเติม',
      collapseText: '... ย่อ',
      style: AppConstant().h3Style(),
      linkStyle: AppConstant().h3Style(size: 19, fontWeight: FontWeight.bold),
      maxLines: 2,
      linkColor: Colors.white,
    );
  }

  Widget multiImage(AppController appController, int index) {
    return appController.commentChatModels[index].urlMultiImages.isEmpty
        ? const SizedBox()
        : ListView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount:
                appController.commentChatModels[index].urlMultiImages.length,
            itemBuilder: (context, index2) => Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: WidgetImageInternet(
                    urlImage: appController
                        .commentChatModels[index].urlMultiImages[index2],
                    width: 180,
                    height: 150,
                    boxFit: BoxFit.cover,
                    tapFunc: () {
                      displayFullScreen(
                          url: appController
                              .commentChatModels[index].urlMultiImages[index2]);
                    },
                  ),
                ),
              ],
            ),
          );
  }

  Widget singleImage(AppController appController, int index) {
    return appController.commentChatModels[index].urlRealPost.isEmpty
        ? const SizedBox()
        : appController.commentChatModels[index].urlMultiImages.isEmpty
            ? WidgetImageInternet(
                urlImage: appController.commentChatModels[index].urlRealPost,
                width: 180,
                height: 150,
                boxFit: BoxFit.cover,
                tapFunc: () {
                  displayFullScreen(
                      url: appController.commentChatModels[index].urlRealPost);
                },
              )
            : const SizedBox();
  }

  Row displayNameAvatar(AppController appController, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        WidgetCircularImage(
          urlImage: appController.commentChatModels[index].urlAvatar,
          radius: 15,
        ),
        const SizedBox(
          width: 8,
        ),
        WidgetText(text: appController.commentChatModels[index].disPlayName),
      ],
    );
  }
}
