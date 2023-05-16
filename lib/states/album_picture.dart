// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_icon_button.dart';
import 'package:realpost/widgets/widget_text.dart';

class AlbumPicture extends StatefulWidget {
  const AlbumPicture({super.key});

  @override
  State<AlbumPicture> createState() => _AlbumPictureState();
}

class _AlbumPictureState extends State<AlbumPicture> {
  AppController controller = Get.put(AppController());

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print('##23dec จำนวนรูปที่เลือก --> ${appController.xFiles.length}');
          return Scaffold(
            backgroundColor: AppConstant.bgColor,
            appBar: AppBar(
              actions: [
                appController.xFiles.isEmpty
                    ? const SizedBox()
                    : WidgetIconButton(
                        iconData: Icons.cloud_upload,
                        pressFunc: () {
                          Get.back();
                        },
                      ),
              ],
              title: WidgetText(
                text: 'สร้างอัลบัม',
                textStyle: AppConstant().h2Style(),
              ),
            ),
            body: appController.xFiles.isEmpty
                ? const SizedBox()
                : GridView.builder(
                    itemCount: appController.xFiles.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4),
                    itemBuilder: (context, index) => Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(
                          File(appController.xFiles[index].path),
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: WidgetIconButton(
                            iconData: Icons.cancel,
                            pressFunc: () {
                              appController.xFiles.removeAt(index);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
            floatingActionButton: WidgetIconButton(
              iconData: Icons.add_photo_alternate,
              size: 36,
              pressFunc: () {
                AppService().processChooseMultiImage();
              },
            ),
          );
        });
  }
}
