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
            constraints: BoxConstraints(
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
                    // SizedBox(
                    //   height: 50,
                    //   child: ListView.builder(
                    //     scrollDirection: Axis.horizontal,
                    //     shrinkWrap: true,
                    //     physics: const ClampingScrollPhysics(),
                    //     itemCount: appController.stampModels.length,
                    //     itemBuilder: (context, index) => WidgetImageInternet(
                    //       urlImage: appController.stampModels[index].url,
                    //       tapFunc: () async {
                    //         appController.urlRealPostChooses
                    //             .add(appController.stampModels[index].url);

                    //         ChatModel chatModel = await AppService()
                    //             .createChatModel(
                    //                 urlRealPost:
                    //                     appController.urlRealPostChooses.last);

                    //         print(
                    //             '##26april  chatModel ---> ${chatModel.toMap()}');
                    //       },
                    //     ),
                    //   ),
                    // ),
                    const Divider(
                      color: Colors.white,
                      thickness: 1,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
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

                            var result = await AppService()
                                .processTakePhoto(source: ImageSource.gallery);
                            if (result != null) {
                              appController.fileRealPosts.add(result);
                            }
                          },
                          iconData: Icons.add_photo_alternate,
                        ),
                        Expanded(
                          child: WidgetForm(
                            controller: textEditingController,
                            fillColor: Colors.grey.shade300,
                            maginBottom: 4,
                            height: 40,
                            changeFunc: (p0) {
                              appController.messageChats.add(p0.trim());
                            },
                          ),
                        ),
                        WidgetIconButton(
                          iconData: Icons.send,
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

                            // //upload
                            // await AppService()
                            //     .processUploadPhoto(
                            //         file: appController.fileRealPosts.last,
                            //         path: 'realpost')
                            //     .then((value) async {
                            //   print(
                            //       '##26april url ของภาพที่ อัพโหลดไป ---> $value');

                            //   if (appController.urlRealPostChooses.isNotEmpty) {
                            //     appController.urlRealPostChooses.clear();
                            //   }

                            //   appController.urlRealPostChooses
                            //       .add(value.toString());

                            // print(
                            //     '##26april chatModel for insert ---->>> ${chatModel.toMap()}');

                            //   //Insert CollectionChat --> chat
                            //   AppService()
                            //       .processInsertChat(
                            //     chatModel: chatModel,
                            //     docIdRoom: appController.docIdRooms[
                            //         appController.indexBodyMainPageView.value],
                            //   )
                            //       .then((value) async {
                            //     AppService()
                            //         .processInsertChat(
                            //             collectionChat: 'chatOwner',
                            //             chatModel: chatModel,
                            //             docIdRoom: appController.docIdRooms[
                            //                 appController
                            //                     .indexBodyMainPageView.value])
                            //         .then((value) {
                            //       Get.back();
                            //       Get.back();
                            //     });
                            //   });
                            // });
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
