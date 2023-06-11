// ignore_for_file: avoid_print, sort_child_properties_last, prefer_const_constructors, avoid_unnecessary_containers

import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:realpost/models/chat_model.dart';
import 'package:realpost/models/room_model.dart';
import 'package:realpost/states/add_product.dart';
import 'package:realpost/states/comment_chat.dart';
import 'package:realpost/states/display_profile.dart';
import 'package:realpost/states/list_friend.dart';
import 'package:realpost/states/private_chat.dart';
import 'package:realpost/states/tab_price.dart';
import 'package:realpost/utility/app_bottom_sheet.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_amount_comment.dart';
import 'package:realpost/widgets/widget_button.dart';
import 'package:realpost/widgets/widget_circular_image.dart';
import 'package:realpost/widgets/widget_content_form_spcial.dart';
import 'package:realpost/widgets/widget_display_up.dart';
import 'package:realpost/widgets/widget_icon_button.dart';
import 'package:realpost/widgets/widget_image.dart';
import 'package:realpost/widgets/widget_image_internet.dart';
import 'package:realpost/widgets/widget_progress_animation.dart';
import 'package:realpost/widgets/widget_squeer_avatar.dart';
import 'package:realpost/widgets/widget_text.dart';
import 'package:badges/badges.dart' as badges;

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

    AppService().initialSetup(context: context).then((value) {
      // Get.to(CommentChat(
      //                     docIdChat: controller.docIdChats[0],
      //                     chatModel: controller.chatModels[0],
      //                     index: 0,
      //                   ));
    });
    AppService().aboutNoti(context: context);
    AppService().freshUserModelLogin();
    AppService().readStatData();

   
  }

  

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
      return Scaffold(
          backgroundColor: AppConstant.bgColor,
          body: GetX(
              init: AppController(),
              builder: (AppController appController) {
                print(
                    '##26may statDataModel ---> ${appController.statDataModels.length}');

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
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: boxConstraints.maxHeight - 100,
                                    child: displayListMessage(
                                        boxConstraints, appController),
                                  ),
                                  rightMenu(controller,
                                      boxConstraints: boxConstraints),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: const [
                                      WidgetContentFormSpcial(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                );
              }));
    });
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
        // displayRealText(appController: appController),
        // displayRoomText(appController, boxConstraints),
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
            // decoration:
            //     AppConstant().boxChatGuest(bgColor: Colors.grey.shade700),
            width: boxConstraints.maxWidth * 0.6,
            // child: BubbleSpecialOne(
            //   text: appController
            //       .roomModels[appController.indexBodyMainPageView.value].room,
            //   textStyle: AppConstant().h3Style(color: Colors.black),
            //   isSender: false,
            //   color: AppConstant.bgChat,
            // ),
            child: WidgetText(
                text: appController
                    .roomModels[appController.indexBodyMainPageView.value]
                    .room),
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
          )
        : const SizedBox();
  }

  Widget rightMenu(AppController appController,
      {required BoxConstraints boxConstraints}) {
    var widgets = <Widget>[
      firstMenu(),
      // secondMenu(),
      // thirdMenu(),
      // forthMenu(appController: appController),
      // fifMenu(appController: appController),
      // sixMenu(boxConstraints: boxConstraints),
    ];

    return Positioned(
      // right: 0,
      // top: 70,
      child: DropdownButton(
        elevation: 0,
        underline: const SizedBox(),
        iconSize: 0.0,
        dropdownColor: AppConstant.bgColor,
        items: widgets
            .map(
              (e) => DropdownMenuItem(
                child: e,
                value: e,
              ),
            )
            .toList(),
        hint: Container(
         
          child: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
        value: null,
        onChanged: (value) {},
      ),
    );
  }

  Widget firstMenu() {
    return controller.displayAddFriends[controller.indexBodyMainPageView.value]
        ? badges.Badge(
            badgeStyle: badges.BadgeStyle(badgeColor: Colors.red.shade700),
            position: badges.BadgePosition.bottomEnd(end: 10, bottom: -12),
            badgeContent: const Icon(
              Icons.add,
              size: 20,
              color: Colors.white,
            ),
            child: Container(
              decoration: AppConstant().boxCurve(color: Colors.white),
              child: WidgetImageInternet(
                urlImage: controller
                    .userModelAtRooms[controller.indexBodyMainPageView.value]
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
              String uidFriend = controller
                  .roomModels[controller.indexBodyMainPageView.value].uidCreate;

              AppService()
                  .processAddFriend(uidFriend: uidFriend)
                  .then((value) async {
                print('##19april You tab add uidFried --> $uidFriend success');
                controller.displayAddFriends.clear();
                for (var element in controller.roomModels) {
                  controller.displayAddFriends.add(await AppService()
                      .findPatnerFriend(uidCheckFriend: element.uidCreate));
                }
              });
            },
          )
        : Container(
            decoration: AppConstant().boxCurve(color: Colors.white),
            child: WidgetImageInternet(
              urlImage: controller
                  .userModelAtRooms[controller.indexBodyMainPageView.value]
                  .urlAvatar!,
              width: 48,
              height: 48,
              boxFit: BoxFit.cover,
              tapFunc: () {
                Get.to(const DisplayProfile());
              },
            ),
          );
  }

  Widget secondMenu() {
    return controller.roomModels[controller.indexBodyMainPageView.value]
                .geoPoint!.latitude ==
            0
        ? const SizedBox()
        : Container(
            decoration: AppConstant().boxCurve(color: Colors.green.shade900),
            child: WidgetIconButton(
              color: Colors.grey.shade300,
              size: 36,
              pressFunc: () {
                GeoPoint geoPoint = controller
                    .roomModels[controller.indexBodyMainPageView.value]
                    .geoPoint!;
                String url =
                    'https://www.google.com/maps/search/?api=1&query=${geoPoint.latitude},${geoPoint.longitude}';
                AppService().processLunchUrl(url: url);
              },
              iconData: Icons.pin_drop,
            ),
          );
  }

  Widget sixMenu({required BoxConstraints boxConstraints}) {
    return controller
            .roomModels[controller.indexBodyMainPageView.value].displayCart!
        ? Container(
            decoration: AppConstant().boxCurve(color: Colors.white),
            child: InkWell(
              child: const WidgetImage(
                path: 'images/basket.png',
                size: 48,
              ),
              onTap: () {
                AppBottomSheet().orderButtonSheet(
                    roomModel: controller
                        .roomModels[controller.indexBodyMainPageView.value],
                    height: boxConstraints.maxHeight * 0.35,
                    userModelLogin: controller.userModels.last);
              },
            ),
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
                firstMenu(),
                const SizedBox(
                  height: 8,
                ),
                secondMenu(),
                const SizedBox(
                  height: 8,
                ),
                thirdMenu(),
                const SizedBox(
                  height: 8,
                ),
                forthMenu(appController: appController),
                fifMenu(appController: appController),
                const SizedBox(
                  height: 8,
                ),
                sixMenu(boxConstraints: boxConstraints)
              ],
            ),
          );
  }

  Container fifMenu({required AppController appController}) {
    return Container(
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
    );
  }

  WidgetImage forthMenu({required AppController appController}) {
    return WidgetImage(
      path: 'images/icon2.png',
      size: 60,
      tapFunc: () {
        Get.to(const ListFriend())!.then((value) {
          appController.listFriendLoad.value = true;
        });
      },
    );
  }

  Container thirdMenu() {
    return Container(
      decoration: AppConstant().boxCurve(color: Colors.green.shade900),
      child: WidgetIconButton(
        color: Colors.grey.shade300,
        size: 36,
        pressFunc: () {},
        iconData: Icons.search,
      ),
    );
  }

  Widget displayRealText({required AppController appController}) {
    return Positioned(
      right: 8,
      child: Column(
        children: [
          AppService().compareCurrentTime(
                  otherDatetime: appController
                      .roomModels[appController.indexBodyMainPageView.value]
                      .timestamp
                      .toDate())
              ? Container(
                  padding: const EdgeInsets.all(8),
                  child: WidgetText(
                    text: '  Real  ',
                    textStyle:
                        AppConstant().h2Style(color: Colors.red.shade700),
                  ),
                )
              : const SizedBox(),
          appController.roomModels[appController.indexBodyMainPageView.value]
                  .roomPublic
              ? WidgetText(text: 'สาธารณะ')
              : const SizedBox(),
        ],
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
                print('##25may you tap Bubble');
                AppService().processLunchUrl(
                    url: appController.chatModels[index].message);
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
                      print('##26may you click');
                      AppService()
                          .increaseValueGraph(
                              docIdChat: appController.docIdChats[index],
                              chatModel: appController.chatModels[index])
                          .then((value) {
                        Get.to(CommentChat(
                         
                        ));
                      });
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

  WidgetSqueerAvatar displayAvatarPost(AppController appController, int index) {
    return WidgetSqueerAvatar(
      urlImage: appController.chatModels[index].urlAvatar,
      size: 30,
      pressFunc: () {
        if (appController.chatModels[index].uidChat.toString() !=
            appController.mainUid.toString()) {
          if (appController
              .roomModels[appController.indexBodyMainPageView.value]
              .roomPublic) {
            //Public
            Get.to(PrivateChat(
                uidFriend: appController.chatModels[index].uidChat));
          } else {
            //Private
            if (appController.chatModels[index].uidChat ==
                appController
                    .roomModels[appController.indexBodyMainPageView.value]
                    .uidCreate) {
              Get.to(PrivateChat(
                  uidFriend: appController.chatModels[index].uidChat));
            }
          }
        }
      },
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
