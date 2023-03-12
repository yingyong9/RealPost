// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print, use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:realpost/bodys/body_single_price.dart';
import 'package:realpost/bodys/body_total_price.dart';
import 'package:realpost/models/room_model.dart';
import 'package:realpost/states/private_chat.dart';
import 'package:realpost/utility/app_bottom_sheet.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_dialog.dart';
import 'package:realpost/widgets/calculate_price_and_time.dart';
import 'package:realpost/widgets/widget_circular_image.dart';
import 'package:realpost/widgets/widget_display_price.dart';
import 'package:realpost/widgets/widget_image.dart';
import 'package:realpost/widgets/widget_text.dart';
import 'package:realpost/widgets/widget_text_button.dart';

class TabPrice extends StatefulWidget {
  const TabPrice({
    Key? key,
    required this.roomModel,
    required this.docIdRoom,
  }) : super(key: key);

  final RoomModel roomModel;
  final String docIdRoom;

  @override
  State<TabPrice> createState() => _TabPriceState();
}

class _TabPriceState extends State<TabPrice> {
  RoomModel? roomModel;

  var bodys = <Widget>[const BodySinglePrice(), const BodyTotalPrice()];

  var labels = <String>[
    'Pin',
    'ชวนเพื่อนเข้าร่วม',
  ];

  var user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    roomModel = widget.roomModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return GetX(
            init: AppController(),
            builder: (AppController appController) {
              print(
                  '##6mar at commentSalses ----> ${appController.commentSalses.length}');
              return Stack(
                children: [
                  SizedBox(
                    height: boxConstraints.maxHeight,
                    width: boxConstraints.maxWidth,
                    child: ListView(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: WidgetText(
                            text: appController
                                .roomModels[
                                    appController.indexBodyMainPageView.value]
                                .room,
                            textStyle: AppConstant().h2Style(color: Colors.red),
                          ),
                        ),
                         WidgetDisplayPrice(maxWidth: boxConstraints.maxWidth,),
                        const SizedBox(
                          height: 8,
                        ),
                        appController.commentSalses.isEmpty
                            ? const SizedBox()
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                reverse: true,
                                itemCount:
                                    appController.commentSalses.length > 2
                                        ? 2
                                        : appController.commentSalses.length,
                                itemBuilder: (context, index) => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        String uidTap = appController
                                            .commentSalses[index].uid;
                                        print('##28jan uidTap ---> $uidTap');

                                        String uidWhoSalse = appController
                                            .roomModels[appController
                                                .indexBodyMainPageView.value]
                                            .uidCreate;

                                        print(
                                            '##28jan uidWhoSalse --> $uidWhoSalse');

                                        if (user!.uid == uidWhoSalse) {
                                          print('##28jan Point Sent Chat');
                                          Get.to(
                                              PrivateChat(uidFriend: uidTap));
                                        }
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          WidgetCircularImage(
                                              urlImage: appController
                                                  .commentSalses[index]
                                                  .urlAvatar),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 8),
                                            decoration: AppConstant()
                                                .boxChatGuest(
                                                    bgColor:
                                                        Colors.grey.shade300),
                                            child: WidgetText(
                                              text: appController
                                                  .commentSalses[index].name,
                                              textStyle: AppConstant()
                                                  .h3Style(color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    CalculatePriceAndTime(
                                      roomModel: appController.roomModels[
                                          appController
                                              .indexBodyMainPageView.value],
                                      amountPin:
                                          appController.commentSalses.length,
                                      maxWidth: boxConstraints.maxWidth,
                                      docIdRoom: appController.docIdRooms[appController.indexBodyMainPageView.value],
                                    ),
                                  ],
                                ),
                              ),
                        const Divider(
                          color: Colors.black,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: WidgetText(
                            text: appController
                                    .roomModels[appController
                                        .indexBodyMainPageView.value]
                                    .detail ??
                                '',
                            textStyle:
                                AppConstant().h3Style(color: Colors.black),
                          ),
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                  contentButton(boxConstraints, context,
                      appController: appController),
                ],
              );
            });
      }),
    );
  }

  Positioned contentButton(
    BoxConstraints boxConstraints,
    BuildContext context, {
    required AppController appController,
  }) {
    print(
        '##9mar จำนวนของ Pin ===> ${appController.roomModels[appController.indexBodyMainPageView.value].amountGroup}');
    print(
        '##9mar จำนวนคนที่ช่วย Pin ===> ${appController.commentSalses.length}');
    return Positioned(
      bottom: 0,
      child: SizedBox(
        width: boxConstraints.maxWidth,
        child: Container(
          decoration: AppConstant().boxBlack(color: Colors.grey.shade300),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  if (user!.uid != roomModel!.uidCreate) {
                    // appController.haveUserLoginInComment.value
                    true
                        ? AppBottomSheet().salseBottomSheet(
                            roomModel: roomModel!,
                            single: true,
                            boxConstraints: boxConstraints,
                            docIdRoom: widget.docIdRoom,
                            context: context,
                          )
                        : AppDialog(context: context).normalDialog(
                            title: 'ยินดีต้อนรับสู่ความสนุก',
                            leadingWidget:
                                const WidgetImage(path: 'images/avatar.png'),
                            actions: [
                              WidgetTextButton(
                                text: 'เข้าร่วม',
                                pressFunc: () {
                                  Get.back();

                                  AppBottomSheet().processAddNewCommentSalse(
                                      appController.roomModels[appController
                                          .indexBodyMainPageView.value],
                                      appController,
                                      appController.docIdRooms[appController
                                          .indexBodyMainPageView.value],
                                      true,
                                      context);
                                },
                              ),
                              WidgetTextButton(
                                text: 'ยกเลิก',
                                pressFunc: () {
                                  Get.back();
                                },
                              )
                            ],
                          );
                  }
                },
                child: ((appController.haveUserLoginInComment.value) &&
                        (int.parse(appController
                                .roomModels[
                                    appController.indexBodyMainPageView.value]
                                .amountGroup!) <=
                            appController.commentSalses.length))
                    ? Container(
                        alignment: Alignment.center,
                        width: boxConstraints.maxWidth * 0.5,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        decoration: const BoxDecoration(color: Colors.red),
                        child: WidgetText(
                          text: 'ซื้อเลย',
                          textStyle: AppConstant()
                              .h3Style(fontWeight: FontWeight.bold, size: 18),
                        ),
                      )
                    : Container(
                        alignment: Alignment.center,
                        width: boxConstraints.maxWidth * 0.5,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        decoration: const BoxDecoration(color: Colors.red),
                        child: WidgetText(
                          text: 'Pin',
                          textStyle: AppConstant()
                              .h3Style(fontWeight: FontWeight.bold, size: 18),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
