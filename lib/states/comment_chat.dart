// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:realpost/models/chat_model.dart';
import 'package:realpost/states/answer_chat.dart';
import 'package:realpost/states/display_photo_view.dart';
import 'package:realpost/states/display_profile.dart';
import 'package:realpost/utility/app_bottom_sheet.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_dialog.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_circular_image.dart';
import 'package:realpost/widgets/widget_form.dart';
import 'package:realpost/widgets/widget_icon_button.dart';
import 'package:realpost/widgets/widget_image.dart';
import 'package:realpost/widgets/widget_image_internet.dart';
import 'package:realpost/widgets/widget_text.dart';

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

    AppService().freshUserModelLogin().then((value) =>
        print('##19june ===> ${controller.userModelsLogin.last.toMap()}'));

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
                return SizedBox(
                  width: boxConstraints.maxWidth,
                  height: boxConstraints.maxHeight,
                  child: Stack(
                    children: [
                      contentMain(
                          appController: appController,
                          boxConstraints: boxConstraints),
                      contentFormAddComment(appController, context),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }

  Column contentFormAddComment(AppController appController, BuildContext context) {
    return Column(
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
                                          clearAllTabStamp(appController);

                                          appController.tapStamps[index] =
                                              true;
                                          appController.urlEmojiChooses.add(
                                              appController
                                                  .stampModels[index].url);
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
                                        docIdChat:
                                            appController.docIdChats[0]);
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
                                        appController.displayListEmoji.value =
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
                                
                                if ((textEditingController.text.isNotEmpty) ||
                                    (appController
                                        .urlEmojiChooses.isNotEmpty)) {
                                  AppDialog(context: context).dialogProcess();

                                  ChatModel chatModel = ChatModel(
                                    message: textEditingController.text,
                                    timestamp:
                                        Timestamp.fromDate(DateTime.now()),
                                    uidChat: appController
                                        .userModelsLogin.last.uidUser!,
                                    disPlayName: appController
                                        .userModelsLogin.last.displayName!,
                                    urlAvatar: appController
                                        .userModelsLogin.last.urlAvatar!,
                                    urlRealPost: appController
                                            .urlEmojiChooses.isEmpty
                                        ? ''
                                        : appController.urlEmojiChooses.last,
                                    albums: [],
                                    urlMultiImages: [],
                                    up: 0,
                                    amountComment: 0,
                                    amountGraph: 0,
                                  );

                                  AppService()
                                      .insertCommentChat(
                                          commentChatModel: chatModel)
                                      .then((value) async {
                                    Get.back();

                                    textEditingController.text = '';
                                    appController.urlAvatarChooses.clear();
                                    clearAllTabStamp(appController);
                                    appController.displayListEmoji.value =
                                        false;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ],
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
                  urlImage: controller.userModelsLogin.last.urlAvatar!,
                  tapFunc: () {
                    Get.to(const DisplayProfile());
                  },
                );
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
              : GridView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: appController.commentChatModels.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.6),
                  itemBuilder: (context, index) => Container(
                    decoration: AppConstant()
                        .boxBlack(color: const Color.fromARGB(255, 26, 22, 22)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        singleImage(appController, index,
                            boxConstraints: boxConstraints),
                        multiImage(appController, index,
                            boxConstraints: boxConstraints),
                        messageText(appController, index),
                        displayNameAvatar(appController, index),
                        // answerList(appController, index),
                        // displayPanal(appController, index, context),
                      ],
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
            InkWell(
              onTap: () {
                Map<String, dynamic> map =
                    appController.commentChatModels[index].toMap();

                int up = map['up'];
                up++;
                map['up'] = up;

                AppService().updateCommentChat(
                    map: map,
                    docIdComment: appController.docIdCommentChats[index]);
              },
              child: const WidgetImage(
                path: 'images/arrowup.jpg',
                size: 24,
              ),
            ),
            WidgetText(
                text: appController.commentChatModels[index].up.toString()),
            InkWell(
              onTap: () {
                Map<String, dynamic> map =
                    appController.commentChatModels[index].toMap();
                int down = map['down'];
                down--;
                map['down'] = down;
                AppService().updateCommentChat(
                    map: map,
                    docIdComment: appController.docIdCommentChats[index]);
              },
              child: const WidgetImage(
                path: 'images/arrowdown.jpg',
                size: 24,
              ),
            ),
            WidgetText(
              text: appController.commentChatModels[index].down.toString(),
              textStyle: AppConstant().h3Style(color: Colors.red),
            ),
            const SizedBox(
              width: 8,
            ),
            InkWell(
              onTap: () {
                Map<String, dynamic> map =
                    appController.commentChatModels[index].toMap();

                map['timestamp'] = Timestamp.fromDate(DateTime.now());

                int favorit = map['favorit'];
                favorit++;
                map['favorit'] = favorit;

                AppService()
                    .updateCommentChat(
                        map: map,
                        docIdComment: appController.docIdCommentChats[index])
                    .then((value) {});
              },
              child: const WidgetImage(
                path: 'images/up.jpg',
                size: 24,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            WidgetText(
              text: appController.commentChatModels[index].favorit.toString(),
              textStyle: AppConstant().h3Style(color: Colors.white),
            ),
          ],
        ),
        // Row(
        //   children: [
        //     appController.commentChatModels[index].phone!.isEmpty
        //         ? const SizedBox()
        //         : const WidgetImage(
        //             path: 'images/phone.jpg',
        //             size: 33,
        //           ),
        //     appController.commentChatModels[index].amount!.isEmpty
        //         ? const SizedBox()
        //         : InkWell(
        //             onTap: () {
        //               AppDialog(context: context).buyDialog(
        //                   commentChatModel:
        //                       appController.commentChatModels[index]);
        //             },
        //             child: badges.Badge(
        //               badgeContent: WidgetText(
        //                   text: appController.commentChatModels[index].amount ??
        //                       ''),
        //               child: const Icon(
        //                 Icons.shopping_cart,
        //                 color: Colors.white,
        //               ),
        //             ),
        //           ),
        //     const SizedBox(
        //       width: 12,
        //     ),
        //     appController.commentChatModels[index].line!.isEmpty
        //         ? const SizedBox()
        //         : const WidgetImage(
        //             path: 'images/line.jpg',
        //             size: 33,
        //           ),
        //     WidgetButton(
        //       label: 'Chat',
        //       pressFunc: () {
        //         Get.to(AnswerChat(
        //           docIdComment: appController.docIdCommentChats[index],
        //           commentChatModel: appController.commentChatModels[index],
        //         ));
        //       },
        //       bgColor: Colors.red,
        //     ),
        //   ],
        // ),
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

  // ExpandableText messageText(AppController appController, int index) {
  //   return ExpandableText(
  //     appController.commentChatModels[index].message,
  //     expandText: 'ดูเพิ่มเติม',
  //     collapseText: '... ย่อ',
  //     style: AppConstant().h3Style(),
  //     linkStyle: AppConstant().h3Style(size: 19, fontWeight: FontWeight.bold),
  //     maxLines: 2,
  //     linkColor: Colors.white,
  //   );
  // }

  Widget messageText(AppController appController, int index) => Text(
        appController.commentChatModels[index].message,
        style: AppConstant().h3Style(color: Colors.white),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );

  Widget multiImage(AppController appController, int index,
      {required BoxConstraints boxConstraints}) {
    return appController.commentChatModels[index].urlMultiImages.isEmpty
        ? const SizedBox()
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WidgetImageInternet(
                urlImage:
                    appController.commentChatModels[index].urlMultiImages.last,
                width: boxConstraints.maxWidth * 0.4,
                height: boxConstraints.maxWidth * 0.6,
                boxFit: BoxFit.cover,
                tapFunc: () {
                  Get.to(AnswerChat(
                    docIdComment: appController.docIdCommentChats[index],
                    commentChatModel: appController.commentChatModels[index],
                    owner: appController.userModelsLogin.last.uidUser ==
                        appController.commentChatModels[index].uidChat,
                  ));
                },
              ),
            ],
          );
  }

  Widget singleImage(AppController appController, int index,
      {required BoxConstraints boxConstraints}) {
    return appController.commentChatModels[index].urlRealPost.isEmpty
        ? const SizedBox()
        : appController.commentChatModels[index].urlMultiImages.isEmpty
            ? WidgetImageInternet(
                urlImage: appController.commentChatModels[index].urlRealPost,
                width: boxConstraints.maxWidth * 0.3,
                height: boxConstraints.maxWidth * 0.3,
                boxFit: BoxFit.cover,
                tapFunc: () {
                  displayFullScreen(
                      url: appController.commentChatModels[index].urlRealPost);
                },
              )
            : const SizedBox();
  }

  Widget displayNameAvatar(AppController appController, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        WidgetCircularImage(
          urlImage: appController.commentChatModels[index].urlAvatar,
          radius: 10,
        ),
        const SizedBox(
          width: 4,
        ),
        WidgetText(text: appController.commentChatModels[index].disPlayName),
        const SizedBox(
          width: 4,
        ),
        WidgetIconButton(
          iconData: Icons.favorite_outline,
          size: 20,
          pressFunc: () {
            Map<String, dynamic> map =
                appController.commentChatModels[index].toMap();

            int up = map['up'];
            up++;
            map['up'] = up;

            AppService().updateCommentChat(
                map: map, docIdComment: appController.docIdCommentChats[index]);
          },
        ),
        const WidgetText(text: '0'),
        // InkWell(
        //   onTap: () {
        //     Map<String, dynamic> map =
        //         appController.commentChatModels[index].toMap();
        //     int down = map['down'];
        //     down--;
        //     map['down'] = down;
        //     AppService().updateCommentChat(
        //         map: map, docIdComment: appController.docIdCommentChats[index]);
        //   },
        //   child: const WidgetImage(
        //     path: 'images/arrowdown.jpg',
        //     size: 24,
        //   ),
        // ),
        // WidgetText(
        //   text: '0',
        //   textStyle: AppConstant().h3Style(color: Colors.red),
        // ),
        // WidgetText(
        //   text: appController.commentChatModels[index].uidChat

        // ),
      ],
    );
  }
}
