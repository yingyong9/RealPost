// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realpost/models/chat_model.dart';
import 'package:realpost/models/comment_salse_model.dart';
import 'package:realpost/models/room_model.dart';
import 'package:realpost/models/user_model.dart';
import 'package:realpost/states/add_product.dart';
import 'package:realpost/states/private_chat.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/utility/app_snackbar.dart';
import 'package:realpost/widgets/widget_button.dart';
import 'package:realpost/widgets/widget_choose_amout_salse.dart';
import 'package:realpost/widgets/widget_form.dart';
import 'package:realpost/widgets/widget_icon_button.dart';
import 'package:realpost/widgets/widget_image.dart';
import 'package:realpost/widgets/widget_image_internet.dart';
import 'package:realpost/widgets/widget_listview_hoizontal.dart';
import 'package:realpost/widgets/widget_text.dart';

class AppBottomSheet {
  AppController appController = Get.put(AppController());

  void dipsplayImage({required String urlImage, required String docIdChat}) {
    TextEditingController textEditingController = TextEditingController();

    Get.bottomSheet(
      Container(
        decoration: AppConstant().boxCurve(color: AppConstant.realBg),
        width: double.infinity,
        height: 250,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WidgetImageInternet(
                  urlImage: urlImage,
                  height: 200,
                ),
              ],
            ),
            Row(
              children: [
                WidgetIconButton(
                  pressFunc: () {
                    Get.back();
                    AppService()
                        .processTakePhoto(source: ImageSource.camera)
                        .then((value) {
                      AppService()
                          .processUploadPhoto(file: value!, path: 'comment')
                          .then((value) {
                        String urlImageComment = value!;
                        print('##18may urlImageComment --> $urlImageComment');

                        // AppBottomSheet()
                        //     .dipsplayImage(urlImage: urlImageComment);
                      });
                    });
                  },
                  iconData: Icons.add_a_photo,
                  color: AppConstant.realFront,
                ),
                WidgetIconButton(
                  pressFunc: () {
                    Get.back();
                    AppService()
                        .processTakePhoto(source: ImageSource.gallery)
                        .then((value) {
                      AppService()
                          .processUploadPhoto(file: value!, path: 'comment')
                          .then((value) {
                        String urlImageComment = value!;
                        print('##18may urlImageComment --> $urlImageComment');

                        // AppBottomSheet()
                        //     .dipsplayImage(urlImage: urlImageComment);
                      });
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
                    hint: 'Comment',
                    hintStyle: AppConstant().h3Style(color: Colors.white),
                    textStyle: AppConstant().h3Style(color: Colors.white),
                    suffixIcon: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        WidgetImage(
                          path: 'images/emoj.jpg',
                          size: 36,
                        ),
                      ],
                    ),
                  ),
                ),
                WidgetImage(
                  path: 'images/rocket.png',
                  size: 48,
                  tapFunc: () {
                    ChatModel chatModel = ChatModel(
                        message: textEditingController.text,
                        timestamp: Timestamp.fromDate(DateTime.now()),
                        uidChat: appController.mainUid.value,
                        disPlayName:
                            appController.userModelsLogin.last.displayName!,
                        urlAvatar:
                            appController.userModelsLogin.last.urlAvatar!,
                        urlRealPost: urlImage,
                        albums: [], urlMultiImages: [], up: 0);

                    print('##18may chatModel ---> ${chatModel.toMap()}');

                    AppService()
                        .insertCommentChat(
                            docIdChat: docIdChat, commentChatModel: chatModel)
                        .then((value) {
                      textEditingController.text = '';
                      Get.back();
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),isScrollControlled: true
    );
  }

  void realGestBottonSheet() {
    AppController controller = Get.put(AppController());
    if ((controller.fileRealPosts.isNotEmpty) ||
        (controller.urlRealPostChooses.isNotEmpty)) {
      controller.fileRealPosts.clear();
      controller.urlRealPostChooses.clear();
    }

    Get.bottomSheet(
      GetX(
          init: AppController(),
          builder: (AppController appController) {
            return Container(
              decoration: BoxDecoration(color: AppConstant.bgColor),
              constraints: BoxConstraints(maxHeight: 356, minHeight: 150),
              // height: 356,
              // height: 100,
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      WidgetText(
                        text: 'Real Post',
                        textStyle:
                            AppConstant().h2Style(color: Colors.red.shade700),
                      ),
                      appController.urlRealPostChooses.isNotEmpty
                          ? WidgetImageInternet(
                              urlImage: appController.urlRealPostChooses.last,
                              width: 200,
                              height: 200,
                            )
                          : appController.fileRealPosts.isEmpty
                              ? const SizedBox()
                              : Image.file(
                                  appController.fileRealPosts[0],
                                  width: 200,
                                  height: 200,
                                ),
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: appController.stampModels.length,
                          itemBuilder: (context, index) => WidgetImageInternet(
                            urlImage: appController.stampModels[index].url,
                            tapFunc: () async {
                              appController.urlRealPostChooses
                                  .add(appController.stampModels[index].url);

                              ChatModel chatModel = await AppService()
                                  .createChatModel(
                                      urlRealPost: appController
                                          .urlRealPostChooses.last);

                              print(
                                  '##26april  chatModel ---> ${chatModel.toMap()}');
                            },
                          ),
                        ),
                      ),
                      Divider(
                        color: AppConstant.dark,
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          WidgetIconButton(
                            iconData: Icons.add_a_photo,
                            pressFunc: () async {
                              if (appController.fileRealPosts.isNotEmpty) {
                                appController.fileRealPosts.clear();
                              }

                              if (appController.urlRealPostChooses.isNotEmpty) {
                                appController.urlRealPostChooses.clear();
                              }

                              var result = await AppService()
                                  .processTakePhoto(source: ImageSource.camera);
                              if (result != null) {
                                appController.fileRealPosts.add(result);
                              }
                            },
                          ),
                          WidgetIconButton(
                            pressFunc: () async {
                              if (appController.fileRealPosts.isNotEmpty) {
                                appController.fileRealPosts.clear();
                              }

                              if (appController.urlRealPostChooses.isNotEmpty) {
                                appController.urlRealPostChooses.clear();
                              }

                              var result = await AppService().processTakePhoto(
                                  source: ImageSource.gallery);
                              if (result != null) {
                                appController.fileRealPosts.add(result);
                              }
                            },
                            iconData: Icons.add_photo_alternate,
                          ),
                          Expanded(
                              child: WidgetForm(
                            fillColor: Colors.grey.shade300,
                            maginBottom: 4,
                            height: 40,
                            changeFunc: (p0) {
                              appController.messageChats.add(p0.trim());
                            },
                          )),
                          WidgetIconButton(
                            iconData: Icons.send,
                            pressFunc: () async {
                              print(
                                  '##26april fileRealposts.length ===>  ${appController.fileRealPosts.length}');

                              //upload
                              await AppService()
                                  .processUploadPhoto(
                                      file: appController.fileRealPosts.last,
                                      path: 'realpost')
                                  .then((value) async {
                                print(
                                    '##26april url ของภาพที่ อัพโหลดไป ---> $value');

                                if (appController
                                    .urlRealPostChooses.isNotEmpty) {
                                  appController.urlRealPostChooses.clear();
                                }

                                appController.urlRealPostChooses
                                    .add(value.toString());

                                ChatModel chatModel = await AppService()
                                    .createChatModel(
                                        urlRealPost: appController
                                            .urlRealPostChooses.last);

                                print(
                                    '##26april chatModel for insert ---->>> ${chatModel.toMap()}');

                                //Insert CollectionChat --> chat
                                AppService()
                                    .processInsertChat(
                                  chatModel: chatModel,
                                  docIdRoom: appController.docIdRooms[
                                      appController
                                          .indexBodyMainPageView.value],
                                )
                                    .then((value) async {
                                  AppService()
                                      .processInsertChat(
                                          collectionChat: 'chatOwner',
                                          chatModel: chatModel,
                                          docIdRoom: appController.docIdRooms[
                                              appController
                                                  .indexBodyMainPageView.value])
                                      .then((value) {
                                    Get.back();
                                    Get.back();
                                  });
                                });
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  WidgetIconButton(
                    pressFunc: () {
                      if (appController.fileRealPosts.isNotEmpty) {
                        appController.fileRealPosts.clear();
                      }

                      if (appController.urlRealPostChooses.isNotEmpty) {
                        appController.urlRealPostChooses.clear();
                      }

                      if (appController.xFiles.isNotEmpty) {
                        appController.xFiles.clear();
                      }

                      Get.back();
                    },
                    iconData: GetPlatform.isAndroid
                        ? Icons.arrow_back
                        : Icons.arrow_back_ios,
                  )
                ],
              ),
            );
          }),
      isDismissible: true,
      isScrollControlled: true,
    );
  } //////////////////////// end

  void orderButtonSheet({
    required RoomModel roomModel,
    required double height,
    required UserModel userModelLogin,
  }) {
    appController.displayPin.value = false;
    print('uid of room ---> ${roomModel.uidCreate}');
    print('uid of login ---> ${appController.mainUid}');
    print('displayPin ---> ${appController.displayPin}');
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(color: Colors.white),
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ((roomModel.uidCreate.toString()) ==
                    (appController.mainUid.toString()))
                ? const SizedBox()
                : Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: WidgetText(
                      text: 'กรุณาเลือก',
                      textStyle: AppConstant().h2Style(color: Colors.black),
                    ),
                  ),
            WidgetListViewHorizontal(
              roomModel: roomModel,
              height: height - 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 16,
                ),
                ((roomModel.uidCreate.toString()) ==
                        (appController.mainUid.toString()))
                    ? const SizedBox()
                    : WidgetButton(
                        label: 'เลือก',
                        pressFunc: () async {
                          int? indexChoose;
                          int i = 0;
                          for (var element in appController.tabChooses) {
                            if (element) {
                              indexChoose = i;
                            }
                            i++;
                          }

                          print('##4april indexChoose =-----> $indexChoose');

                          if (indexChoose == null) {
                            AppSnackBar().normalSnackBar(
                                title: 'ยังไม่ได้เลือกสินค้่า',
                                message: 'กรุณาเลือกสินค่า',
                                bgColor: Colors.red,
                                textColor: Colors.white);
                          } else {
                            print(
                                '##13mar นี่คือภาพที่เลือก url ---> ${roomModel.urlRooms[indexChoose]}');

                            String uidFriend = roomModel.uidCreate;
                            // String contentSend =
                            //     'ต้องการซื้อ ${roomModel.room} จำนวน ${appController.amountSalse} ช้ิน ราคา ${roomModel.singlePrice} thb';
                            String contentSend = '...';

                            ChatModel chatModel = await AppService()
                                .createChatModel(
                                    urlRealPost:
                                        roomModel.urlRooms[indexChoose]);

                            Map<String, dynamic> map = chatModel.toMap();
                            map['message'] = contentSend;
                            chatModel = ChatModel.fromMap(map);

                            print(
                                '##17mar  chatModel ---> ${chatModel.toMap()}');

                            var user = FirebaseAuth.instance.currentUser;

                            appController
                                .processFindDocIdPrivateChat(
                                    uidLogin: user!.uid, uidFriend: uidFriend)
                                .then((value) async {
                              print(
                                  '##17mar docIdPrivateChat ----> ${appController.docIdPrivateChats.last}');

                              UserModel? userModelFriend = await AppService()
                                  .findUserModel(uid: uidFriend);

                              print(
                                  '##4april userModelLogin ---> ${userModelLogin.toMap()}');

                              AppService().processSentNoti(
                                  title: 'มีข้อความ',
                                  body:
                                      'จากตระกร้า %23${userModelLogin.phoneNumber}',
                                  token: userModelFriend!.token!);

                              AppService()
                                  .processInsertPrivateChat(
                                      docIdPrivateChat:
                                          appController.docIdPrivateChats.last,
                                      chatModel: chatModel)
                                  .then((value) {
                                Get.back();
                                Get.to(PrivateChat(
                                  uidFriend: uidFriend,
                                ));
                              });
                            }).catchError((onError) {
                              appController
                                  .processFindDocIdPrivateChat(
                                      uidLogin: user.uid, uidFriend: uidFriend)
                                  .then((value) {
                                AppService()
                                    .processInsertPrivateChat(
                                        docIdPrivateChat: appController
                                            .docIdPrivateChats.last,
                                        chatModel: chatModel)
                                    .then((value) {
                                  Get.to(PrivateChat(
                                    uidFriend: uidFriend,
                                  ));
                                });
                              });
                            });
                          }
                        },
                        bgColor: Colors.red.shade700,
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void salseBottomSheet({
    required RoomModel roomModel,
    required bool single,
    required BoxConstraints boxConstraints,
    required String docIdRoom,
    required BuildContext context,
  }) {
    AppController appController = Get.put(AppController());
    print('##25jan amountSalse --> ${appController.amountSalse}');
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(),
        ),
        height: 170,
        child: ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Picture
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: WidgetImageInternet(
                    urlImage: roomModel.urlRooms.last,
                    width: 100,
                    height: 100,
                    boxFit: BoxFit.cover,
                  ),
                ),
                //Content Right
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WidgetText(
                        text: AppService()
                            .cutWord(string: roomModel.room, word: 25),
                        textStyle: AppConstant().h2Style(color: Colors.black),
                      ),
                      SizedBox(
                        width: boxConstraints.maxWidth - 120,
                        child: WidgetText(
                          text: AppService()
                              .cutWord(string: roomModel.detail!, word: 25),
                          textStyle: AppConstant().h3Style(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WidgetText(
                    text: single
                        ? '฿${roomModel.singlePrice!}'
                        : '฿${roomModel.totalPrice!}',
                    textStyle:
                        AppConstant().h2Style(color: Colors.red.shade700),
                  ),
                  const WidgetChooseAmountSalse(),
                  single
                      ? WidgetButton(
                          label: 'Pin',
                          pressFunc: () async {
                            Get.back();

                            if (!(appController.haveUserLoginInComment.value)) {
                              AppBottomSheet().processAddNewCommentSalse(
                                  appController.roomModels[appController
                                      .indexBodyMainPageView.value],
                                  appController,
                                  appController.docIdRooms[appController
                                      .indexBodyMainPageView.value],
                                  true,
                                  context);
                            }

                            String uidFriend = roomModel.uidCreate;
                            String contentSend =
                                'ต้องการซื้อ ${roomModel.room} จำนวน ${appController.amountSalse} ช้ิน ราคา ${roomModel.singlePrice} thb';
                            Get.to(PrivateChat(
                              uidFriend: uidFriend,
                            ));

                            ChatModel chatModel = await AppService()
                                .createChatModel(
                                    urlRealPost: roomModel.urlRooms[0]);

                            Map<String, dynamic> map = chatModel.toMap();
                            map['message'] = contentSend;
                            chatModel = ChatModel.fromMap(map);

                            print(
                                '##12mar  chatModel ---> ${chatModel.toMap()}');

                            var user = FirebaseAuth.instance.currentUser;

                            appController
                                .processFindDocIdPrivateChat(
                                    uidLogin: user!.uid, uidFriend: uidFriend)
                                .then((value) {
                              print(
                                  '##12mar docIdPrivateChat ----> ${appController.docIdPrivateChats.last}');

                              AppService().processInsertPrivateChat(
                                  docIdPrivateChat:
                                      appController.docIdPrivateChats.last,
                                  chatModel: chatModel);
                            });
                          },
                          bgColor: Colors.red.shade700,
                        )
                      : WidgetButton(
                          label: 'สร้างกลุ่ม',
                          pressFunc: () {
                            processAddNewCommentSalse(roomModel, appController,
                                docIdRoom, single, context);
                          },
                          bgColor: Colors.red.shade700,
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void processAddNewCommentSalse(
      RoomModel roomModel,
      AppController appController,
      String docIdRoom,
      bool single,
      BuildContext context) {
    double? priceDou;

    if (single) {
      priceDou = double.parse(roomModel.singlePrice!);
    } else {
      priceDou = double.parse(roomModel.totalPrice!);
    }

    double amountDou = double.parse(appController.amountSalse.value.toString());

    double totalPriceDou = priceDou * amountDou;

    var user = FirebaseAuth.instance.currentUser;

    CommentSalseModel commentSalseModel = CommentSalseModel(
        amountSalse: appController.amountSalse.value.toString(),
        name: appController.userModels.last.displayName!,
        timeComment: Timestamp.fromDate(DateTime.now()),
        totalPrice: totalPriceDou.toString(),
        uid: user!.uid,
        urlAvatar: appController.userModels.last.urlAvatar!,
        single: single);

    AppService()
        .processInsertCommentSalse(
            commentSalseModel: commentSalseModel,
            docIdRoom: docIdRoom,
            context: context)
        .then((value) {
      appController.amountSalse.value = 1;
      // Get.back();
    });
  }

  void productBottomSheet({required BoxConstraints boxConstraints}) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        height: boxConstraints.maxHeight * 0.8,
        width: boxConstraints.maxWidth,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              child: SizedBox(
                width: boxConstraints.maxWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(const AddProduct());
                      },
                      child: const WidgetImage(
                        path: 'images/addgreen.png',
                        size: 36,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
