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
    AppService().readCommentChat(docIdChat: '0teBbEDSyimbXgvzYwGJ');
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
                    '##10june commentChatModels -----> ${appController.commentChatModels.length}');

                return appController.chatModels.isEmpty
                    ? const SizedBox()
                    : SizedBox(
                        width: boxConstraints.maxWidth,
                        height: boxConstraints.maxHeight,
                        child: Stack(
                          children: [
                            SizedBox(
                              height: boxConstraints.maxHeight - 70,
                              child: ListView(
                                children: [
                                  appController.commentChatModels.isEmpty
                                      ? const SizedBox()
                                      : ListView.builder(
                                          physics: const ScrollPhysics(),
                                          shrinkWrap: true,
                                          reverse: true,
                                          itemCount: appController
                                              .commentChatModels.length,
                                          itemBuilder: (context, index) =>
                                              Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16, bottom: 10),
                                            child: Container(
                                              decoration: AppConstant()
                                                  .boxBlack(
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 26, 22, 22)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      WidgetCircularImage(
                                                        urlImage: appController
                                                            .commentChatModels[
                                                                index]
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
                                                          .commentChatModels[
                                                              index]
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
                                                              boxFit:
                                                                  BoxFit.cover,
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
                                                          .commentChatModels[
                                                              index]
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
                                                          itemBuilder: (context,
                                                                  index2) =>
                                                              Row(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child:
                                                                    WidgetImageInternet(
                                                                  urlImage: appController
                                                                      .commentChatModels[
                                                                          index]
                                                                      .urlMultiImages[index2],
                                                                  width: 180,
                                                                  height: 150,
                                                                  boxFit: BoxFit
                                                                      .cover,
                                                                  tapFunc: () {
                                                                    displayFullScreen(
                                                                        url: appController
                                                                            .commentChatModels[index]
                                                                            .urlMultiImages[index2]);
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                  // WidgetText(
                                                  //   text: appController
                                                  //       .commentChatModels[
                                                  //           index]
                                                  //       .message,
                                                  //   textStyle: AppConstant()
                                                  //       .h3Style(size: 16),
                                                  // ),

                                                  ExpandableText(
                                                    appController
                                                        .commentChatModels[
                                                            index]
                                                        .message,
                                                    expandText: 'ดูเพิ่มเติม',
                                                    collapseText: '... ย่อ',
                                                    style:
                                                        AppConstant().h3Style(),
                                                    linkStyle: AppConstant()
                                                        .h3Style(
                                                            size: 19,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                    maxLines: 2,
                                                    linkColor: Colors.white,
                                                  ),

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
                                                          appController
                                                                  .commentChatModels[
                                                                      index]
                                                                  .phone!
                                                                  .isEmpty
                                                              ? const SizedBox()
                                                              : const WidgetImage(
                                                                  path:
                                                                      'images/phone.jpg',
                                                                  size: 36,
                                                                ),
                                                          appController
                                                                  .commentChatModels[
                                                                      index]
                                                                  .amount!
                                                                  .isEmpty
                                                              ? const SizedBox()
                                                              : InkWell(
                                                                  onTap: () {
                                                                    AppDialog(
                                                                            context:
                                                                                context)
                                                                        .buyDialog(
                                                                            commentChatModel:
                                                                                appController.commentChatModels[index]);
                                                                  },
                                                                  child: badges
                                                                      .Badge(
                                                                    badgeContent:
                                                                        WidgetText(
                                                                            text:
                                                                                appController.commentChatModels[index].amount ?? ''),
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .shopping_cart,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                          const SizedBox(
                                                            width: 12,
                                                          ),
                                                          appController
                                                                  .commentChatModels[
                                                                      index]
                                                                  .line!
                                                                  .isEmpty
                                                              ? const SizedBox()
                                                              : const WidgetImage(
                                                                  path:
                                                                      'images/line.jpg',
                                                                  size: 36,
                                                                ),
                                                          WidgetButton(
                                                            label: 'สนทนา',
                                                            pressFunc: () {
                                                              Get.to(
                                                                   AnswerChat(docIdComment: appController.docIdCommentChats[index],));

                                                              // AppDialog(context: context).answerDialog(
                                                              //     docIdComment:
                                                              //         appController
                                                              //                 .docIdCommentChats[
                                                              //             index],
                                                              //     docIdChat:
                                                              //         appController
                                                              //             .docIdChats[0]);
                                                            },
                                                            iconWidget:
                                                                const Icon(
                                                              Icons.turn_left,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            bgColor:
                                                                Colors.black,
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
}
