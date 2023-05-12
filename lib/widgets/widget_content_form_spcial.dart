// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realpost/models/chat_model.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_form.dart';
import 'package:realpost/widgets/widget_icon_button.dart';
import 'package:realpost/widgets/widget_image_internet.dart';
import 'package:realpost/widgets/widget_text.dart';

class WidgetContentFormSpcial extends StatefulWidget {
  const WidgetContentFormSpcial({super.key});

  @override
  State<WidgetContentFormSpcial> createState() =>
      _WidgetContentFormSpcialState();
}

class _WidgetContentFormSpcialState extends State<WidgetContentFormSpcial> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print(appController.mainUid.value);
          return Container(
            decoration: BoxDecoration(color: AppConstant.bgColor),
            constraints: const BoxConstraints(
              maxHeight: 356,
              // minHeight: 150,
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                    const Divider(
                      color: Colors.white,
                      thickness: 1,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        WidgetIconButton(
                          iconData: Icons.add_a_photo,
                          color: AppConstant.realFront,
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

                            var result = await AppService()
                                .processTakePhoto(source: ImageSource.gallery);
                            if (result != null) {
                              appController.fileRealPosts.add(result);
                            }
                          },
                          iconData: Icons.add_photo_alternate,
                          color: AppConstant.realFront,
                        ),
                        Expanded(
                          child: WidgetForm(
                            textStyle:
                                AppConstant().h3Style(color: Colors.white),
                            controller: textEditingController,
                            fillColor: AppConstant.realMid,
                            height: 40,
                            changeFunc: (p0) {
                              appController.messageChats.add(p0.trim());
                            },
                          ),
                        ),
                        WidgetIconButton(
                          iconData: Icons.send,color: AppConstant.realFront,
                          pressFunc: () async {
                            if ((appController.fileRealPosts.isNotEmpty) ||
                                (appController.messageChats.isNotEmpty)) {
                              if (appController.fileRealPosts.isNotEmpty) {
                                //มีการถ่ายภาพ
                                var urlImage = await AppService()
                                    .processUploadPhoto(
                                        file: appController.fileRealPosts.last,
                                        path: 'realpost');
                                // appController.urlRealPostChooses
                                //     .add(urlImage.toString());
                                ChatModel chatModel = await AppService()
                                    .createChatModel(urlRealPost: urlImage);
                                print(
                                    'chatmodel ถ่ายภาพ ---> ${chatModel.toMap()}');
                                await AppService()
                                    .processInsertChat(
                                        chatModel: chatModel,
                                        docIdRoom: appController.docIdRooms[0])
                                    .then((value) {
                                  appController.fileRealPosts.clear();
                                  textEditingController.text = '';
                                });
                              } else {
                                //ไม่มีถ่ายภาพ
                                ChatModel chatModel =
                                    await AppService().createChatModel();
                                print(
                                    'chatmodel ไม่ถ่ายภาพ ---> ${chatModel.toMap()}');
                                await AppService()
                                    .processInsertChat(
                                        chatModel: chatModel,
                                        docIdRoom: appController.docIdRooms[0])
                                    .then((value) {
                                  textEditingController.text = '';
                                });
                              }
                            } else {
                              // ไม่ถ่ายภาพ และ ไม่เขียนข้อความ
                              print('ไม่ถ่ายภาพ และ ไม่เขียนข้อความ');
                            }
                          }, // end Send
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
