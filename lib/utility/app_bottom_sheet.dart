// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realpost/models/chat_model.dart';
import 'package:realpost/models/comment_salse_model.dart';
import 'package:realpost/models/room_model.dart';
import 'package:realpost/states/add_product.dart';
import 'package:realpost/states/private_chat.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/utility/app_snackbar.dart';
import 'package:realpost/widgets/widget_button.dart';
import 'package:realpost/widgets/widget_choose_amout_salse.dart';
import 'package:realpost/widgets/widget_image.dart';
import 'package:realpost/widgets/widget_image_internet.dart';
import 'package:realpost/widgets/widget_listview_hoizontal.dart';
import 'package:realpost/widgets/widget_text.dart';

class AppBottomSheet {
  AppController appController = Get.put(AppController());

  void orderButtonSheet({
    required RoomModel roomModel,
  }) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(color: Colors.white),
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WidgetText(
              text: 'กรุณาเลือก',
              textStyle: AppConstant().h2Style(color: Colors.black),
            ),
            WidgetListViewHorizontal(roomModel: roomModel),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // const WidgetChooseAmountSalse(),
                WidgetButton(
                  label: 'Pin',
                  pressFunc: () async {
                    int? indexChoose;
                    int i = 0;
                    for (var element in appController.tabChooses) {
                      if (element) {
                        indexChoose = i;
                      }
                      i++;
                    }

                    print('##13mar indexChoose =-----> $indexChoose');
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

                      ChatModel chatModel = await AppService().createChatModel(
                          urlRealPost: roomModel.urlRooms[indexChoose]);

                      Map<String, dynamic> map = chatModel.toMap();
                      map['message'] = contentSend;
                      chatModel = ChatModel.fromMap(map);

                      print('##17mar  chatModel ---> ${chatModel.toMap()}');

                      var user = FirebaseAuth.instance.currentUser;

                      appController
                          .processFindDocIdPrivateChat(
                              uidLogin: user!.uid, uidFriend: uidFriend)
                          .then((value) {
                        print(
                            '##17mar docIdPrivateChat ----> ${appController.docIdPrivateChats.last}');

                        AppService()
                            .processInsertPrivateChat(
                                docIdPrivateChat:
                                    appController.docIdPrivateChats.last,
                                chatModel: chatModel)
                            .then((value) {
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
                                docIdPrivateChat:
                                    appController.docIdPrivateChats.last,
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
                )
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
                      child: WidgetImage(
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
