// ignore_for_file: avoid_print, sort_child_properties_last

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:realpost/models/chat_model.dart';
import 'package:realpost/models/room_model.dart';
import 'package:realpost/states/add_product.dart';
import 'package:realpost/states/private_chat.dart';
import 'package:realpost/states/tab_price.dart';
import 'package:realpost/utility/app_bottom_sheet.dart';
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

  TextEditingController textEditingController = TextEditingController();

  var pageViewController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    AppService().initialSetup(context: context);

    // trySignOut();
  }

  Future<void> trySignOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return GetX(
            init: AppController(),
            builder: (AppController appController) {
              print('indexPage --> ${appController.indexBodyMainPageView}');

              return SafeArea(
                child: ((appController.roomModels.isEmpty) &&
                        (appController.userModels.isEmpty) &&
                        (appController.userModelAtRooms.isEmpty))
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
                                      contentMidforSalse(element,
                                          boxConstraints, appController),
                                      appController
                                              .roomModels[appController
                                                  .indexBodyMainPageView.value]
                                              .safeProduct!
                                          ? const SizedBox()
                                          : displayForm(
                                              boxConstraints, appController),
                                      backHomeAndAdd(appController,
                                          boxConstraints: boxConstraints),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                          controller: pageViewController,
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

  Widget contentMidforSalse(RoomModel element, BoxConstraints boxConstraints,
      AppController appController) {
    return element.safeProduct!
        ? Positioned(
            top: boxConstraints.maxHeight * 0.5,
            child: Container(
              color: Colors.white,
              width: boxConstraints.maxWidth,
              // height: boxConstraints.maxHeight * 0.5 - 50,
              height: boxConstraints.maxHeight * 0.5 - 30,
              child: TabPrice(
                roomModel: element,
                docIdRoom: appController
                    .docIdRooms[appController.indexBodyMainPageView.value],
              ),
            ),
          )
        : const SizedBox();
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
        displayListChat(appController, boxConstraints),
        displayOwnerRoom(boxConstraints, appController),
        chatPrivateImage(appController: appController),
        // chatPrivateButton(appController: appController),
        // const WidgetDisplayPrice(),
      ],
    );
  }

  Widget displayListChat(
      AppController appController, BoxConstraints boxConstraints) {
    return appController
            .roomModels[appController.indexBodyMainPageView.value].safeProduct!
        ? const SizedBox()
        : displayListMessage(
            boxConstraints,
            appController,
            top: 300,
            height: boxConstraints.maxHeight * 0.30,
            reverse: true,
          );
  }

  Positioned backHomeAndAdd(AppController appController,
      {required BoxConstraints boxConstraints}) {
    return Positioned(
      right: 16,
      top: appController.roomModels[appController.indexBodyMainPageView.value]
              .safeProduct!
          ? boxConstraints.maxHeight * 0.4 - 50
          : boxConstraints.maxHeight * 0.7 - 50,
      child: Column(
        children: [
          Container(
            decoration: AppConstant().boxCurve(color: Colors.white),
            child: WidgetIconButton(
              pressFunc: () {
                if (appController.xFiles.isNotEmpty) {
                  appController.xFiles.clear();
                }

                Get.to(const AddProduct())!.then((value) {});
              },
              iconData: Icons.add_box,
              color: Colors.green,
              size: 36,
            ),
          ),
          appController.roomModels[appController.indexBodyMainPageView.value]
                  .safeProduct!
              ? const SizedBox()
              : WidgetButton(
                  label: 'สั่งสินค้า',
                  pressFunc: () {
                    AppBottomSheet().orderButtonSheet(
                        roomModel: appController.roomModels[
                            appController.indexBodyMainPageView.value]);
                  },
                  bgColor: Colors.red.shade700,
                )
        ],
      ),
    );
  }

  Widget chatPrivateImage({required AppController appController}) {
    return appController.mainUid.value ==
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
                        uidLogin: appController.mainUid.value,
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
    return appController.mainUid.value ==
            appController
                .roomModels[appController.indexBodyMainPageView.value].uidCreate
        ? const SizedBox()
        : Positioned(
            right: 16,
            bottom: 0,
            child: WidgetButton(
              label: 'สอบถาม',
              bgColor: Colors.red,
              pressFunc: () {
                appController
                    .processFindDocIdPrivateChat(
                        uidLogin: appController.mainUid.value,
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
    // required bool status,
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
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: marginLeft ?? 16,
                    // right: 4,
                  ),
                  child: WidgetCircularImage(
                    urlImage: appController.chatModels[index].urlAvatar,
                    radius: 14,
                  ),
                ),
                Container(
                  constraints:
                      BoxConstraints(maxWidth: boxConstraints.maxWidth * 0.5),
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  margin: const EdgeInsets.only(top: 4),
                  decoration: AppConstant().boxChatGuest(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: boxConstraints.maxWidth * 0.5 - 80,
                        child: WidgetText(
                          text: appController.chatModels[index].disPlayName,
                          textStyle: AppConstant()
                              .h3Style(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: boxConstraints.maxWidth * 0.5 - 80,
                        child: WidgetText(
                            text: appController.chatModels[index].message),
                      ),
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
                          .displayName!,
                      textStyle: AppConstant().h2Style(),
                    )
                  ],
                ),
              ),
            ],
          );
  }
}
