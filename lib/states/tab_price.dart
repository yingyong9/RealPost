// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:realpost/bodys/body_single_price.dart';
import 'package:realpost/bodys/body_total_price.dart';
import 'package:realpost/models/room_model.dart';
import 'package:realpost/models/salse_group_model.dart';
import 'package:realpost/utility/app_bottom_sheet.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_dialog.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_button.dart';
import 'package:realpost/widgets/widget_circular_image.dart';
import 'package:realpost/widgets/widget_icon_button.dart';
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
    'ซื้อคนเดียว',
    'ชวนเพื่อนมาร่วมกันซื้อ',
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
                  '##26jan at TabPriceState ----> ${appController.commentSalses.length}');
              return Stack(
                children: [
                  SizedBox(
                    height: boxConstraints.maxHeight,
                    width: boxConstraints.maxWidth,
                    child: appController.commentSalses.isEmpty
                        ? const SizedBox()
                        : Column(
                            children: [
                              SizedBox(
                                height: boxConstraints.maxHeight - 60,
                                child: ListView.builder(
                                  itemCount: appController.commentSalses.length,
                                  itemBuilder: (context, index) => Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          appController
                                              .readSalseGroups(
                                                  docIdCommentSalse: appController
                                                          .docIdCommentSalses[
                                                      index])
                                              .then((value) {
                                            print(
                                                '##28jan salseGroups --> ${appController.salsegroups.length}');

                                            var salseGrproups =
                                                <SalseGroupModel>[];
                                            for (var element
                                                in appController.salsegroups) {
                                              salseGrproups.add(element);
                                            }

                                            AppDialog(context: context)
                                                .commentDialog(
                                              roomModel:
                                                  appController.roomModels[
                                                      appController
                                                          .indexBodyMainPageView
                                                          .value],
                                              docIdCommentSalse: appController
                                                  .docIdCommentSalses[index],
                                              salseGroupModels: salseGrproups,
                                            );
                                          });
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            WidgetCircularImage(
                                                urlImage: appController
                                                    .commentSalses[index]
                                                    .urlAvatar),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 8),
                                              decoration: AppConstant()
                                                  .boxChatGuest(
                                                      bgColor:
                                                          Colors.grey.shade300),
                                              child: WidgetText(
                                                text: appController
                                                    .commentSalses[index].name,
                                                textStyle: AppConstant()
                                                    .h3Style(
                                                        color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      appController.commentSalses[index].single
                                          ? WidgetText(
                                              text:
                                                  '${appController.commentSalses[index].amountSalse} ชิ้น',
                                              textStyle: AppConstant().h3Style(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : const SizedBox(),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      const Spacer(),
                                      appController.commentSalses[index].single
                                          ? WidgetText(
                                              text:
                                                  '${appController.commentSalses[index].totalPrice} บาท',
                                              textStyle: AppConstant().h3Style(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                WidgetText(
                                                  text:
                                                      'ขาด${appController.roomModels[appController.indexBodyMainPageView.value].amountGroup}คน\n2:30',
                                                  textStyle: AppConstant()
                                                      .h3Style(
                                                          color: Colors.grey),
                                                ),
                                                const SizedBox(
                                                  width: 16,
                                                ),
                                                WidgetButton(
                                                  label: 'เข้าร่วม',
                                                  pressFunc: () {
                                                    appController
                                                        .readSalseGroups(
                                                            docIdCommentSalse:
                                                                appController
                                                                        .docIdCommentSalses[
                                                                    index])
                                                        .then((value) async {
                                                      print(
                                                          '##28jan salseGroups --> ${appController.salsegroups.length}');

                                                      var salseGrproups =
                                                          <SalseGroupModel>[];
                                                      for (var element
                                                          in appController
                                                              .salsegroups) {
                                                        salseGrproups
                                                            .add(element);
                                                      }

                                                      print(
                                                          '##28jan commentSalseGroup uid --> ${appController.commentSalses[index].uid}');

                                                      bool status = await AppService()
                                                          .checkGuest(
                                                              docIdcommentSalse:
                                                                  appController
                                                                          .docIdCommentSalses[
                                                                      index]);

                                                      if ((appController
                                                                  .commentSalses[
                                                                      index]
                                                                  .uid !=
                                                              user!.uid) &&
                                                          (roomModel!
                                                                  .uidCreate !=
                                                              user!.uid) &&
                                                          status) {
                                                        AppDialog(
                                                                context:
                                                                    context)
                                                            .salseDialog(
                                                          roomModel: appController
                                                                  .roomModels[
                                                              appController
                                                                  .indexBodyMainPageView
                                                                  .value],
                                                          docIdCommentSalse:
                                                              appController
                                                                      .docIdCommentSalses[
                                                                  index],
                                                          salseGroupModels:
                                                              salseGrproups,
                                                          userModel:
                                                              appController
                                                                  .userModels
                                                                  .last,
                                                          uidLogin: user!.uid,
                                                          docIdRoom: appController
                                                                  .docIdRooms[
                                                              appController
                                                                  .indexBodyMainPageView
                                                                  .value],
                                                        );
                                                      } else {
                                                        AppDialog(
                                                                context:
                                                                    context)
                                                            .commentDialog(
                                                          roomModel: appController
                                                                  .roomModels[
                                                              appController
                                                                  .indexBodyMainPageView
                                                                  .value],
                                                          docIdCommentSalse:
                                                              appController
                                                                      .docIdCommentSalses[
                                                                  index],
                                                          salseGroupModels:
                                                              salseGrproups,
                                                        );
                                                      }
                                                    });
                                                  },
                                                  bgColor: Colors.red,
                                                  labelStyle:
                                                      AppConstant().h3Style(),
                                                  circular: 2,
                                                ),
                                              ],
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: SizedBox(
                      width: boxConstraints.maxWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // WidgetIconButton(
                          //   iconData: Icons.filter_1,
                          //   color: Colors.grey,
                          //   pressFunc: () {},
                          // ),
                          // WidgetIconButton(
                          //   iconData: Icons.filter_2,
                          //   color: Colors.grey,
                          //   pressFunc: () {},
                          // ),
                          InkWell(
                            onTap: () {
                              if (user!.uid != roomModel!.uidCreate) {
                                AppBottomSheet().salseBottomSheet(
                                  roomModel: roomModel!,
                                  single: true,
                                  boxConstraints: boxConstraints,
                                  docIdRoom: widget.docIdRoom, context: context,
                                );
                              }
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 3),
                              decoration:
                                  const BoxDecoration(color: Colors.red),
                              child: Column(
                                children: [
                                  WidgetText(
                                    text: '${roomModel!.singlePrice!} THB',
                                    textStyle: AppConstant().h3Style(
                                        fontWeight: FontWeight.bold, size: 18),
                                  ),
                                  WidgetText(
                                    text: labels[0],
                                    textStyle: AppConstant().h3Style(
                                        fontWeight: FontWeight.bold, size: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (user!.uid != roomModel!.uidCreate) {
                                AppBottomSheet().salseBottomSheet(
                                    roomModel: roomModel!,
                                    single: false,
                                    boxConstraints: boxConstraints,
                                    docIdRoom: widget.docIdRoom, context: context);
                              }
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 3),
                              decoration:
                                  BoxDecoration(color: Colors.red.shade900),
                              child: Column(
                                children: [
                                  WidgetText(
                                    text: '${roomModel!.totalPrice!} THB',
                                    textStyle: AppConstant().h3Style(
                                        fontWeight: FontWeight.bold, size: 18),
                                  ),
                                  WidgetText(
                                    text:
                                        '${labels[1]} ${roomModel!.amountGroup} คน',
                                    textStyle: AppConstant().h3Style(
                                        fontWeight: FontWeight.bold, size: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            });
      }),
    );
  }
}
