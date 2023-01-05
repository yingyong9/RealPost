// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_dialog.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_form.dart';
import 'package:realpost/widgets/widget_icon_button.dart';

class WidgetContentForm extends StatelessWidget {
  const WidgetContentForm({
    Key? key,
    required this.boxConstraints,
    required this.appController,
    required this.textEditingController,
    this.collection,
    this.docId,
  }) : super(key: key);

  final BoxConstraints boxConstraints;
  final AppController appController;
  final TextEditingController textEditingController;
  final String? collection;
  final String? docId;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        WidgetForm(
          width: boxConstraints.maxWidth,
          hintStyle: AppConstant().h3Style(color: AppConstant.grey),
          hint: 'พิมพ์ข้อความ...',
          textStyle: AppConstant().h3Style(),
          controller: textEditingController,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 250,
              child: Row(
                children: [
                  WidgetIconButton(
                    iconData: Icons.add_a_photo,
                    pressFunc: () async {
                      if (appController.cameraFiles.isNotEmpty) {
                        appController.cameraFiles.clear();
                      }

                      print('##5jan Click Camera at docIdRoom --> $docId');
                      print(
                          '##5jan cameraFiles ---> ${appController.cameraFiles.length}');

                      var file = await AppService()
                          .processTakePhoto(source: ImageSource.camera);

                      if (file != null) {
                        appController.cameraFiles.add(file);

                        String? urlCamera = await AppService()
                            .processUploadPhoto(file: file, path: 'photopost');
                        print('##5jan urlCamera ---. $urlCamera');

                        Map<String, dynamic> map = appController.roomModels[
                                appController.indexBodyMainPageView.value]
                            .toMap();
                        print('##5jan map ----> $map');

                        map['urlCamera'] = urlCamera;

                        await AppService()
                            .processUpdateRoom(docIdRoom: docId!, data: map);
                      } // if

                      print(
                          '##5jan cameraFiles ต่อมา ---> ${appController.cameraFiles.length}');
                    },
                  ),
                  WidgetIconButton(
                    iconData: Icons.add_photo_alternate,
                    pressFunc: () {},
                  ),
                  // WidgetIconButton(
                  //   iconData: Icons.emoji_emotions,
                  //   pressFunc: () {},
                  // ),
                  //  WidgetIconButton(
                  //   iconData: Icons.shopping_cart,
                  //   pressFunc: () {},
                  // ),
                  //  WidgetIconButton(
                  //   iconData: Icons.shopping_basket,
                  //   pressFunc: () {},
                  // ),
                ],
              ),
            ),
            WidgetIconButton(
              iconData: Icons.send,
              pressFunc: () async {
                if (textEditingController.text.isEmpty) {
                  print('No Text form');

                  if (appController.userModels[0].urlAvatar!.isNotEmpty) {
                    // การทำงานครั้งที่สอง
                    AppDialog(context: context).realPostBottonSheet(
                        collection: collection, docIdRoom: docId!);
                  }
                } else {
                  print('text = ${textEditingController.text}');
                  if (appController.messageChats.isNotEmpty) {
                    appController.messageChats.clear();
                  }
                  appController.messageChats.add(textEditingController.text);

                  textEditingController.text = '';

                  print('userModel => ${appController.userModels[0].toMap()}');

                  if (appController.userModels[0].urlAvatar?.isEmpty ?? true) {
                    AppDialog(context: context).avatarBottonSheet();
                  } else {
                    AppDialog(context: context).realPostBottonSheet(
                        collection: collection, docIdRoom: docId!);
                  }
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
