// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realpost/models/room_model.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_icon_button.dart';
import 'package:realpost/widgets/widget_image.dart';
import 'package:realpost/widgets/widget_text.dart';

class TakePhotoOnly extends StatelessWidget {
  const TakePhotoOnly({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      appBar: AppBar(
        title: WidgetText(
          text: 'เลือกรูปของคุณ',
          textStyle: AppConstant().h2Style(),
        ),
      ),
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return GetX(
            init: AppController(),
            builder: (AppController appController) {
              print('##15feb files ---> ${appController.xFiles.length}');
              return SizedBox(
                width: boxConstraints.maxWidth,
                height: boxConstraints.maxHeight,
                child: Stack(
                  children: [
                    appController.xFiles.isEmpty
                        ? const SizedBox()
                        : SizedBox(
                            width: boxConstraints.maxWidth,
                            height: boxConstraints.maxHeight - 64,
                            child: Image.file(
                              File(appController.xFiles.last.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                    Positioned(
                      bottom: 0,
                      child: SizedBox(
                        width: boxConstraints.maxWidth,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Divider(
                              color: Colors.white,
                            ),
                            Row(
                              children: [
                                WidgetIconButton(
                                  iconData: Icons.add_a_photo,
                                  pressFunc: () {},
                                ),
                                WidgetIconButton(
                                  iconData: Icons.add_photo_alternate,
                                  pressFunc: () {
                                    AppService().processChooseMultiImage();
                                  },
                                ),
                                const Spacer(),
                                appController.xFiles.isEmpty
                                    ? const SizedBox()
                                    : WidgetIconButton(
                                        iconData: Icons.send,
                                        pressFunc: () async {
                                          print(
                                              '##15feb userModels --> ${appController.userModels.last.toMap()}');

                                          await AppService()
                                              .processUploadMultiPhoto(
                                                  path: 'room2')
                                              .then((value) {
                                            var urlImages = value;
                                            print(
                                                '##15feb urlImages --> $urlImages');

                                            if (appController.userModels.last
                                                .urlAvatar!.isEmpty) {
                                              //อัพ Avatar
                                              Map<String, dynamic> map =
                                                  appController.userModels.last
                                                      .toMap();
                                              map['urlAvatar'] = urlImages.last;
                                              AppService()
                                                  .processUpdateUserModel(
                                                      map: map);
                                            }

                                            var user = FirebaseAuth
                                                .instance.currentUser;

                                            RoomModel roomModel = RoomModel(
                                                uidCreate: user!.uid,
                                                room: '',
                                                timestamp: Timestamp.fromDate(
                                                    DateTime.now()),
                                                urlRooms: urlImages);

                                            AppService()
                                                .processInsertRoom(
                                                    roomModel: roomModel)
                                                .then((value) {
                                              AppService().initialSetup(
                                                  context: context);
                                              Get.back();
                                            });
                                          });
                                        },
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
      }),
    );
  }
}
