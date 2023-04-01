// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realpost/models/chat_model.dart';
import 'package:realpost/models/comment_salse_model.dart';
import 'package:realpost/models/room_model.dart';
import 'package:realpost/models/salse_group_model.dart';
import 'package:realpost/models/user_model.dart';
import 'package:realpost/states/emoji_page.dart';
import 'package:realpost/utility/app_bottom_sheet.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_button.dart';
import 'package:realpost/widgets/widget_choose_amout_salse.dart';
import 'package:realpost/widgets/widget_circular_image.dart';
import 'package:realpost/widgets/widget_form.dart';
import 'package:realpost/widgets/widget_google_map.dart';
import 'package:realpost/widgets/widget_icon_button.dart';
import 'package:realpost/widgets/widget_image.dart';
import 'package:realpost/widgets/widget_image_internet.dart';
import 'package:realpost/widgets/widget_menu.dart';
import 'package:realpost/widgets/widget_text.dart';
import 'package:realpost/widgets/widget_text_button.dart';

class AppDialog {
  final BuildContext context;
  AppDialog({
    required this.context,
  });

  void dialogCommentSalse({
    required List<CommentSalseModel> commentSalseModels,
    required RoomModel roomModel,
    required double maxWidth,
    required String docIdRoom,
  }) {
    print(
        '##6mar ขนาดของ commentSalseModels ---> ${commentSalseModels.length}');
    Get.dialog(
      AlertDialog(
        title: Column(
          children: [
            WidgetText(
              text: 'ผู้เข้าร่วมทั้งหมด',
              textStyle: AppConstant().h2Style(color: Colors.black),
            ),
            const Divider(
              color: Colors.black,
            )
          ],
        ),
        content: ListView.builder(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: commentSalseModels.length,
          itemBuilder: (context, index) => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      WidgetCircularImage(
                          urlImage: commentSalseModels[index].urlAvatar),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WidgetText(
                            text: commentSalseModels[index].name,
                            textStyle:
                                AppConstant().h3Style(color: Colors.black),
                          ),
                          WidgetText(
                            text: AppService().timeStampToString(
                                timestamp:
                                    commentSalseModels[index].timeComment,
                                newPattern: 'dd/MM HH:mm'),
                            textStyle:
                                AppConstant().h3Style(color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                  WidgetButton(
                    label: 'Pin',
                    pressFunc: () {
                      Get.back();

                      AppBottomSheet().salseBottomSheet(
                        roomModel: roomModel,
                        single: true,
                        boxConstraints: BoxConstraints(maxWidth: maxWidth),
                        docIdRoom: docIdRoom,
                        context: context,
                      );
                    },
                    bgColor: Colors.red.shade700,
                  )
                ],
              ),
              const Divider(
                color: Colors.black,
              )
            ],
          ),
        ),
      ),
    );
  }

  void addressDialog() {
    print('##28jan addressDialog Work');
    Get.dialog(AlertDialog(
      title: WidgetText(
        text: 'ที่จัดส่ง',
        textStyle: AppConstant().h2Style(color: Colors.black),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          WidgetForm(
            hint: 'ที่อย่ :',
          ),
          const SizedBox(
            height: 16,
          ),
          WidgetForm(
            hint: 'เบอร์โทรศัพย์ :',
          ),
        ],
      ),
      actions: [
        WidgetTextButton(
          text: 'Save',
          pressFunc: () {
            Get.back();
          },
        )
      ],
    ));
  }

  void salseDialog({
    required RoomModel roomModel,
    required String docIdCommentSalse,
    required List<SalseGroupModel> salseGroupModels,
    required UserModel userModel,
    required uidLogin,
    required String docIdRoom,
  }) {
    Get.dialog(
      AlertDialog(
        title: WidgetText(
          text: 'คุณต้องการเข้าร่วมซื้อสินค้า',
          textStyle: AppConstant().h2Style(color: Colors.black),
        ),
        content: Container(
          // height: 250,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              WidgetText(
                text: roomModel.room,
                textStyle: AppConstant().h3Style(color: Colors.black),
              ),
              WidgetChooseAmountSalse(),
            ],
          ),
        ),
        actions: [
          WidgetButton(
            label: 'Buy',
            pressFunc: () async {
              print('##28jan docIdCommentSalse ---> $docIdCommentSalse');
              Map<String, dynamic> map = userModel.toMap();
              map['uid'] = uidLogin;
              SalseGroupModel salseGroupModel = SalseGroupModel(
                  map: map, timestamp: Timestamp.fromDate(DateTime.now()));

              print('##28jan map ---> $map');
              print('##28jan docIdRoom ===> $docIdRoom');

              await FirebaseFirestore.instance
                  .collection('room')
                  .doc(docIdRoom)
                  .collection('commentsalse')
                  .doc(docIdCommentSalse)
                  .collection('salsegroup')
                  .doc()
                  .set(salseGroupModel.toMap())
                  .then((value) {
                Get.back();
                AppController appController = Get.put(AppController());
                appController.readSalseGroups;

                var salseGroupModels = <SalseGroupModel>[];
                for (var element in appController.salsegroups) {
                  salseGroupModels.add(element);
                }

                commentDialog(
                  roomModel: roomModel,
                  docIdCommentSalse: docIdCommentSalse,
                  salseGroupModels: salseGroupModels,
                );
              });
            },
            bgColor: Colors.red.shade700,
          )
        ],
      ),
    );
  }

  void commentDialog(
      {required RoomModel roomModel,
      required String docIdCommentSalse,
      required List<SalseGroupModel> salseGroupModels}) {
    int amountGroupInt = int.parse(roomModel.amountGroup ?? '0');
    amountGroupInt = amountGroupInt - salseGroupModels.length;

    Get.dialog(
      AlertDialog(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            WidgetText(
              text: roomModel.room,
              textStyle: AppConstant().h2Style(color: Colors.black),
            ),
            const SizedBox(
              width: 16,
            ),
            WidgetText(
              text: 'ขาด $amountGroupInt คน',
              textStyle: AppConstant().h3Style(
                  color: Colors.grey, size: 16, fontWeight: FontWeight.w500),
            )
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: salseGroupModels.length,
            itemBuilder: (context, index) => Row(
              children: [
                WidgetCircularImage(
                    urlImage: salseGroupModels[index].map['urlAvatar']),
                WidgetText(
                  text: salseGroupModels[index].map['displayName'],
                  textStyle: AppConstant().h3Style(color: Colors.black),
                ),
                const Spacer(),
                WidgetButton(
                  label: 'เข้าร่วม',
                  pressFunc: () {},
                  bgColor: Colors.red,
                  labelStyle: AppConstant().h3Style(),
                  circular: 2,
                )
              ],
            ),
          ),
        ),
        // actions: [
        //   Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       WidgetButton(
        //         label: 'Comment',
        //         pressFunc: () {},
        //         bgColor: Colors.red.shade700,
        //       ),
        //     ],
        //   )
        // ],
      ),
    );
  }

  void normalDialog(
      {required String title,
      required Widget leadingWidget,
      Widget? contentWidget,
      List<Widget>? actions}) {
    Get.dialog(
      AlertDialog(
        title: WidgetMenu(
          leadingWiget: leadingWidget,
          titleWidget: WidgetText(
            text: title,
            textStyle: AppConstant().h2Style(color: AppConstant.bgColor),
          ),
        ),
        content: contentWidget,
        actions: actions,
      ),
      barrierDismissible: false,
    );
  }

  void bigImageBottomSheet({
    required String urlImage,
  }) {
    Get.bottomSheet(
      Container(
        height: 280,
        decoration: BoxDecoration(color: AppConstant.bgColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: WidgetImageInternet(
                urlImage: urlImage,
                height: 150,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 250,
                  child: WidgetForm(
                    textStyle: AppConstant().h3Style(),
                  ),
                ),
                WidgetIconButton(
                  iconData: Icons.send,
                  pressFunc: () {},
                )
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void mapBottomSheet({String? collection}) {
    Get.bottomSheet(GetX(
        init: AppController(),
        builder: (AppController appController) {
          return Container(
            decoration: BoxDecoration(color: AppConstant.bgColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 280,
                  child: Stack(
                    children: [
                      WidgetGoogleMap(
                        lat: appController.positions[0].latitude,
                        lng: appController.positions[0].longitude,
                      ),
                    ],
                  ),
                ),
                WidgetButton(
                  bgColor: AppConstant.spColor,
                  width: 250,
                  label: 'ส่งตำแหน่ง',
                  pressFunc: () {
                    ChatModel chatModel = ChatModel(
                      message: appController.messageChats.isEmpty
                          ? ''
                          : appController.messageChats[0],
                      timestamp: Timestamp.fromDate(DateTime.now()),
                      uidChat: FirebaseAuth.instance.currentUser!.uid,
                      urlRealPost: appController.urlRealPostChooses.isEmpty
                          ? ''
                          : appController.urlRealPostChooses[0],
                      disPlayName: appController.userModels[0].displayName!,
                      urlAvatar: appController.userModels[0].urlAvatar!.isEmpty
                          ? appController.urlAvatarChooses[0]
                          : appController.userModels[0].urlAvatar!,
                      article: appController.articleControllers[0].text,
                      link: '',
                      geoPoint: GeoPoint(appController.positions[0].latitude,
                          appController.positions[0].longitude),
                      albums: [],
                    );
                    AppService()
                        .processInsertChat(
                            chatModel: chatModel,
                            docIdRoom: collection != null
                                ? appController.docIdPrivateChats[0]
                                : appController.docIdRoomChooses[0],
                            collection: collection)
                        .then((value) {
                      Get.back();
                    });
                  },
                ),
              ],
            ),
          );
        }));
  }

  void avatarBottonSheet() {
    Get.bottomSheet(
      GetX(
          init: AppController(),
          builder: (AppController appController) {
            print(
                'at avatarBottonSheet urlAvatarChoose ==> ${appController.urlAvatarChooses}');
            return Container(
              decoration: BoxDecoration(color: AppConstant.bgColor),
              height: 300,
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  WidgetText(
                    text: 'กรุณาเลือก Real Post Avatar',
                    textStyle: AppConstant().h2Style(),
                  ),
                  appController.urlAvatarChooses.isNotEmpty
                      ? WidgetImageInternet(
                          urlImage: appController.urlAvatarChooses[0],
                          width: 200,
                          height: 200,
                        )
                      : appController.fileAvatars.isEmpty
                          ? const WidgetImage(
                              path: 'images/avatar.png',
                              size: 200,
                            )
                          : Image.file(
                              appController.fileAvatars[0],
                              width: 200,
                              height: 200,
                            ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WidgetIconButton(
                        iconData: Icons.add_a_photo,
                        pressFunc: () async {
                          if (appController.fileAvatars.isNotEmpty) {
                            appController.fileAvatars.clear();
                          }

                          if (appController.urlAvatarChooses.isNotEmpty) {
                            appController.urlAvatarChooses.clear();
                          }

                          var result = await AppService()
                              .processTakePhoto(source: ImageSource.camera);
                          if (result != null) {
                            if (appController.fileAvatars.isNotEmpty) {
                              appController.fileAvatars.clear();
                            }
                            appController.fileAvatars.add(result);
                          }
                        },
                      ),
                      WidgetIconButton(
                        iconData: Icons.add_photo_alternate,
                        pressFunc: () async {
                          if (appController.fileAvatars.isNotEmpty) {
                            appController.fileAvatars.clear();
                          }

                          if (appController.urlAvatarChooses.isNotEmpty) {
                            appController.urlAvatarChooses.clear();
                          }

                          var result = await AppService()
                              .processTakePhoto(source: ImageSource.gallery);
                          if (result != null) {
                            if (appController.fileAvatars.isNotEmpty) {
                              appController.fileAvatars.clear();
                            }
                            appController.fileAvatars.add(result);
                          }
                        },
                      ),
                      WidgetIconButton(
                        iconData: Icons.emoji_emotions,
                        pressFunc: () {
                          Get.to(const EmojiPage(
                            avatarBol: true,
                          ))!
                              .then((value) {});
                        },
                      ),
                      ((appController.fileAvatars.isNotEmpty) ||
                              (appController.urlAvatarChooses.isNotEmpty))
                          ? WidgetIconButton(
                              iconData: Icons.send,
                              pressFunc: () {
                                Get.back();
                                realPostBottonSheet();
                              },
                            )
                          : const SizedBox(),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }

  void realPostBottonSheet({String? collection, String? docIdRoom}) {
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
            print(
                '##22mar at realPostBottonSheet urlRealPostChoose ==> ${appController.urlRealPostChooses.length}');
            print(
                '##22mar @realPostBoottonSheet fileRealPosts --> ${appController.fileRealPosts.length}');
            return Container(
              decoration: BoxDecoration(color: AppConstant.bgColor),
              height: 306,
              child: Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      WidgetText(
                        text: 'Real Post Picture',
                        textStyle: AppConstant().h2Style(),
                      ),
                      appController.urlRealPostChooses.isNotEmpty
                          ? WidgetImageInternet(
                              urlImage: appController.urlRealPostChooses[0],
                              width: 200,
                              height: 200,
                            )
                          : appController.fileRealPosts.isEmpty
                              ? const SizedBox(height: 200)
                              : Image.file(
                                  appController.fileRealPosts[0],
                                  width: 200,
                                  height: 200,
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
                            iconData: Icons.add_photo_alternate,
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
                          ),
                          WidgetIconButton(
                            iconData: Icons.pin_drop,
                            pressFunc: () {
                              print(
                                  'You tap pin ===> ${appController.positions[0]}');
                              Get.back();
                              mapBottomSheet(collection: collection);
                            },
                          ),
                          // const Spacer(),
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
                              if (appController.fileRealPosts.isNotEmpty) {
                                print(
                                    '##20mar แบบถ่ายภาพ  ${appController.fileRealPosts.length}');

                                //upload
                                await AppService()
                                    .processUploadPhoto(
                                        file: appController.fileRealPosts.last,
                                        path: 'realpost')
                                    .then((value) async {
                                  print(
                                      '##20mar url ของภาพที่ อัพโหลดไป ---> $value');

                                  if (appController
                                      .urlRealPostChooses.isNotEmpty) {
                                    appController.urlRealPostChooses.clear();
                                  }

                                  appController.urlRealPostChooses
                                      .add(value.toString());

                                  print(
                                      '##20mar urlRealPostChoose[0] ----> ${appController.urlRealPostChooses.last}');

                                  ChatModel chatModel = await AppService()
                                      .createChatModel(
                                          urlRealPost: appController
                                              .urlRealPostChooses.last);

                                  print(
                                      '##20mar chatModel ---> ${chatModel.toMap()}');

                                  print(
                                      '##8jan docIdRoomChoose ---> ${appController.docIdRoomChooses.length}');

                                  AppService()
                                      .processInsertChat(
                                    chatModel: chatModel,
                                    docIdRoom: collection != null
                                        ? appController.docIdPrivateChats[0]
                                        : appController.docIdRoomChooses[0],
                                    collection: collection,
                                     collectionChat: 'chatOwner'
                                   
                                  )
                                      .then((value) async {
                                    Get.back();
                                  });
                                });
                              } else {
                                print('##19dec ไม่ได้ถ่ายภาพ');

                                if (appController.messageChats.isEmpty) {
                                  Get.back();
                                } else {
                                   ChatModel chatModel =
                                    await AppService().createChatModel();
                                AppService()
                                    .processInsertChat(
                                  chatModel: chatModel,
                                  docIdRoom: docIdRoom ?? '',
                                  collection: collection,
                                   collectionChat: 'chatOwner'
                                )
                                    .then((value) {
                                  Get.back();
                                });
                                }
                              }
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
  }

  void myBottonSheet({required Function() tapFunc}) {
    AppController appController = Get.put(AppController());

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(color: AppConstant.bgColor),
        height: 200,
        child: GridView.builder(
          findChildIndexCallback: (key) {
            print('key ==> $key');
          },
          itemCount: appController.stampModels.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              print('you tab index == $index');
              appController.emojiAddRoomChooses.clear();
              appController.emojiAddRoomChooses
                  .add(appController.stampModels[index].url);
              Get.back();
            },
            child: WidgetImageInternet(
                urlImage: appController.stampModels[index].url),
          ),
        ),
      ),
    );
  }
}
