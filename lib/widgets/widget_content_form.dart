// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realpost/models/chat_model.dart';

import 'package:realpost/models/room_model.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_dialog.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_button.dart';
import 'package:realpost/widgets/widget_form.dart';
import 'package:realpost/widgets/widget_icon_button.dart';
import 'package:realpost/widgets/widget_image.dart';

class WidgetContentForm extends StatefulWidget {
  const WidgetContentForm({
    Key? key,
    required this.boxConstraints,
    required this.appController,
    required this.textEditingController,
    this.collection,
    this.docId,
    this.roomModel,
  }) : super(key: key);

  final BoxConstraints boxConstraints;
  final AppController appController;
  final TextEditingController textEditingController;
  final String? collection;
  final String? docId;
  final RoomModel? roomModel;

  @override
  State<WidgetContentForm> createState() => _WidgetContentFormState();
}

class _WidgetContentFormState extends State<WidgetContentForm> {
  var user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.boxConstraints.maxWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          (AppService().compareCurrentTime(
                      otherDatetime: widget
                          .appController
                          .roomModels[
                              widget.appController.indexBodyMainPageView.value]
                          .timestamp
                          .toDate()) &&
                  (widget
                          .appController
                          .roomModels[
                              widget.appController.indexBodyMainPageView.value]
                          .uidCreate ==
                      widget.appController.mainUid.toString()))
              ? Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: WidgetButton(
                    label: 'Real',
                    pressFunc: () {
                      if ((widget.roomModel!.uidCreate == user!.uid) &&
                          (AppService().compareCurrentTime(
                              otherDatetime: widget
                                  .appController
                                  .roomModels[widget.appController
                                      .indexBodyMainPageView.value]
                                  .timestamp
                                  .toDate()))) {
                        AppDialog(context: context).realPostBottonSheet(
                            collection: widget.collection,
                            docIdRoom: widget.docId!);
                      }
                    },
                    bgColor: Colors.red.shade900,
                  ),
                )
              : const SizedBox(),
          WidgetForm(
            width: (AppService().compareCurrentTime(
                        otherDatetime: widget
                            .appController
                            .roomModels[widget
                                .appController.indexBodyMainPageView.value]
                            .timestamp
                            .toDate()) &&
                    (widget
                            .appController
                            .roomModels[widget
                                .appController.indexBodyMainPageView.value]
                            .uidCreate ==
                        widget.appController.mainUid.toString()))
                ? widget.boxConstraints.maxWidth - 90
                : widget.boxConstraints.maxWidth,
            hintStyle: AppConstant().h3Style(color: AppConstant.grey),
            hint: 'พิมพ์ข้อความ...',
            textStyle: AppConstant().h3Style(),
            controller: widget.textEditingController,
            suffixIcon: WidgetIconButton(
              iconData: Icons.send,
              pressFunc: () async {
                if (widget.textEditingController.text.isEmpty) {
                  print('No Text form');
                } else {
                  print(
                      '##9jan text ที่โพส = ${widget.textEditingController.text}');

                  if (widget.appController.messageChats.isNotEmpty) {
                    widget.appController.messageChats.clear();
                  }

                  widget.appController.messageChats
                      .add(widget.textEditingController.text);

                  widget.textEditingController.text = '';

                  ChatModel chatModel = await AppService().createChatModel();

                  //สำหรับบันทึกใน room --> chat
                  await AppService()
                      .processInsertChat(
                    chatModel: chatModel,
                    docIdRoom: widget.docId!,
                  )
                      .then((value) {
                    widget.appController
                        .processFindDocIdPrivateChat(
                            uidLogin: user!.uid,
                            uidFriend: widget.roomModel!.uidCreate)
                        .then((value) {
                      if (widget.appController.mainUid.toString() !=
                          widget.roomModel!.uidCreate.toString()) {
                        Map<String, dynamic> map = chatModel.toMap();
                        map['urlRealPost'] = widget.roomModel!.urlRooms[0];

                        ChatModel newChatModel = ChatModel.fromMap(map);

                        AppService().processInsertPrivateChat(
                            docIdPrivateChat:
                                widget.appController.docIdPrivateChats.last,
                            chatModel: newChatModel);
                      }
                    });
                  });

                  //สำหรับ room --> chatOwner
                  if (widget.roomModel!.uidCreate ==
                      widget.appController.mainUid.toString()) {
                    AppService().processInsertChat(
                        chatModel: chatModel,
                        docIdRoom: widget.docId!,
                        collectionChat: 'chatOwner');
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  SizedBox contentSizebox(BuildContext context) {
    return SizedBox(
      width: widget.boxConstraints.maxWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            child: Row(
              children: [
                user!.uid == widget.roomModel!.uidCreate
                    ? Row(
                        children: [
                          WidgetIconButton(
                            iconData: Icons.add_a_photo,
                            pressFunc: () async {
                              if (widget.appController.cameraFiles.isNotEmpty) {
                                widget.appController.cameraFiles.clear();
                              }

                              var file = await AppService()
                                  .processTakePhoto(source: ImageSource.camera);

                              if (file != null) {
                                widget.appController.cameraFiles.add(file);

                                String? urlCamera = await AppService()
                                    .processUploadPhoto(
                                        file: file, path: 'photopost');

                                Map<String, dynamic> map = widget
                                    .appController
                                    .roomModels[widget.appController
                                        .indexBodyMainPageView.value]
                                    .toMap();

                                List<String> urlRooms = <String>[];
                                urlRooms.add(urlCamera!);

                                map['urlRooms'] = urlRooms;

                                await AppService().processUpdateRoom(
                                    docIdRoom: widget.docId!, data: map);
                              } // if
                            },
                          ),
                          WidgetIconButton(
                            iconData: Icons.add_photo_alternate,
                            pressFunc: () {
                              AppService()
                                  .processChooseMultiImage()
                                  .then((value) {
                                AppService()
                                    .processUploadMultiPhoto()
                                    .then((value) {
                                  var urlImages = value;
                                  List<String> urlRooms = <String>[];
                                  urlRooms.addAll(urlImages);

                                  Map<String, dynamic> map =
                                      widget.roomModel!.toMap();
                                  map['urlRooms'] = urlRooms;

                                  AppService()
                                      .processUpdateRoom(
                                          docIdRoom: widget.docId!, data: map)
                                      .then((value) {
                                    print('##6jan update Room Success');
                                  });
                                });
                              });
                            },
                          ),
                        ],
                      )
                    : WidgetImage(
                        path: 'images/icon2.png',
                        size: 24,
                        tapFunc: () {
                          print('##15mar You tap');
                          // Get.to(PrivateChat(
                          //     uidFriend: widget.roomModel!.uidCreate));
                        },
                      ),
              ],
            ),
          ),

          // WidgetImage(
          //   path: 'images/addgreen.png',
          //   size: 24,
          //   tapFunc: () {
          //     Get.to(const AddProduct())!.then((value) {
          //       AppService().initialSetup(context: context);
          //     });
          //   },
          // ),
        ],
      ),
    );
  }
}
