// ignore_for_file: avoid_print, sort_child_properties_last

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:realpost/models/chat_model.dart';
import 'package:realpost/models/room_model.dart';
import 'package:realpost/states/private_chat.dart';
import 'package:realpost/states/tab_price.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_button.dart';
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

    // AppService()
    //     .processSignOut()
    //     .then((value) => Get.offAllNamed(AppConstant.pagePhoneNumber));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return GetX(
            init: AppController(),
            builder: (AppController appController) {
              print(
                  '##26jan commentSalseModels --> ${appController.commentSalses.length} indexPage --> ${appController.indexBodyMainPageView}');

              return SafeArea(
                child: (appController.roomModels.isEmpty) ||
                        (appController.userModels.isEmpty) ||
                        (appController.userModelAtRooms.isEmpty)
                    ? const SizedBox()
                    : GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => FocusScope.of(context)
                            .requestFocus(FocusScopeNode()),
                        child: PageView(
                          children: appController.roomModels
                              .map(
                                (element) => SizedBox(
                                  width: boxConstraints.maxWidth,
                                  height: boxConstraints.maxHeight,
                                  child: Stack(
                                    children: [
                                      contentTop(element, boxConstraints,
                                          appController),
                                      element.safeProduct!
                                          ? Positioned(
                                              top: boxConstraints.maxHeight *
                                                  0.5,
                                              child: Container(
                                                color: Colors.white,
                                                width: boxConstraints.maxWidth,
                                                height:
                                                    boxConstraints.maxHeight *
                                                            0.5 -
                                                        110,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        width: boxConstraints
                                                            .maxWidth,
                                                        height: boxConstraints
                                                                    .maxHeight *
                                                                0.5 -
                                                            110,
                                                        child: TabPrice(
                                                          roomModel: element,
                                                          docIdRoom: appController
                                                                  .docIdRooms[
                                                              appController
                                                                  .indexBodyMainPageView
                                                                  .value],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      displayForm(
                                          boxConstraints, appController),
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

                            appController.amountSalse.value = 1;

                            appController.haveUserLoginInComment.value = false;

                            appController.readAllChat(
                                docIdRoom: appController.docIdRooms[
                                    appController.indexBodyMainPageView.value]);

                            if (appController.docIdRoomChooses.isNotEmpty) {
                              appController.docIdRoomChooses.clear();
                            }

                            appController.docIdRoomChooses.add(
                                appController.docIdRooms[
                                    appController.indexBodyMainPageView.value]);

                            appController.processReadCommentSalses();
                          },
                        ),
                      ),
              );
            });
      }),
    );
  }

  Positioned displayForm(
      BoxConstraints boxConstraints, AppController appController) {
    return Positioned(
      bottom: 0,
      child: WidgetContentForm(
        boxConstraints: boxConstraints,
        appController: appController,
        textEditingController: textEditingController,
        docId:
            appController.docIdRooms[appController.indexBodyMainPageView.value],
        roomModel:
            appController.roomModels[appController.indexBodyMainPageView.value],
      ),
    );
  }

  Positioned displayAddGroup() {
    return Positioned(
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
    );
  }

  Stack contentTop(
    RoomModel element,
    BoxConstraints boxConstraints,
    AppController appController,
  ) {
    return Stack(
      children: [
        displayImageRoom(element, boxConstraints),
        displayListMessage(
          boxConstraints,
          appController,
          top: 48,
          status: false,
          height: boxConstraints.maxHeight * 0.15,
        ),
        displayListMessage(boxConstraints, appController,
            top: element.safeProduct! ? 200 : 350,
            status: true,
            height: boxConstraints.maxHeight * 0.15,
            reverse: true),
        displayOwnerRoom(boxConstraints, appController),
        chatPrivateImage(appController: appController),
        chatPrivateButton(appController: appController),
        appController.roomModels[appController.indexBodyMainPageView.value]
                .safeProduct!
            ? Positioned(
                right: 16,
                top: 100,
                child: SizedBox(
                  width: boxConstraints.maxWidth * 0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        decoration:
                            AppConstant().boxBlack(color: Colors.black54),
                        child: WidgetText(
                          text:
                              'ราคา ${appController.roomModels[appController.indexBodyMainPageView.value].singlePrice!} thb',
                          textStyle: AppConstant().h2Style(color: Colors.white),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        decoration:
                            AppConstant().boxCurve(color: Colors.white38),
                        child: WidgetText(
                          text:
                              'ส่วนลด ${appController.roomModels[appController.indexBodyMainPageView.value].totalPrice} thb/ผู้เข้าร่วม 5 คน',
                          textStyle: AppConstant().h3Style(color: Colors.black),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        decoration:
                            AppConstant().boxCurve(color: Colors.white38),
                        child: WidgetText(
                          text:
                              'จำนวนผู้เข้าร่วม ${appController.commentSalses.length} คน ',
                          textStyle: AppConstant().h3Style(color: Colors.black),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        decoration:
                            AppConstant().boxCurve(color: Colors.white38),
                        child: WidgetText(
                          text: 'ส่วนลด ',
                          textStyle: AppConstant().h3Style(color: Colors.black),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        decoration:
                            AppConstant().boxCurve(color: Colors.black38),
                        child: WidgetText(
                          text: 'ส่วนลด ',
                          textStyle: AppConstant().h3Style(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  Widget chatPrivateImage({required AppController appController}) {
    return user!.uid ==
            appController
                .roomModels[appController.indexBodyMainPageView.value].uidCreate
        ? const SizedBox()
        : Positioned(
            right: 0,
            child: WidgetImage(
              path: 'images/icon2.png',
              size: 48,
              tapFunc: () {
                appController
                    .processFindDocIdPrivateChat(
                        uidLogin: user!.uid,
                        uidFriend: appController
                            .roomModels[
                                appController.indexBodyMainPageView.value]
                            .uidCreate)
                    .then((value) async {
                  ChatModel chatModel = await AppService().createChatModel(
                      urlRealPost: appController
                          .roomModels[appController.indexBodyMainPageView.value]
                          .urlRooms
                          .last);

                  await AppService()
                      .processInsertPrivateChat(
                          docIdPrivateChat:
                              appController.docIdPrivateChats.last,
                          chatModel: chatModel)
                      .then((value) {
                    Get.to(PrivateChat(
                        uidFriend: appController
                            .roomModels[
                                appController.indexBodyMainPageView.value]
                            .uidCreate));
                  });
                });
              },
            ),
          );
  }

  Widget chatPrivateButton({required AppController appController}) {
    return user!.uid ==
            appController
                .roomModels[appController.indexBodyMainPageView.value].uidCreate
        ? const SizedBox()
        : Positioned(
            right: 16,
            bottom: 0,
            child: WidgetButton(
              label: 'สอบถามหรือสั่ง',
              bgColor: Colors.red,
              pressFunc: () {
                appController
                    .processFindDocIdPrivateChat(
                        uidLogin: user!.uid,
                        uidFriend: appController
                            .roomModels[
                                appController.indexBodyMainPageView.value]
                            .uidCreate)
                    .then((value) async {
                  ChatModel chatModel = await AppService().createChatModel(
                      urlRealPost: appController
                          .roomModels[appController.indexBodyMainPageView.value]
                          .urlRooms
                          .last);

                  await AppService()
                      .processInsertPrivateChat(
                          docIdPrivateChat:
                              appController.docIdPrivateChats.last,
                          chatModel: chatModel)
                      .then((value) {
                    Get.to(PrivateChat(
                        uidFriend: appController
                            .roomModels[
                                appController.indexBodyMainPageView.value]
                            .uidCreate));
                  });
                });
              },
            ),
          );
  }

  Positioned displayListMessage(
    BoxConstraints boxConstraints,
    AppController appController, {
    required double top,
    double? marginLeft,
    required bool status,
    double? height,
    bool? reverse,
  }) {
    return Positioned(
      top: top,
      child: SizedBox(
        width: boxConstraints.maxWidth * 0.5,
        height: height ??
            boxConstraints.maxHeight - (boxConstraints.maxHeight * 0.2),
        child: ListView.builder(
          reverse: reverse ?? false,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: appController.chatModels.length,
          itemBuilder: (context, index) {
            bool? myCondition; // ต่้องเป็น false ถึงจะแสดงผล
            // status -> false PostLogin, true Geast
            if (status) {
              //การทำงานแสดง Post ของคนที่ Guest
              myCondition = appController.chatModels[index].uidChat ==
                  appController
                      .roomModels[appController.indexBodyMainPageView.value]
                      .uidCreate;
            } else {
              //การทำงานแสดง Post ของคนที่ login
              myCondition = appController.chatModels[index].uidChat !=
                  appController
                      .roomModels[appController.indexBodyMainPageView.value]
                      .uidCreate;
            }

            // myCondition = status ||
            //     (appController.chatModels[index].uidChat == user!.uid);

            print('##9jan status, myCondition ==> $status , $myCondition');
            print(
                '##9jan uidLogin ==> ${user!.uid} ==== uidPost ==> ${appController.chatModels[index].uidChat}');

            return myCondition
                ? const SizedBox()
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      status
                          ? Container(
                              margin: EdgeInsets.only(
                                left: marginLeft ?? 16,
                                // right: 4,
                              ),
                              child: WidgetCircularImage(
                                urlImage:
                                    appController.chatModels[index].urlAvatar,
                                radius: 14,
                              ),
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

  Widget displayImageRoom(RoomModel roomModel, BoxConstraints boxConstraints) {
    return ImageSlideshow(
      autoPlayInterval: roomModel.urlRooms.length == 1 ? 0 : 3000,
      isLoop: true,
      height: roomModel.safeProduct!
          ? boxConstraints.maxHeight * 0.5
          : boxConstraints.maxHeight - 110,
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
    return appController.userModelAtRooms.isEmpty
        ? const SizedBox()
        : Row(
            children: [
              Container(
                constraints:
                    BoxConstraints(maxWidth: boxConstraints.maxWidth * 0.75),
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
                          .userModelAtRooms[
                              appController.indexBodyMainPageView.value]
                          .displayName,
                      textStyle: AppConstant().h2Style(),
                    )
                  ],
                ),
              ),
            ],
          );
  }
}
