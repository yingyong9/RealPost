// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:realpost/models/room_model.dart';
import 'package:realpost/utility/app_constant.dart';
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

  @override
  void initState() {
    super.initState();
    roomModel = widget.roomModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: TabBar(
              tabs: [
                Container(
                  
                  decoration: BoxDecoration(border: Border.all()),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      WidgetText(
                        text: '${roomModel!.singlePrice!} THB',
                        textStyle: AppConstant().h3Style(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      WidgetText(
                        text: 'ราคาซื่อ 1 ชิ้น',
                        textStyle: AppConstant().h3Style(color: Colors.grey),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    WidgetText(
                      text: '${roomModel!.totalPrice!} THB',
                      textStyle: AppConstant().h3Style(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    WidgetText(
                      text: 'ราคารวมกันซื้อ ${roomModel!.amountGroup!} ชิ้น',
                      textStyle: AppConstant().h3Style(color: Colors.grey),
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
