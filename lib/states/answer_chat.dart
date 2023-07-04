// ignore_for_file: public_member_api_docs, sort_constructors_first, unrelated_type_equality_checks, avoid_print, sort_child_properties_last, unnecessary_null_comparison
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

class AnswerChat extends StatefulWidget {
  const AnswerChat({
    Key? key,
    required this.docIdPost,
  }) : super(key: key);

  final String docIdPost;

  @override
  State<AnswerChat> createState() => _AnswerChatState();
}

class _AnswerChatState extends State<AnswerChat> {
  AppController appController = Get.put(AppController());

  var textEditingController = TextEditingController();
  Map<String, dynamic> map = {};

  // String docIdComment = 'pND5LF4PLpme7rrkIcm3';
  ChatModel? commentChatModel;
  bool owner = true;

  @override
  void initState() {
    super.initState();

    findCommentChatModel();
  }

  Future<void> findCommentChatModel() async {
    FirebaseFirestore.instance
        .collection('post')
        .doc(widget.docIdPost)
        .get()
        .then((value) {
      commentChatModel = ChatModel.fromMap(value.data()!);

      print('##2july commentChatModel---> ${commentChatModel!.toMap()}');

      AppService().readAnswer(
          docIdComment: widget.docIdPost, uidOwner: commentChatModel!.uidChat);

      owner = appController.userModelsLogin.last.uidUser ==
          commentChatModel!.uidChat;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      // appBar: AppBar(),
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: commentChatModel == null
              ? const SizedBox()
              : SizedBox(
                  width: boxConstraints.maxWidth,
                  height: boxConstraints.maxHeight,
                  child: Stack(
                    children: [
                      imageSliteShow(boxConstraints),
                      // listChatAnswer(boxConstraints),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          guestListView(boxConstraints: boxConstraints),
                          ownerLast(boxConstraints: boxConstraints),
                          const SizedBox(
                            height: 60,
                          ),
                        ],
                      ),
                      panalFormChat(),
                      panalAddLinePhone(),
                    ],
                  ),
                ),
        );
      }),
    );
  }

  Positioned panalAddLinePhone() {
    return Positioned(
      right: 8,
      bottom: 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          WidgetImage(
            path: 'images/addgreen.png',
            size: 36,
            tapFunc: () async {
              String docIdpost = '';
              FirebaseFirestore.instance.collection('post').get().then((value) {
                for (var element in value.docs) {
                  ChatModel chatModel = ChatModel.fromMap(element.data());
                  if (chatModel.uidChat ==
                      appController.userModelsLogin.last.uidUser) {
                    docIdpost = element.id;
                  }
                }
                print('##3july docIDpost ---> $docIdpost');
                if (docIdpost.isEmpty) {
                  //No Post

                  ChatModel chatModel = ChatModel(
                      message: '',
                      timestamp: Timestamp.fromDate(DateTime.now()),
                      uidChat: appController.userModelsLogin.last.uidUser!,
                      disPlayName:
                          appController.userModelsLogin.last.displayName!,
                      urlAvatar: appController.userModelsLogin.last.urlAvatar!,
                      urlRealPost: '',
                      albums: [],
                      urlMultiImages: [],
                      amountComment: 0,
                      amountGraph: 0);

                  DocumentReference documentReference =
                      FirebaseFirestore.instance.collection('post').doc();

                  documentReference.set(chatModel.toMap()).then((value) {
                    String docIdPost = documentReference.id;
                    print(
                        '##3july no Post documentReference ----> $documentReference');

                    AppService().processChooseMultiImageChat().then((value) {
                      AppBottomSheet().bottomSheetMultiImage(
                          context: context, docIdComment: docIdPost);
                    });
                  });
                } else {
                  //Have Post
                  AppService().processChooseMultiImageChat().then((value) {
                    AppBottomSheet().bottomSheetMultiImage(
                        context: context, docIdComment: docIdpost);
                  });
                }
              });
            },
          ),
          const SizedBox(
            height: 12,
          ),
          const WidgetImage(
            path: 'images/cart.png',
            size: 36,
          ),
          const SizedBox(
            height: 12,
          ),

          // widget.commentChatModel.line!.isEmpty
          //     ? const SizedBox()
          //     : WidgetImage(
          //         path: 'images/line.jpg',
          //         size: 36,
          //         tapFunc: () {
          //           AppService()
          //               .processLunchUrl(url: widget.commentChatModel.line!);
          //         },
          //       ),
          const SizedBox(
            height: 12,
          ),
          // widget.commentChatModel.phone!.isEmpty
          //     ? const SizedBox()
          //     : WidgetImage(
          //         path: 'images/phone.jpg',
          //         tapFunc: () {
          //           AppService().processPhoneLunchUrl(
          //               phone: widget.commentChatModel.phone!);
          //         },
          //         size: 36,
          //       ),
        ],
      ),
    );
  }

  Obx imageSliteShow(BoxConstraints boxConstraints) {
    return Obx(() {
      return appController.answerChatModelsForOwner.isEmpty
          ? const SizedBox()
          : appController.listUrlImageAnswerOwners.isEmpty
              ? Center(
                  child: WidgetText(
                    text: 'ไม่มีภาพ',
                    textStyle: AppConstant().h2Style(color: Colors.white),
                  ),
                )
              : SizedBox(
                  width: double.infinity,
                  height: boxConstraints.maxHeight - 70,
                  child: Stack(
                    children: [
                      ImageSlideshow(
                        height: boxConstraints.maxHeight - 70,
                        children: appController.listUrlImageAnswerOwners[0]
                            .map((e) => WidgetImageInternet(
                                  urlImage: e,
                                  boxFit: BoxFit.contain,
                                ))
                            .toList(),
                        isLoop: true,
                        autoPlayInterval: 10000,
                      ),
                      // Positioned(
                      //   bottom: 0,
                      //   right: 0,
                      //   child: WidgetIconButton(
                      //     size: 45,
                      //     pressFunc: () {},
                      //     iconData: Icons.shopping_cart_outlined,
                      //   ),
                      // ),
                    ],
                  ),
                );
    });
  }

  Widget displayMessage({required BoxConstraints boxConstraints}) {
    return appController.listMessageAnswerOwners.isEmpty
        ? const SizedBox()
        : Positioned(
            // bottom: 4,
            top: boxConstraints.maxHeight * 0.7 - 70,
            child: Container(
              width: boxConstraints.maxWidth - 60,
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(4),
              decoration:
                  AppConstant().boxCurve(color: Colors.black.withOpacity(0.5)),
              child: WidgetText(
                text: appController.listMessageAnswerOwners.last,
                textStyle: AppConstant().h3Style(color: Colors.white),
              ),
            ),
          );
  }

  Widget listChatAnswer(BoxConstraints boxConstraints) {
    return Obx(() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: double.infinity,
            height: boxConstraints.maxHeight * 0.6,
            child: appController.answerChatModels.isEmpty
                ? const SizedBox()
                : ListView.builder(
                    reverse: true,
                    itemBuilder: (context, index) => Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          padding: const EdgeInsets.all(8),
                          decoration: AppConstant()
                              .boxCurve(color: Colors.black.withOpacity(0.2)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              appController.answerChatModels[index].uidChat ==
                                      appController.userModelsLogin.last.uidUser
                                  ? const SizedBox()
                                  : WidgetCircularImage(
                                      radius: 12,
                                      urlImage: appController
                                          .answerChatModels[index].urlAvatar),
                              const SizedBox(
                                width: 8,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  WidgetText(
                                      text: appController
                                          .answerChatModels[index].disPlayName),
                                  Container(
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            boxConstraints.maxWidth * 0.75),
                                    child: WidgetText(
                                        text: appController
                                            .answerChatModels[index].message),
                                  ),
                                  // appController.answerChatModels[index]
                                  //             .uidChat ==
                                  //         appController
                                  //             .userModelsLogin.last.uidUser
                                  //     ? const SizedBox()
                                  //     : WidgetTextButton(
                                  //         text: 'ตอบ',
                                  //         color: Colors.yellow,
                                  //         pressFunc: () {},
                                  //       )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    itemCount: appController.answerChatModels.length,
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                  ),
          ),
          const SizedBox(
            height: 60,
          )
        ],
      );
    });
  }

  Widget ownerListView({required BoxConstraints boxConstraints}) {
    return Obx(() {
      return appController.answerChatModelsForOwner.isEmpty
          ? const SizedBox()
          : SizedBox(
              height: 80,
              child: ListView.builder(
                itemCount: appController.answerChatModelsForOwner.length,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) => appController
                        .answerChatModelsForOwner[index].message.isEmpty
                    ? const SizedBox()
                    : Row(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                                maxWidth: boxConstraints.maxWidth * 0.75),
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.all(8),
                            decoration: AppConstant()
                                .boxCurve(color: Colors.black.withOpacity(0.2)),
                            child: WidgetText(
                                text: appController
                                    .answerChatModelsForOwner[index].message),
                          ),
                        ],
                      ),
              ),
            );
    });
  }

  Widget ownerLast({required BoxConstraints boxConstraints}) {
    return Obx(() {
      return appController.answerChatModelsForOwner.isEmpty
          ? const SizedBox()
          : SizedBox(
              height: 60,
              child: ListView.builder(
                itemCount: 1,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) => appController
                        .answerChatModelsForOwner[index].message.isEmpty
                    ? const SizedBox()
                    : Row(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: WidgetCircularImage(
                                    urlImage: appController
                                        .answerChatModelsForOwner[index]
                                        .urlAvatar),
                              ),
                              Container(
                                constraints: BoxConstraints(
                                    maxWidth: boxConstraints.maxWidth * 0.75),
                                margin: const EdgeInsets.only(top: 8),
                                padding: const EdgeInsets.all(8),
                                decoration: AppConstant().boxCurve(
                                    color: Colors.red.withOpacity(0.5)),
                                child: WidgetText(
                                    text: appController
                                        .answerChatModelsForOwner[index]
                                        .message),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            );
    });
  }

  Widget guestListView({required BoxConstraints boxConstraints}) {
    return Obx(() {
      return SizedBox(
        height: boxConstraints.maxHeight * 0.6,
        child: ListView.builder(
          itemCount: appController.answerChatModelsForGuest.length,
          shrinkWrap: true,
          reverse: true,
          physics: const ScrollPhysics(),
          itemBuilder: (context, index) => Row(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(8),
                decoration: AppConstant()
                    .boxCurve(color: Colors.black.withOpacity(0.2)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetCircularImage(
                      urlImage: appController
                          .answerChatModelsForGuest[index].urlAvatar,
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
                            const WidgetText(text: ': '),
                            WidgetText(
                                text: appController
                                    .answerChatModelsForGuest[index].message),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
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
                          tapFunc: () {},
                          width: 70,
                          urlImage: appController.stampModels[index].url),
                    ),
                  ),
                )
              : const SizedBox(),
          owner == null
              ? const SizedBox()
              : Row(
                  children: [
                    owner
                        ? WidgetIconButton(
                            pressFunc: () {
                              AppService()
                                  .processTakePhoto(source: ImageSource.camera)
                                  .then((value) {
                                AppService()
                                    .processUploadPhoto(
                                        file: value!, path: 'comment')
                                    .then((value) {
                                  String urlImageComment = value!;

                                  print(
                                      '##4july urlImage ---> $urlImageComment');

                                 



                                });
                              });
                            },
                            iconData: Icons.add_a_photo,
                            color: AppConstant.realFront,
                          )
                        : const SizedBox(
                            width: 32,
                          ),
                    owner
                        ? WidgetIconButton(
                            pressFunc: () {
                              AppService()
                                  .processChooseMultiImageChat()
                                  .then((value) {
                                AppBottomSheet().bottomSheetMultiImage(
                                    context: context,
                                    docIdComment: widget.docIdPost);
                              });
                            },
                            iconData: Icons.add_photo_alternate,
                            color: AppConstant.realFront,
                          )
                        : const SizedBox(),
                    Expanded(
                      child: WidgetForm(
                        fillColor: AppConstant.realMid,
                        controller: textEditingController,
                        hint: 'แชดสด',
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
                            urlAvatar:
                                appController.userModelsLogin.last.urlAvatar!,
                            urlRealPost: appController.urlEmojiChooses.isEmpty
                                ? ''
                                : appController.urlEmojiChooses.last,
                            albums: [],
                            urlMultiImages: [],
                            up: 0,
                            amountComment: 0,
                            amountGraph: 0,
                          );

                          map = commentChatModel!.toMap();

                          print(
                              '##20june chatModel ----> ${chatModel.toMap()}');

                          AppService()
                              .insertAnswer(
                                  chatModel: chatModel,
                                  docIdComment: widget.docIdPost)
                              .then((value) {
                            print('##20june map before $map');

                            var answers = <String>[];
                            answers.addAll(map['answers']);
                            answers.add(textEditingController.text);
                            map['answers'] = answers;

                            print('##14june map after $map');

                            AppService()
                                .updateCommentChat(
                                    map: map, docIdComment: widget.docIdPost)
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
