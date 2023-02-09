// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/widgets/widget_image_internet.dart';

class EmojiPage extends StatefulWidget {
  const EmojiPage({
    Key? key,
    required this.avatarBol,
  }) : super(key: key);

  final bool avatarBol;

  @override
  State<EmojiPage> createState() => _EmojiPageState();
}

class _EmojiPageState extends State<EmojiPage> {
  bool? avatarBol;

  @override
  void initState() {
    super.initState();
    avatarBol = widget.avatarBol; // true setup Avatar , false setup RealPost
  }

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print('amount stempmodel ==> ${appController.stampModels.length}');
          // print('urlAvatarChooses ==> ${appController.urlAvatarChooses}');
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
                  if (avatarBol!) {
                    if (appController.urlAvatarChooses.isNotEmpty) {
                      appController.urlAvatarChooses.clear();
                    }

                    if (appController.fileAvatars.isNotEmpty) {
                      appController.fileAvatars.clear();
                    }

                    String url = appController.stampModels[index].url;
                    print('You Tap ==> $url');

                    appController.urlAvatarChooses.add(url);
                    Get.back();
                  } else {
                    if (appController.urlRealPostChooses.isNotEmpty) {
                      appController.urlRealPostChooses.clear();
                    }

                    if (appController.fileRealPosts.isNotEmpty) {
                      appController.fileRealPosts.clear();
                    }

                    String url = appController.stampModels[index].url;
                    print('You Tap ==> $url');

                    appController.urlRealPostChooses.add(url);
                    Get.back();
                  }
                },
              ),
            ),
          );
        });
  }
}
