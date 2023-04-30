// ignore_for_file: avoid_print, sort_child_properties_last

import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:realpost/models/chat_model.dart';
import 'package:realpost/models/room_model.dart';
import 'package:realpost/states/add_product.dart';
import 'package:realpost/states/display_profile.dart';
import 'package:realpost/states/full_screen_image.dart';
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
import 'package:realpost/widgets/widget_progress_animation.dart';
import 'package:realpost/widgets/widget_squeer_avatar.dart';
import 'package:realpost/widgets/widget_text.dart';
import 'package:badges/badges.dart' as badges;
import 'package:restart_app/restart_app.dart';

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
                    ? const WidgetProgessAnimation()
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
                                          ((appController.displayPanel.value) &&
                                                  (appController
                                                      .displayAll.value))
                                              ? backHomeAndAdd(appController,
                                                  boxConstraints:
                                                      boxConstraints)
                                              : const SizedBox(),
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
                                      '##30april docIdRoom ที่อยู่ในเงื่อนไข --> ${appController.documentSnapshots[appController.indexBodyMainPageView.value].id}');
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
        // displayImageRoom(boxConstraints, appController: appController),
        displayListChat(appController, boxConstraints),
        displayRealText(appController: appController),
        displayRoomText(appController, boxConstraints),
        // blueTextOwner(appController, boxConstraints),
        // (appController.chatOwnerModels.isEmpty) ||
        //         (AppService()
        //             .findUrlImageWork(chatmodels: appController.chatOwnerModels)
        //             .isEmpty)
        //     ? const SizedBox()
        //     : appController.displayAll.value
        //         ? Positioned(
        //             top: 16,
        //             left: 16,
        //             child: Container(
        //               decoration: AppConstant().borderBox(),
        //               child: WidgetImageInternet(
        //                 urlImage: AppService().findUrlImageWork(
        //                     chatmodels: appController.chatOwnerModels),
        //                 width: boxConstraints.maxWidth * 0.5 - 64,
        //                 height: boxConstraints.maxWidth * 0.5 - 32,
        //                 boxFit: BoxFit.cover,
        //                 tapFunc: () {
        //                   print(
        //                       'you tap image ${AppService().findUrlImageWork(chatmodels: appController.chatOwnerModels)}');
        //                   Get.to(FullScreenImage(
        //                       urlImage: AppService().findUrlImageWork(
        //                           chatmodels: appController.chatOwnerModels)));
        //                 },
        //               ),
        //             ),
        //           )
        //         : const SizedBox(),
      ],
    );
  }

  Positioned displayRoomText(
      AppController appController, BoxConstraints boxConstraints) {
    return Positioned(
      left: 16,
      top: 8,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetSqueerAvatar(
              size: 60,
              urlImage: appController
                  .roomModels[appController.indexBodyMainPageView.value]
                  .urlRooms[0]),
          const SizedBox(
            width: 8,
          ),
          SizedBox(
            width: boxConstraints.maxWidth * 0.6,
            child: BubbleSpecialOne(
              text: appController
                  .roomModels[appController.indexBodyMainPageView.value].room,
              textStyle: AppConstant().h3Style(color: Colors.black),
              isSender: false,
              color: AppConstant.bgChat,
            ),
          ),
        ],
      ),
    );
  }

  Widget blueTextOwner(
      AppController appController, BoxConstraints boxConstraints) {
    return appController.chatOwnerModels.isEmpty
        ? const SizedBox()
        : appController.displayAll.value
            ? displayTextChatOwner(boxConstraints, appController)
            : const SizedBox();
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
            child: InkWell(
              onTap: () {
                print('##17aprilYou tap');
                appController.displayPanel.value =
                    !appController.displayPanel.value;
              },
              child: SizedBox(
                width: boxConstraints.maxWidth * 0.6,
                child: BubbleSpecialThree(
                  text: AppService().findContentMessage(
                      chatmodels: appController.chatOwnerModels),
                  textStyle: AppConstant().h3Style(color: Colors.white),
                  isSender: false,
                  color: Colors.blue.shade900,
                  // color: Colors.green.shade900,
                ),
              ),
            ),
          );
  }

  Widget displayListChat(
      AppController appController, BoxConstraints boxConstraints) {
    return appController.displayAll.value
        ? displayListMessage(
            boxConstraints,
            appController,
            top: boxConstraints.maxHeight * 0.15,
            height: boxConstraints.maxHeight * 0.7,
            reverse: true,
          )
        : const SizedBox();
  }

  Widget backHomeAndAdd(AppController appController,
      {required BoxConstraints boxConstraints}) {
    return appController.displayAddFriends.isEmpty
        ? const SizedBox()
        : Positioned(
            right: 16,
            top: boxConstraints.maxHeight * 0.7 - 260,
            child: Column(
              children: [
                appController.displayAddFriends[
                        appController.indexBodyMainPageView.value]
                    ? badges.Badge(
                        badgeStyle:
                            badges.BadgeStyle(badgeColor: Colors.red.shade700),
                        position: badges.BadgePosition.bottomEnd(
                            end: 10, bottom: -12),
                        badgeContent: const Icon(
                          Icons.add,
                          size: 20,
                          color: Colors.white,
                        ),
                        child: Container(
                          decoration:
                              AppConstant().boxCurve(color: Colors.white),
                          child: WidgetImageInternet(
                            urlImage: appController
                                .userModelAtRooms[
                                    appController.indexBodyMainPageView.value]
                                .urlAvatar!,
                            width: 48,
                            height: 48,
                            boxFit: BoxFit.cover,
                            tapFunc: () {
                              Get.to(const DisplayProfile());
                            },
                          ),
                        ),
                        onTap: () {
                          String uidFriend = appController
                              .roomModels[
                                  appController.indexBodyMainPageView.value]
                              .uidCreate;

                          AppService()
                              .processAddFriend(uidFriend: uidFriend)
                              .then((value) async {
                            print(
                                '##19april You tab add uidFried --> $uidFriend success');
                            appController.displayAddFriends.clear();
                            for (var element in appController.roomModels) {
                              appController.displayAddFriends.add(
                                  await AppService().findPatnerFriend(
                                      uidCheckFriend: element.uidCreate));
                            }
                          });
                        },
                      )
                    : Container(
                        decoration: AppConstant().boxCurve(color: Colors.white),
                        child: WidgetImageInternet(
                          urlImage: appController
                              .userModelAtRooms[
                                  appController.indexBodyMainPageView.value]
                              .urlAvatar!,
                          width: 48,
                          height: 48,
                          boxFit: BoxFit.cover,
                          tapFunc: () {
                            Get.to(const DisplayProfile());
                          },
                        ),
                      ),

                const SizedBox(
                  height: 8,
                ),
                appController
                            .roomModels[
                                appController.indexBodyMainPageView.value]
                            .geoPoint!
                            .latitude ==
                        0
                    ? const SizedBox()
                    : Container(
                        decoration: AppConstant()
                            .boxCurve(color: Colors.green.shade900),
                        child: WidgetIconButton(
                          color: Colors.grey.shade300,
                          size: 36,
                          pressFunc: () {
                            GeoPoint geoPoint = appController
                                .roomModels[
                                    appController.indexBodyMainPageView.value]
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

                Container(
                  decoration:
                      AppConstant().boxCurve(color: Colors.green.shade900),
                  child: WidgetIconButton(
                    color: Colors.grey.shade300,
                    size: 36,
                    pressFunc: () {},
                    iconData: Icons.search,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),
                WidgetImage(
                  path: 'images/icon2.png',
                  size: 60,
                  tapFunc: () {
                    Get.to(const ListFriend())!.then((value) {
                      appController.listFriendLoad.value = true;
                    });
                  },
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

                appController.roomModels[appController.indexBodyMainPageView.value].displayCart! ? Container(
                  decoration: AppConstant().boxCurve(color: Colors.white),
                  child: InkWell(
                    child: const WidgetImage(
                      path: 'images/basket.png',
                      size: 48,
                    ),
                    onTap: () {
                      AppBottomSheet().orderButtonSheet(
                          roomModel: appController.roomModels[
                              appController.indexBodyMainPageView.value],
                          height: boxConstraints.maxHeight * 0.35,
                          userModelLogin: appController.userModels.last);
                    },
                  ),
                ) : const SizedBox(),
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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetSqueerAvatar(
                          urlImage: appController.chatModels[index].urlAvatar,
                          size: 30,
                          pressFunc: () {
                            if (appController.chatModels[index].uidChat
                                    .toString() !=
                                appController.mainUid.toString()) {
                              Get.to(PrivateChat(
                                  uidFriend:
                                      appController.chatModels[index].uidChat));
                            }
                          },
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        SizedBox(
                          width: boxConstraints.maxWidth * 0.75 - 40,
                          child: InkWell(
                            onTap: () {
                              print('##30april you tap Bubble');
                              AppService().processLunchUrl(
                                  url: appController.chatModels[index].message);
                            },
                            child: BubbleSpecialOne(
                              text: appController.chatModels[index].message,
                              color: AppConstant.bgChat,
                              isSender: false,
                              textStyle:
                                  AppConstant().h3Style(color: Colors.black),
                            ),
                          ),
                        )
                        // Container(
                        //   constraints: BoxConstraints(
                        //       maxWidth: boxConstraints.maxWidth * 0.5 - 40),
                        //   padding: const EdgeInsets.symmetric(
                        //       vertical: 4, horizontal: 12),
                        //   margin: const EdgeInsets.only(top: 4),
                        //   // decoration: AppConstant().boxChatGuest(
                        //   //     bgColor: Colors.black.withOpacity(0.5)),
                        //   child: Text.rich(
                        //     TextSpan(
                        //         text: appController
                        //             .chatModels[index].disPlayName,
                        //         style: AppConstant().h3Style(
                        //             color: Colors.yellow,
                        //             fontWeight: FontWeight.bold),
                        //         children: [
                        //           TextSpan(
                        //               text: ' : ',
                        //               style: AppConstant().h3Style(
                        //                   color: Colors.yellow,
                        //                   fontWeight: FontWeight.bold)),
                        //           TextSpan(
                        //               text: appController
                        //                   .chatModels[index].message,
                        //               style: AppConstant()
                        //                   .h3Style(color: Colors.white))
                        //         ]),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
                appController.chatModels[index].urlRealPost.isEmpty
                    ? const SizedBox()
                    : Container(
                        margin:
                            const EdgeInsets.only(left: 36, top: 8, bottom: 8),
                        child: WidgetImageInternet(
                          urlImage: appController.chatModels[index].urlRealPost,
                          width: boxConstraints.maxWidth * 0.5 - 40,
                          // height: 80,
                          boxFit: BoxFit.cover,
                          tapFunc: () {
                            print(
                                'You tap image url ===> ${appController.chatModels[index].urlRealPost}');
                            Get.to(FullScreenImage(
                                    urlImage: appController
                                        .chatModels[index].urlRealPost))!
                                .then((value) {
                              //Check Time ว่าเป็น today ????
                              if (AppService().compareCurrentTime(
                                  otherDatetime: appController
                                      .roomModels[appController
                                          .indexBodyMainPageView.value]
                                      .timestamp
                                      .toDate())) {
                                //Status Real
                                print('##29 Status Real');
                              } else {
                                //update time post
                                print('##29 update Time post');
                                Map<String, dynamic> map = appController
                                    .roomModels[appController
                                        .indexBodyMainPageView.value]
                                    .toMap();

                                map['timestamp'] =
                                    Timestamp.fromDate(DateTime.now());
                                AppService()
                                    .processUpdateRoom(
                                        docIdRoom: appController.docIdRooms[
                                            appController
                                                .indexBodyMainPageView.value],
                                        data: map)
                                    .then((value) {
                                  // AppService().initialSetup(context: context);
                                  Restart.restartApp();
                                });
                              }
                            });
                          },
                        ),
                      )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget displayImageRoom(BoxConstraints boxConstraints,
      {required AppController appController}) {
    return ImageSlideshow(
      autoPlayInterval: appController
                  .roomModels[appController.indexBodyMainPageView.value]
                  .urlRooms
                  .length ==
              1
          ? 0
          : 5000,
      isLoop: true,
      height: appController
              .roomModels[appController.indexBodyMainPageView.value]
              .safeProduct!
          ? boxConstraints.maxHeight * 0.5
          : boxConstraints.maxHeight - 70,
      children: appController
          .roomModels[appController.indexBodyMainPageView.value].urlRooms
          .map(
            (e) => WidgetImageInternet(
              urlImage: e,
              width: boxConstraints.maxWidth,
              boxFit: BoxFit.cover,
              tapFunc: () {
                print('##18april you tab at image');
                appController.displayAll.value =
                    !appController.displayAll.value;
              },
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
                // decoration: AppConstant()
                //     .boxBlack(color: Colors.black.withOpacity(0.5)),
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
