import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_amount_comment.dart';
import 'package:realpost/widgets/widget_circular_image.dart';
import 'package:realpost/widgets/widget_display_up.dart';
import 'package:realpost/widgets/widget_image.dart';
import 'package:realpost/widgets/widget_image_internet.dart';
import 'package:realpost/widgets/widget_progress_animation.dart';
import 'package:realpost/widgets/widget_text.dart';

class MainPageForGuest extends StatefulWidget {
  const MainPageForGuest({super.key});

  @override
  State<MainPageForGuest> createState() => _MainPageForGuestState();
}

class _MainPageForGuestState extends State<MainPageForGuest> {
  AppController appController = Get.put(AppController());

  @override
  void initState() {
    super.initState();
    appController.readAllRoom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return Obx(() {
          print('##7june chatModels ---> ${appController.chatModels.length}');
          return appController.roomModels.isEmpty
              ? const WidgetProgessAnimation()
              : SizedBox(
                  width: boxConstraints.maxWidth,
                  height: boxConstraints.maxHeight,
                  child: Stack(
                    children: [
                     displayListMessage(boxConstraints, appController),
                    ],
                  ),
                );
        });
      }),
    );
  } //build

   Widget displayListMessage(
      BoxConstraints boxConstraints, AppController appController) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: boxConstraints.maxWidth,
      height: boxConstraints.maxHeight,
      child: ListView.builder(
        reverse: false,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: appController.chatModels.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: AppConstant().realBox(),
            width: boxConstraints.maxWidth,
            child: InkWell(
              onTap: () {
                // print('##25may you tap Bubble');
                // AppService().processLunchUrl(
                //     url: appController.chatModels[index].message);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // displayAvatarPost(appController, index),
                      WidgetCircularImage(
                        urlImage: appController.chatModels[index].urlAvatar,
                        radius: 15,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      WidgetText(
                        text: appController.chatModels[index].disPlayName,
                        textStyle: AppConstant().h3Style(color: Colors.white),
                      ),
                      const Spacer(),
                     
                    ],
                  ),
                  InkWell(
                    onTap: () async {
                      // print('##26may you click');
                      // AppService()
                      //     .increaseValueGraph(
                      //         docIdChat: appController.docIdChats[index],
                      //         chatModel: appController.chatModels[index])
                      //     .then((value) {
                      //   Get.to(CommentChat(
                      //     docIdChat: appController.docIdChats[index],
                      //     chatModel: appController.chatModels[index],
                      //     index: index,
                      //   ));
                      // });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        appController.chatModels[index].message.isEmpty
                            ? const SizedBox()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 12),
                                child: WidgetText(
                                  text: AppService().cutWord(
                                      string: appController
                                          .chatModels[index].message,
                                      word: 60),
                                  textStyle: AppConstant().h3Style(
                                      color: Colors.white,
                                      size: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                        displayImageChat(appController, index),
                      ],
                    ),
                  ),
                  scoreButton(appController, index),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget displayImageChat(AppController appController, int index) {
    return appController.chatModels[index].urlRealPost.isEmpty
        ? const SizedBox()
        : Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: WidgetImageInternet(
              urlImage: appController.chatModels[index].urlRealPost,
              boxFit: BoxFit.cover,
            ),
          );
  }

  Widget scoreButton(AppController appController, int index) {
    return Row(
      children: [
        WidgetImage(
          path: 'images/graph.jpg',
          size: 36,
        ),
        const SizedBox(
          width: 5,
        ),
        WidgetText(
          // text: appController.statDataModels[0].amountGraph.toString(),
          text: appController.chatModels[index].amountGraph.toString(),
          textStyle:
              AppConstant().h3Style(size: 15, color: AppConstant.realFront),
        ),
        const SizedBox(
          width: 30,
        ),
        WidgetAmountComment(
          amountComment: appController.chatModels[index].amountComment,
        ),
        const SizedBox(
          width: 30,
        ),
        WidgetImage(
          path: 'images/up.jpg',
          size: 36,
        ),
        const SizedBox(
          width: 5,
        ),
        WidgetDisplayUp(
          indexChat: index,
        ),
      ],
    );
  }






}
