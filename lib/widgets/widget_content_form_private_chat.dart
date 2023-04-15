// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:realpost/models/chat_model.dart';
import 'package:realpost/models/room_model.dart';
import 'package:realpost/models/user_model.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_dialog.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_form.dart';
import 'package:realpost/widgets/widget_icon_button.dart';

class WidgetContentFormPrivateChat extends StatefulWidget {
  const WidgetContentFormPrivateChat({
    Key? key,
    required this.boxConstraints,
    required this.appController,
    required this.textEditingController,
    this.collection,
    this.docId,
    this.roomModel,
    this.docIdPrivateChat,
    this.uidFriend,
  }) : super(key: key);

  final BoxConstraints boxConstraints;
  final AppController appController;
  final TextEditingController textEditingController;
  final String? collection;
  final String? docId;
  final RoomModel? roomModel;
  final String? docIdPrivateChat;
  final String? uidFriend;

  @override
  State<WidgetContentFormPrivateChat> createState() =>
      _WidgetContentFormPrivateChatState();
}

class _WidgetContentFormPrivateChatState
    extends State<WidgetContentFormPrivateChat> {
  var user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        WidgetForm(
          width: widget.boxConstraints.maxWidth,
          hintStyle: AppConstant().h3Style(color: AppConstant.grey),
          hint: 'พิมพ์ข้อความ...',
          textStyle: AppConstant().h3Style(),
          controller: widget.textEditingController,
        ),
        contentSizebox(context),
      ],
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
                Row(
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
                              .roomModels[widget
                                  .appController.indexBodyMainPageView.value]
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
                        AppService().processChooseMultiImage().then((value) {
                          AppService().processUploadMultiPhoto().then((value) {
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
                ),
              ],
            ),
          ),
          // InkWell(
          //   onTap: () {
          //     Get.to(const AddProduct());
          //   },
          //   child: const WidgetImage(
          //     path: 'images/addgreen.png',
          //     size: 24,
          //   ),
          // ),
          WidgetIconButton(
            iconData: Icons.send,
            pressFunc: () async {
              if (widget.textEditingController.text.isEmpty) {
                print('No Text form');

                if (widget
                    .appController.userModels.last.urlAvatar!.isNotEmpty) {
                  // การทำงานครั้งที่สอง
                  AppDialog(context: context).realPostBottonSheet(
                      collection: widget.collection, docIdRoom: widget.docId!);
                }
              } else {
                print(
                    '##9jan text ที่โพส = ${widget.textEditingController.text}');

                if (widget.appController.messageChats.isNotEmpty) {
                  widget.appController.messageChats.clear();
                }

                widget.appController.messageChats
                    .add(widget.textEditingController.text);

                widget.textEditingController.text = '';

                print(
                    'userModel => ${widget.appController.userModels.last.toMap()}');

                if (widget.appController.userModels.last.urlAvatar?.isEmpty ??
                    true) {
                  AppDialog(context: context).avatarBottonSheet();
                } else {
                  ChatModel chatModel = await AppService().createChatModel();
                  print('##5feb chatModel ---> ${chatModel.toMap()}');
                  print(
                      '##5feb docIdPrivateChat ---> ${widget.docIdPrivateChat}');

                  await AppService()
                      .processInsertPrivateChat(
                          docIdPrivateChat: widget.docIdPrivateChat!,
                          chatModel: chatModel)
                      .then((value) async {
                    UserModel? userModelLogin = await AppService()
                        .findUserModel(uid: widget.appController.mainUid.value);
                    print(
                        '##4april userModelLogin --> ${userModelLogin!.toMap()}');

                    UserModel? userModelFriend = await AppService()
                        .findUserModel(uid: widget.uidFriend!);
                    print(
                        '##4april userModelFriend --> ${userModelLogin.toMap()}');

                    AppService().processSentNoti(
                        title: 'มีข้อความ',
                        body:
                            '${widget.appController.messageChats.last} %23${userModelLogin.idReal}',
                        token: userModelFriend!.token!);
                  });

                 
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
