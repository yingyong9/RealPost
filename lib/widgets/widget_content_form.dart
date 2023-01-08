// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:realpost/models/room_model.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_dialog.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_form.dart';
import 'package:realpost/widgets/widget_icon_button.dart';

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
        SizedBox(
          width: widget.boxConstraints.maxWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 250,
                child: Row(
                  children: [
                    user!.uid == widget.roomModel!.uidCreate
                        ? Row(
                            children: [
                              WidgetIconButton(
                                iconData: Icons.add_a_photo,
                                pressFunc: () async {
                                  if (widget
                                      .appController.cameraFiles.isNotEmpty) {
                                    widget.appController.cameraFiles.clear();
                                  }

                                  var file = await AppService()
                                      .processTakePhoto(
                                          source: ImageSource.camera);

                                  if (file != null) {
                                    widget.appController.cameraFiles.add(file);

                                    String? urlCamera = await AppService()
                                        .processUploadPhoto(
                                            file: file, path: 'photopost');
                                    // print('##5jan urlCamera ---. $urlCamera');

                                    Map<String, dynamic> map = widget
                                        .appController
                                        .roomModels[widget.appController
                                            .indexBodyMainPageView.value]
                                        .toMap();
                                    // print('##5jan map ----> $map');

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
                                              docIdRoom: widget.docId!,
                                              data: map)
                                          .then((value) {
                                        print('##6jan update Room Success');
                                      });
                                    });
                                  });
                                },
                              ),
                              WidgetIconButton(
                                iconData: Icons.video_call,
                                pressFunc: () {},
                              ),
                            ],
                          )
                        : WidgetIconButton(
                            iconData: Icons.chat,
                            pressFunc: () {},
                          ),
                  ],
                ),
              ),
              WidgetIconButton(
                iconData: Icons.send,
                pressFunc: () async {
                  if (widget.textEditingController.text.isEmpty) {
                    print('No Text form');

                    if (widget
                        .appController.userModels[0].urlAvatar!.isNotEmpty) {
                      // การทำงานครั้งที่สอง
                      AppDialog(context: context).realPostBottonSheet(
                          collection: widget.collection,
                          docIdRoom: widget.docId!);
                    }
                  } else {
                    print('text = ${widget.textEditingController.text}');
                    if (widget.appController.messageChats.isNotEmpty) {
                      widget.appController.messageChats.clear();
                    }
                    widget.appController.messageChats
                        .add(widget.textEditingController.text);

                    widget.textEditingController.text = '';

                    print(
                        'userModel => ${widget.appController.userModels[0].toMap()}');

                    if (widget.appController.userModels[0].urlAvatar?.isEmpty ??
                        true) {
                      AppDialog(context: context).avatarBottonSheet();
                    } else {
                      AppDialog(context: context).realPostBottonSheet(
                          collection: widget.collection,
                          docIdRoom: widget.docId!);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
