// ignore_for_file: avoid_print

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realpost/models/room_model.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_dialog.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_form.dart';
import 'package:realpost/widgets/widget_icon_button.dart';
import 'package:realpost/widgets/widget_image_internet.dart';
import 'package:realpost/widgets/widget_take_photo.dart';
import 'package:realpost/widgets/widget_text.dart';

class AddRoom extends StatefulWidget {
  const AddRoom({super.key});

  @override
  State<AddRoom> createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  String? room;
  File? file;
  String? urlPhoto;

  AppController controller = Get.put(AppController());

  @override
  void initState() {
    super.initState();
    controller.readAllStamp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      appBar: AppBar(
        title:
            const WidgetText(text: 'ยินดีต้อนรับ สู่การสร้าง Real Post Room'),
      ),
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return GetX(
            init: AppController(),
            builder: (AppController appController) {
              print(
                  'emojiAddRoomChoose ==> ${appController.emojiAddRoomChooses}');
              return Center(
                child: Column(
                  children: [
                    const Divider(
                      color: Colors.grey,
                    ),
                    WidgetForm(
                      changeFunc: (p0) {
                        room = p0.trim();
                      },
                      hint: 'กรอก ชื่อที่ คุณต้องการ',
                      hintStyle: AppConstant().h3Style(
                        color: AppConstant.grey,
                        size: 24,
                      ),
                      width: 250,
                      textStyle: AppConstant().h3Style(size: 24),
                    ),
                    appController.emojiAddRoomChooses.isEmpty
                        ? file == null
                            ? const SizedBox()
                            : SizedBox(
                                width: boxConstraints.maxWidth * 0.75,
                                height: boxConstraints.maxWidth * 0.75,
                                child: Image.file(file!),
                              )
                        : WidgetImageInternet(
                            urlImage: appController.emojiAddRoomChooses[0],
                            width: boxConstraints.maxWidth * 0.75,
                            height: boxConstraints.maxWidth * 0.75,
                          ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border(top: BorderSide(color: AppConstant.grey))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          WidgetTakePhoto(
                            size: boxConstraints.maxWidth * 0.6,
                            cameraFunc: () async {
                              await AppService()
                                  .processTakePhoto(source: ImageSource.camera)
                                  .then((value) {
                                appController.emojiAddRoomChooses.clear();
                                file = value;
                                setState(() {});
                              });
                            },
                            galleryFunc: () async {
                              await AppService()
                                  .processTakePhoto(source: ImageSource.gallery)
                                  .then((value) {
                                appController.emojiAddRoomChooses.clear();
                                file = value;
                                setState(() {});
                              });
                            },
                            emojiFunc: () {
                              AppDialog(context: context).myBottonSheet(
                                  tapFunc: () {
                                print('you tab');
                              });
                            },
                          ),
                          WidgetIconButton(
                            iconData: Icons.send,
                            pressFunc: () async {
                              if (room?.isEmpty ?? true) {
                                //Have Space
                              } else {
                                var user = FirebaseAuth.instance.currentUser;
                                RoomModel roomModel = RoomModel(
                                    uidCreate: user!.uid, room: room!);
                                await AppService()
                                    .processInsertRoom(roomModel: roomModel)
                                    .then((value) => Get.back());
                              }
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            });
      }),
    );
  }
}
