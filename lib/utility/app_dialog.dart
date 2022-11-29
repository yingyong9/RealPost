// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/widgets/widget_image_internet.dart';

class AppDialog {
  final BuildContext context;
  AppDialog({
    required this.context,
  });

  void myBottonSheet({required Function() tapFunc}) {
    AppController appController = Get.put(AppController());

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(color: AppConstant.bgColor),
        height: 200,
        child: GridView.builder(
          findChildIndexCallback: (key) {
            print('key ==> $key');
          },
          itemCount: appController.stampModels.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              print('you tab index == $index');
              appController.emojiAddRoomChooses.clear();
              appController.emojiAddRoomChooses
                  .add(appController.stampModels[index].url);
              Get.back();
            },
            child: WidgetImageInternet(
                urlImage: appController.stampModels[index].url),
          ),
        ),
      ),
    );
  }
}
