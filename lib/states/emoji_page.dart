// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/widgets/widget_image_internet.dart';

class EmojiPage extends StatefulWidget {
  const EmojiPage({super.key});

  @override
  State<EmojiPage> createState() => _EmojiPageState();
}

class _EmojiPageState extends State<EmojiPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print('amount stempmodel ==> ${appController.stampModels.length}');
          print('urlAvatarChooses ==> ${appController.urlAvatarChooses}');
          return Scaffold(
            backgroundColor: AppConstant.bgColor,
            appBar: AppBar(),
            body: GridView.builder(
              itemCount: appController.stampModels.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (context, index) => WidgetImageInternet(
                urlImage: appController.stampModels[index].url,
                tapFunc: () {
                  if (appController.urlAvatarChooses.isNotEmpty) {
                    appController.urlAvatarChooses.clear();
                  }

                  String url = appController.stampModels[index].url;
                  print('You Tap ==> $url');
                  appController.urlAvatarChooses.add(url);
                  Get.back();
                },
              ),
            ),
          );
        });
  }
}
