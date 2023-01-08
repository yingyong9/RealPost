// ignore_for_file: avoid_print, sort_child_properties_last

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:realpost/models/room_model.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_circular_image.dart';
import 'package:realpost/widgets/widget_content_form.dart';
import 'package:realpost/widgets/widget_icon_button.dart';
import 'package:realpost/widgets/widget_image.dart';
import 'package:realpost/widgets/widget_image_internet.dart';
import 'package:realpost/widgets/widget_text.dart';

class MainPageView extends StatefulWidget {
  const MainPageView({super.key});

  @override
  State<MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
  AppController controller = Get.put(AppController());
  var user = FirebaseAuth.instance.currentUser;

  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AppService().initialSetup(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return GetX(
            init: AppController(),
            builder: (AppController appController) {
              print('##4jan userModels --> ${appController.userModels.length}');
              return SafeArea(
                child: (appController.roomModels.isEmpty) ||
                        (appController.userModels.isEmpty) ||
                        (appController.userModelAtRooms.isEmpty)
                    ? const SizedBox()
                    : PageView(
                        children: appController.roomModels
                            .map(
                              (element) => SizedBox(
                                width: boxConstraints.maxWidth,
                                height: boxConstraints.maxHeight,
                                child: Stack(
                                  children: [
                                    contentTop(
                                        element, boxConstraints, appController),
                                    displayListMessage(
                                        boxConstraints, appController,
                                        top: boxConstraints.maxHeight * 0.6,
                                        status: true,
                                        height: (boxConstraints.maxHeight) -
                                            (boxConstraints.maxHeight * 0.6) -
                                            120),
                                    Positioned(
                                      right: 32,
                                      bottom: 100,
                                      child: Column(
                                        children: [
                                          WidgetIconButton(
                                            iconData: Icons.chat,
                                            pressFunc: () {},
                                          ),
                                          const WidgetImage(
                                            path: 'images/addgreen.png',
                                            size: 36,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      child: WidgetContentForm(
                                        boxConstraints: boxConstraints,
                                        appController: appController,
                                        textEditingController:
                                            textEditingController,
                                        docId: appController.docIdRooms[
                                            appController
                                                .indexBodyMainPageView.value],
                                        roomModel: appController.roomModels[
                                            appController
                                                .indexBodyMainPageView.value],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        controller: PageController(
                            initialPage:
                                appController.indexBodyMainPageView.value),
                        scrollDirection: Axis.vertical,
                        onPageChanged: (value) {
                          appController.indexBodyMainPageView.value = value;
                          appController.readAllChat(
                              docIdRoom: appController.docIdRooms[
                                  appController.indexBodyMainPageView.value]);
                        },
                      ),
              );
            });
      }),
    );
  }

  Stack contentTop(RoomModel element, BoxConstraints boxConstraints,
      AppController appController) {
    return Stack(
      children: [
        displayImageRoom(element, boxConstraints),
        displayListMessage(boxConstraints, appController,
            top: boxConstraints.maxHeight * 0.6 * 0.5, status: false),
        displayOwnerRoom(boxConstraints, appController),
        // displayImageCamera(element, boxConstraints),
      ],
    );
  }

  Positioned displayImageCamera(
      RoomModel element, BoxConstraints boxConstraints) {
    return Positioned(
      right: 0,
      child: element.urlCamera!.isEmpty
          ? const SizedBox()
          : Container(
              decoration: AppConstant().borderBox(),
              child: WidgetImageInternet(
                urlImage: element.urlCamera!,
                width: boxConstraints.maxWidth * 0.3,
                height: boxConstraints.maxWidth * 0.3,
                boxFit: BoxFit.cover,
              ),
            ),
    );
  }

  Widget displayOwnerRoom(
      BoxConstraints boxConstraints, AppController appController) {
    return appController.userModelAtRooms.isEmpty ? const SizedBox() : Row(
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: boxConstraints.maxWidth * 0.75),
          decoration: AppConstant().boxBlack(),
          child: Row(
            children: [
              WidgetCircularImage(
                  urlImage: appController
                          .userModelAtRooms[
                              appController.indexBodyMainPageView.value]
                          .urlAvatar ??
                      AppConstant.urlAvatar),
              WidgetText(
                text: appController
                    .userModelAtRooms[appController.indexBodyMainPageView.value]
                    .displayName,
                textStyle: AppConstant().h2Style(),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget displayImageRoom(RoomModel roomModel, BoxConstraints boxConstraints) {
    return ImageSlideshow(
      autoPlayInterval: roomModel.urlRooms.length == 1 ? 0 : 3000,
      isLoop: true,
      height: boxConstraints.maxHeight * 0.6,
      children: roomModel.urlRooms
          .map(
            (e) => WidgetImageInternet(
              urlImage: e,
              width: boxConstraints.maxWidth,
              boxFit: BoxFit.cover,
            ),
          )
          .toList(),
    );

    //  WidgetImageInternet(
    //   urlImage: roomModel.urlRooms.last,
    //   width: boxConstraints.maxWidth,
    //   height: boxConstraints.maxHeight * 0.6,
    //   boxFit: BoxFit.cover,
    // );
  }

  Positioned displayListMessage(
    BoxConstraints boxConstraints,
    AppController appController, {
    required double top,
    double? marginLeft,
    required bool status,
    double? height,
  }) {
    return Positioned(
      top: top,
      child: SizedBox(
        width: boxConstraints.maxWidth,
        height: height ??
            boxConstraints.maxHeight - (boxConstraints.maxHeight * 0.4),
        child: ListView.builder(
          reverse: true,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: appController.chatModels.length,
          itemBuilder: (context, index) {
            bool? myCondition;
            // status -> false PostLogin, true Geast
            if (status) {
              myCondition =
                  appController.chatModels[index].uidChat == user!.uid;
            } else {
              myCondition =
                  appController.chatModels[index].uidChat != user!.uid;
            }

            return myCondition
                ? const SizedBox()
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      status
                          ? Container(
                              margin: EdgeInsets.only(
                                left: marginLeft ?? 16,
                                right: 16,
                              ),
                              child: WidgetCircularImage(
                                  urlImage: appController
                                      .chatModels[index].urlAvatar),
                            )
                          : const SizedBox(
                              width: 16,
                            ),
                      Container(
                        constraints: BoxConstraints(
                            maxWidth: boxConstraints.maxWidth * 0.5),
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 12),
                        margin: const EdgeInsets.only(top: 4),
                        decoration: AppConstant().boxChatGuest(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WidgetText(
                              text: appController.chatModels[index].disPlayName,
                              textStyle: AppConstant()
                                  .h3Style(fontWeight: FontWeight.bold),
                            ),
                            WidgetText(
                                text: appController.chatModels[index].message),
                          ],
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
