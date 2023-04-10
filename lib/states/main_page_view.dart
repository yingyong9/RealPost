// ignore_for_file: avoid_print, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:realpost/models/chat_model.dart';
import 'package:realpost/models/room_model.dart';
import 'package:realpost/states/add_product.dart';
import 'package:realpost/states/display_profile.dart';
import 'package:realpost/states/list_friend.dart';
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
import 'package:realpost/widgets/widget_progress.dart';
import 'package:realpost/widgets/widget_text.dart';

class MainPageView extends StatefulWidget {
  const MainPageView({super.key});

  @override
  State<MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
  AppController controller = Get.put(AppController());

  TextEditingController textEditingController = TextEditingController();

  bool secondLoad = true;

  @override
  void initState() {
    super.initState();

    controller.pageControllers.add(
        PageController(initialPage: controller.indexBodyMainPageView.value));

    AppService().initialSetup(context: context);
    AppService().aboutNoti(context: context);
    AppService().freshUserModelLogin();
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
              print('##9april ---> ${appController.chatOwnerModels.length}');

              return SafeArea(
                child: appController.noRoom.value
                    ? const WidgetProgress()
                    : ((appController.roomModels.isEmpty) &&
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
                                                      .indexBodyMainPageView
                                                      .value]
                                                  .safeProduct!
                                              ? const SizedBox()
                                              : displayForm(boxConstraints,
                                                  appController),
                                          backHomeAndAdd(appController,
                                              boxConstraints: boxConstraints),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                              // controller: pageViewController,
                              controller: appController.pageControllers.last,
                              scrollDirection: Axis.vertical,
                              onPageChanged: (value) {
                                appController.indexBodyMainPageView.value =
                                    value;

                                appController.amountSalse.value = 1;

                                appController.haveUserLoginInComment.value =
                                    false;

                                appController.readAllChat(
                                    docIdRoom: appController.docIdRooms[
                                        appController
                                            .indexBodyMainPageView.value]);

                                AppService().readAllChatOwner(
                                    docIdRoom: appController.docIdRooms[
                                        appController
                                            .indexBodyMainPageView.value]);

                                if (appController.docIdRoomChooses.isNotEmpty) {
                                  appController.docIdRoomChooses.clear();
                                }

                                appController.docIdRoomChooses.add(appController
                                        .docIdRooms[
                                    appController.indexBodyMainPageView.value]);

                                appController.processReadCommentSalses();

                                print(
                                    '##2april indexbody ---> ${appController.indexBodyMainPageView.value}');
                                print(
                                    '##2april docIdRoom --> ${appController.documentSnapshots[appController.indexBodyMainPageView.value].id}');

                                if (appController.indexBodyMainPageView.value ==
                                    0) {
                                  AppService().initialSetup(context: context);
                                  secondLoad = true;
                                }

                                if ((appController
                                            .indexBodyMainPageView.value >=
                                        (AppConstant.amountLoadPage - 1)) &&
                                    secondLoad) {
                                  secondLoad = false;
                                  print(
                                      '##2april docIdRoom ที่อยู่ในเงื่อนไข --> ${appController.documentSnapshots[appController.indexBodyMainPageView.value].id}');
                                  appController.readAllRoomStartDocument(
                                      documentSnapshot:
                                          appController.documentSnapshots[
                                              appController
                                                  .indexBodyMainPageView
                                                  .value]);
                                }
                              },
                            ),
                          ),
              );
            });
      }),
    );
  }

  Widget contentMidforSalse(
    RoomModel element,
    BoxConstraints boxConstraints,
    AppController appController,
  ) {
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
        displayRealText(appController: appController),
        appController.chatOwnerModels.isEmpty
            ? const SizedBox()
            : displayTextChatOwner(boxConstraints, appController),
        (appController.chatOwnerModels.isEmpty) ||
                (AppService()
                    .findUrlImageWork(chatmodels: appController.chatOwnerModels)
                    .isEmpty)
            ? const SizedBox()
            : Positioned(
                top: 70,
                left: 16,
                child: Container(
                  decoration: AppConstant().borderBox(),
                  child: WidgetImageInternet(
                    urlImage: AppService().findUrlImageWork(
                        chatmodels: appController.chatOwnerModels),
                    width: boxConstraints.maxWidth * 0.5 - 64,
                    height: boxConstraints.maxWidth * 0.5 - 32,
                    boxFit: BoxFit.cover,
                  ),
                ),
              ),
      ],
    );
  }

  Widget displayTextChatOwner(
      BoxConstraints boxConstraints, AppController appController) {
    return AppService()
            .findContentMessage(chatmodels: appController.chatOwnerModels)
            .isEmpty
        ? const SizedBox()
        : Positioned(
            top: 60,
            right: 0,
            child: Container(
              width: boxConstraints.maxWidth * 0.5,
              // height: 60,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              margin: const EdgeInsets.only(top: 4),
              decoration: AppConstant()
                  .boxChatGuest(bgColor: Colors.black.withOpacity(0.5)),
              child: WidgetText(
                text: AppService().findContentMessage(
                    chatmodels: appController.chatOwnerModels),
                textStyle: AppConstant().h3Style(color: Colors.white),
              ),
            ),
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
            top: boxConstraints.maxHeight * 0.6,
            height: boxConstraints.maxHeight * 0.25,
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
          : boxConstraints.maxHeight * 0.7 - 200,
      child: Column(
        children: [
          appController.roomModels[appController.indexBodyMainPageView.value]
                      .geoPoint!.latitude ==
                  0
              ? const SizedBox()
              : Container(
                  decoration:
                      AppConstant().boxCurve(color: Colors.green.shade900),
                  child: WidgetIconButton(
                    color: Colors.grey.shade300,
                    size: 36,
                    pressFunc: () {
                      GeoPoint geoPoint = appController
                          .roomModels[appController.indexBodyMainPageView.value]
                          .geoPoint!;
                      String url =
                          'https://www.google.com/maps/search/?api=1&query=${geoPoint.latitude},${geoPoint.longitude}';
                      AppService().processLunchUrl(url: url);
                    },
                    iconData: Icons.pin_drop,
                  ),
                ),
          const SizedBox(
            height: 8,
          ),
          WidgetImage(
            path: 'images/icon2.png',
            size: 60,
            tapFunc: () {
              Get.to(const ListFriend());
            },
          ),
          Container(
            decoration: AppConstant().boxCurve(color: Colors.green.shade900),
            child: WidgetIconButton(
              color: Colors.grey.shade300,
              size: 36,
              pressFunc: () {
                Get.to(const DisplayProfile());
              },
              iconData: Icons.home,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
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
          const SizedBox(
            height: 8,
          ),
          // (appController.roomModels[appController.indexBodyMainPageView.value]
          //             .uidCreate
          //             .toString() ==
          //         appController.mainUid.toString())
          //     ? const SizedBox()
          //     :

          Container(
            decoration: AppConstant().boxCurve(color: Colors.white),
            child: InkWell(
              child: const WidgetImage(
                path: 'images/basket.png',
                size: 48,
              ),
              onTap: () {
                AppBottomSheet().orderButtonSheet(
                    roomModel: appController
                        .roomModels[appController.indexBodyMainPageView.value],
                    height: boxConstraints.maxHeight * 0.35,
                    userModelLogin: appController.userModels.last);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget displayRealText({required AppController appController}) {
    return Positioned(
      right: 8,
      child: AppService().compareCurrentTime(
              otherDatetime: appController
                  .roomModels[appController.indexBodyMainPageView.value]
                  .timestamp
                  .toDate())
          ? Container(
              padding: const EdgeInsets.all(8),
              // decoration: AppConstant().boxCurve(
              //     color: Color.fromARGB(255, 198, 27, 52), radius: 20),
              child: WidgetText(
                text: '  Real  ',
                textStyle: AppConstant().h2Style(color: Colors.red.shade700),
              ),
            )
          : const SizedBox(),
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
        width: boxConstraints.maxWidth * 0.75,
        height: height ??
            boxConstraints.maxHeight - (boxConstraints.maxHeight * 0.2),
        child: ListView.builder(
          reverse: reverse ?? false,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: appController.chatModels.length,
          itemBuilder: (context, index) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   margin: EdgeInsets.only(
                //     left: marginLeft ?? 16,
                //     // right: 4,
                //   ),
                //   child: WidgetCircularImage(
                //     urlImage: appController.chatModels[index].urlAvatar,
                //     radius: 14,
                //   ),
                // ),
                InkWell(
                  onTap: () {
                    print(
                        '##2april You tab uidFriend --> ${appController.chatModels[index].uidChat}');
                    if (appController.chatModels[index].uidChat.toString() !=
                        appController.mainUid.toString()) {
                      Get.to(PrivateChat(
                          uidFriend: appController.chatModels[index].uidChat));
                    }
                  },
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: boxConstraints.maxWidth * 0.75),
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    margin: const EdgeInsets.only(top: 4),
                    decoration: AppConstant()
                        .boxChatGuest(bgColor: Colors.black.withOpacity(0.5)),

                    child: Text.rich(TextSpan(
                        text: appController.chatModels[index].disPlayName,
                        style: AppConstant().h3Style(
                            color: Colors.yellow, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                              text: ' : ',
                              style: AppConstant().h3Style(
                                  color: Colors.yellow,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: appController.chatModels[index].message,
                              style: AppConstant().h3Style(color: Colors.white))
                        ])),
                    // child: Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     SizedBox(
                    //       // width: boxConstraints.maxWidth * 0.5 - 80,
                    //       child: WidgetText(
                    //         text: appController.chatModels[index].disPlayName,
                    //         textStyle: AppConstant()
                    //             .h3Style(fontWeight: FontWeight.bold),
                    //       ),
                    //     ),
                    //     WidgetText(text: ' : '),
                    //     SizedBox(
                    //       // width: boxConstraints.maxWidth * 0.5 - 80,
                    //       child: WidgetText(
                    //           text: appController.chatModels[index].message),
                    //     ),
                    //     appController.chatModels[index].urlRealPost.isEmpty
                    //         ? const SizedBox()
                    //         : SizedBox(
                    //             width: boxConstraints.maxWidth * 0.5 - 80,
                    //             child: WidgetImageInternet(
                    //                 urlImage: appController
                    //                     .chatModels[index].urlRealPost),
                    //           ),
                    //   ],
                    // ),
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
      autoPlayInterval: roomModel.urlRooms.length == 1 ? 0 : 5000,
      isLoop: true,
      height: roomModel.safeProduct!
          ? boxConstraints.maxHeight * 0.5
          : boxConstraints.maxHeight - 70,
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
                height: 60,
                constraints: BoxConstraints(maxWidth: boxConstraints.maxWidth),
                decoration: AppConstant()
                    .boxBlack(color: Colors.black.withOpacity(0.5)),
                child: Row(
                  children: [
                    WidgetCircularImage(
                        urlImage: appController
                                .userModelAtRooms[
                                    appController.indexBodyMainPageView.value]
                                .urlAvatar ??
                            AppConstant.urlAvatar),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        WidgetText(
                          text: appController
                              .userModelAtRooms[
                                  appController.indexBodyMainPageView.value]
                              .displayName!,
                          textStyle: AppConstant().h2Style(),
                        ),
                        AppService().compareCurrentTime(
                                otherDatetime: appController
                                    .roomModels[appController
                                        .indexBodyMainPageView.value]
                                    .timestamp
                                    .toDate())
                            ? const SizedBox()
                            : WidgetText(
                                text: AppService().timeStampToString(
                                    timestamp: appController
                                        .roomModels[appController
                                            .indexBodyMainPageView.value]
                                        .timestamp,
                                    newPattern: 'dd MMM yyyy'))
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
  }
}
