// ignore_for_file: avoid_print, sort_child_properties_last

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realpost/models/room_model.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_circular_image.dart';
import 'package:realpost/widgets/widget_content_form.dart';
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
                        (appController.userModels.isEmpty)
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
                                      bottom: 0,
                                      child: WidgetContentForm(
                                        boxConstraints: boxConstraints,
                                        appController: appController,
                                        textEditingController:
                                            textEditingController,
                                        docId: appController.docIdRooms[
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
        Positioned(
          right: 0,
          child: element.urlCamera!.isEmpty
              ? const SizedBox()
              : Container(decoration: AppConstant().borderBox(),
                child: WidgetImageInternet(
                    urlImage: element.urlCamera!,
                    width: boxConstraints.maxWidth * 0.3,
                    height: boxConstraints.maxWidth * 0.3,
                    boxFit: BoxFit.cover,
                  ),
              ),
        ),
      ],
    );
  }

  Row displayOwnerRoom(
      BoxConstraints boxConstraints, AppController appController) {
    return Row(
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: boxConstraints.maxWidth * 0.75),
          decoration: AppConstant().boxBlack(),
          child: Row(
            children: [
              WidgetCircularImage(
                  urlImage: appController.userModels.last.urlAvatar ??
                      AppConstant.urlAvatar),
              WidgetText(
                text: appController.userModels.last.displayName,
                textStyle: AppConstant().h2Style(),
              )
            ],
          ),
        ),
      ],
    );
  }

  WidgetImageInternet displayImageRoom(
      RoomModel element, BoxConstraints boxConstraints) {
    return WidgetImageInternet(
      urlImage: element.urlRoom,
      width: boxConstraints.maxWidth,
      height: boxConstraints.maxHeight * 0.6,
      boxFit: BoxFit.cover,
    );
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
