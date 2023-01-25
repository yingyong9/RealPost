// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:realpost/bodys/body_single_price.dart';
import 'package:realpost/bodys/body_total_price.dart';

import 'package:realpost/models/room_model.dart';
import 'package:realpost/utility/app_bottom_sheet.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_dialog.dart';
import 'package:realpost/widgets/widget_button.dart';
import 'package:realpost/widgets/widget_icon_button.dart';
import 'package:realpost/widgets/widget_text.dart';

class TabPrice extends StatefulWidget {
  const TabPrice({
    Key? key,
    required this.roomModel,
  }) : super(key: key);

  final RoomModel roomModel;

  @override
  State<TabPrice> createState() => _TabPriceState();
}

class _TabPriceState extends State<TabPrice> {
  RoomModel? roomModel;

  var bodys = <Widget>[const BodySinglePrice(), const BodyTotalPrice()];

  var labels = <String>[
    'ซื้อคนเดียว',
    'ร่วมกันซื้อ',
  ];

  @override
  void initState() {
    super.initState();
    roomModel = widget.roomModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
          initialIndex: 0,
          length: 2,
          child:
              LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
            return Scaffold(
              appBar: TabBar(
                onTap: (value) {
                  print('##24jan index tab --> $value');
                },
                tabs: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      WidgetText(
                        text: '${roomModel!.singlePrice!} THB',
                        textStyle: AppConstant().h3Style(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      WidgetText(
                        text: 'ราคาซื่อคนเดียว',
                        textStyle: AppConstant().h3Style(color: Colors.grey),
                      )
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      WidgetText(
                        text: '${roomModel!.totalPrice!} THB',
                        textStyle: AppConstant().h3Style(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      WidgetText(
                        text: 'ราคารวมกันซื้อ ${roomModel!.amountGroup!} คน',
                        textStyle: AppConstant().h3Style(color: Colors.grey),
                      )
                    ],
                  ),
                ],
              ),
              body: Stack(
                children: [
                  // SizedBox(
                  //   // height: 150,
                  //   child: TabBarView(children: bodys),
                  // ),
                  Positioned(
                    bottom: 0,
                    child: SizedBox(
                      width: boxConstraints.maxWidth,
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WidgetIconButton(
                            iconData: Icons.filter_1,
                            color: Colors.grey,
                            pressFunc: () {},
                          ),
                          WidgetIconButton(
                            iconData: Icons.filter_2,
                            color: Colors.grey,
                            pressFunc: () {},
                          ),

                          InkWell(
                            onTap: () {
                              print('##24jan click tap');
                              AppBottomSheet().salseBottomSheet(roomModel: roomModel!, single: true, boxConstraints: boxConstraints);
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
                          InkWell(onTap: () {
                             AppBottomSheet().salseBottomSheet(roomModel: roomModel!, single: false, boxConstraints: boxConstraints);
                          },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 3),
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
                          // WidgetButton(
                          //   label: labels[1],
                          //   pressFunc: () {},
                          //   bgColor: Colors.red.shade800,
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          })),
    );
  }
}
