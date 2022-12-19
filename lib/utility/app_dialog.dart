// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realpost/models/chat_model.dart';
import 'package:realpost/states/emoji_page.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_button.dart';
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

  void normalDialog(
      {required String title,
      required Widget leadingWidget,
      Widget? contentWidget,
      List<Widget>? actions}) {
    Get.dialog(AlertDialog(
      title: WidgetMenu(
        leadingWiget: leadingWidget,
        titleWidget: WidgetText(
          text: title,
          textStyle: AppConstant().h2Style(color: AppConstant.bgColor),
        ),
      ),
      content: contentWidget,
      actions: actions,
    ));
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
                      disPlayName: appController.userModels[0].displayName,
                      urlAvatar: appController.userModels[0].urlAvatar!.isEmpty
                          ? appController.urlAvatarChooses[0]
                          : appController.userModels[0].urlAvatar!,
                      article: appController.articleControllers[0].text,
                      link: '',
                      geoPoint: GeoPoint(appController.positions[0].latitude,
                          appController.positions[0].longitude),
                    );
                    AppService()
                        .processInsertChat(
                            chatModel: chatModel,
                            docId: collection != null
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

  void realPostBottonSheet({String? collection}) {
    Get.bottomSheet(
        GetX(
            init: AppController(),
            builder: (AppController appController) {
              print(
                  '##9dec at realPostBottonSheet urlRealPostChoose ==> ${appController.urlRealPostChooses}');
              return Container(
                decoration: BoxDecoration(color: AppConstant.bgColor),
                height: 300,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    WidgetText(
                      text: 'Real Post Stamp',
                      textStyle: AppConstant().h2Style(),
                    ),
                    appController.urlRealPostChooses.isNotEmpty
                        ? WidgetImageInternet(
                            urlImage: appController.urlRealPostChooses[0],
                            width: 200,
                            height: 200,
                          )
                        : appController.fileRealPosts.isEmpty
                            ? const WidgetImage(
                                path: 'images/funny1.png',
                                size: 200,
                              )
                            : Image.file(
                                appController.fileRealPosts[0],
                                width: 200,
                                height: 200,
                              ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // appController.urlRealPostChooses.isEmpty
                        //     ? const SizedBox()
                        //     : Row(
                        //         mainAxisSize: MainAxisSize.min,
                        //         children: [
                        //           WidgetIconButton(
                        //             iconData: Icons.border_color,
                        //             pressFunc: () {
                        //               Get.back();
                        //               normalDialog(
                        //                 title: 'บทความ :',
                        //                 leadingWidget:
                        //                     const Icon(Icons.border_color),
                        //                 contentWidget: WidgetForm(
                        //                   controller: appController
                        //                       .articleControllers[0],
                        //                 ),
                        //                 actions: <Widget>[
                        //                   WidgetTextButton(
                        //                     text: 'Ok',
                        //                     pressFunc: () {
                        //                       print(
                        //                           '##9dec สิ่งที่กรอก --> ${appController.articleControllers[0].text}');
                        //                       Get.back();
                        //                       realPostBottonSheet();
                        //                     },
                        //                   ),
                        //                   WidgetTextButton(
                        //                     text: 'Cancel',
                        //                     pressFunc: () {
                        //                       Get.back();
                        //                       realPostBottonSheet();
                        //                     },
                        //                   )
                        //                 ],
                        //               );
                        //             },
                        //           ),
                        //           WidgetIconButton(
                        //             iconData: Icons.share,
                        //             pressFunc: () {
                        //               normalDialog(
                        //                 title: 'Link',
                        //                 leadingWidget: const Icon(Icons.share),
                        //               );
                        //             },
                        //           ),
                        //         ],
                        //       ),
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
                              // if (appController.fileRealPosts.isNotEmpty) {
                              //   appController.fileRealPosts.clear();
                              // }
                              appController.fileRealPosts.add(result);
                            }
                          },
                        ),
                        // WidgetIconButton(
                        //   iconData: Icons.add_photo_alternate,
                        //   pressFunc: () async {
                        //     if (appController.fileRealPosts.isNotEmpty) {
                        //       appController.fileRealPosts.clear();
                        //     }

                        //     if (appController.urlRealPostChooses.isNotEmpty) {
                        //       appController.urlRealPostChooses.clear();
                        //     }

                        //     var result = await AppService()
                        //         .processTakePhoto(source: ImageSource.gallery);
                        //     if (result != null) {
                        //       if (appController.fileRealPosts.isNotEmpty) {
                        //         appController.fileRealPosts.clear();
                        //       }
                        //       appController.fileRealPosts.add(result);
                        //     }
                        //   },
                        // ),
                        WidgetIconButton(
                          iconData: Icons.emoji_emotions,
                          pressFunc: () {
                            Get.to(const EmojiPage(
                              avatarBol: false,
                            ))!
                                .then((value) {});
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
                        ((appController.fileRealPosts.isNotEmpty) ||
                                (appController.urlRealPostChooses.isNotEmpty) ||
                                appController
                                    .userModels[0].urlAvatar!.isNotEmpty)
                            ? WidgetIconButton(
                                iconData: Icons.send,
                                pressFunc: () async {
                                  //About Avatar
                                  if (appController.fileAvatars.isNotEmpty) {
                                    //Have file Avatar
                                    await AppService()
                                        .processUploadPhoto(
                                            file: appController.fileAvatars[0],
                                            path: 'avatar')
                                        .then((value) {
                                      print('value upload avatar ==> $value');

                                      appController.urlAvatarChooses.clear();
                                      appController.urlAvatarChooses
                                          .add(value.toString());
                                      AppService().editUrlAvatar();
                                    });
                                  } else {
                                    if (appController
                                        .urlAvatarChooses.isNotEmpty) {
                                      AppService().editUrlAvatar();
                                    }
                                  }

                                  //About RealPost
                                  if (appController.fileRealPosts.isNotEmpty) {
                                    print(
                                        '##19dec แบบถ่ายภาพ  ${appController.fileRealPosts.length}');

                                    //upload
                                    await AppService()
                                        .processUploadPhoto(
                                            file:
                                                appController.fileRealPosts[0],
                                            path: 'realpost')
                                        .then((value) {
                                      print(
                                          '##19dec url ของภาพที่ อัพโหลดไป ---> $value');

                                      if (appController
                                          .urlRealPostChooses.isNotEmpty) {
                                        appController.urlRealPostChooses
                                            .clear();
                                      }
                                      appController.urlRealPostChooses
                                          .add(value.toString());

                                      print(
                                          '##19dec urlRealPostChoose[0] ----> ${appController.urlRealPostChooses[0]}');

                                     ChatModel chatModel = ChatModel(
                                      message:
                                          appController.messageChats.isEmpty
                                              ? ''
                                              : appController.messageChats[0],
                                      timestamp:
                                          Timestamp.fromDate(DateTime.now()),
                                      uidChat: FirebaseAuth
                                          .instance.currentUser!.uid,
                                      urlRealPost: appController
                                              .urlRealPostChooses.isEmpty
                                          ? ''
                                          : appController.urlRealPostChooses[0],
                                      disPlayName: appController
                                          .userModels[0].displayName,
                                      urlAvatar: appController
                                              .userModels[0].urlAvatar!.isEmpty
                                          ? appController.urlAvatarChooses[0]
                                          : appController
                                              .userModels[0].urlAvatar!,
                                      article: appController
                                          .articleControllers[0].text,
                                      link: '',
                                    );

                                      print(
                                          'chatModel ---> ${chatModel.toMap()}');

                                      AppService()
                                          .processInsertChat(
                                        chatModel: chatModel,
                                        docId:
                                            appController.docIdRoomChooses[0],
                                        collection: collection,
                                      )
                                          .then((value) {
                                        Get.back();
                                      });
                                    });
                                  } else {
                                    print('##19dec ไม่ได้ถ่ายภาพ');

                                    ChatModel chatModel = ChatModel(
                                      message:
                                          appController.messageChats.isEmpty
                                              ? ''
                                              : appController.messageChats[0],
                                      timestamp:
                                          Timestamp.fromDate(DateTime.now()),
                                      uidChat: FirebaseAuth
                                          .instance.currentUser!.uid,
                                      urlRealPost: appController
                                              .urlRealPostChooses.isEmpty
                                          ? ''
                                          : appController.urlRealPostChooses[0],
                                      disPlayName: appController
                                          .userModels[0].displayName,
                                      urlAvatar: appController
                                              .userModels[0].urlAvatar!.isEmpty
                                          ? appController.urlAvatarChooses[0]
                                          : appController
                                              .userModels[0].urlAvatar!,
                                      article: appController
                                          .articleControllers[0].text,
                                      link: '',
                                    );
                                    AppService()
                                        .processInsertChat(
                                      chatModel: chatModel,
                                      docId: collection != null
                                          ? appController.docIdPrivateChats[0]
                                          : appController.docIdRoomChooses[0],
                                      collection: collection,
                                    )
                                        .then((value) {
                                      Get.back();
                                    });
                                  }
                                },
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ],
                ),
              );
            }),
        isDismissible: true);
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
