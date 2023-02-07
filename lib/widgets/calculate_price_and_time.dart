// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:realpost/models/room_model.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/widgets/widget_text.dart';

class CalculatePriceAndTime extends StatefulWidget {
  const CalculatePriceAndTime({
    Key? key,
    required this.roomModel,
  }) : super(key: key);

  final RoomModel roomModel;

  @override
  State<CalculatePriceAndTime> createState() => _CalculatePriceAndTimeState();
}

class _CalculatePriceAndTimeState extends State<CalculatePriceAndTime> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WidgetText(
          text: 'ราคา ${widget.roomModel.singlePrice} บาท',
          textStyle: AppConstant().h3Style(color: Colors.black),
        ),
         WidgetText(
          text: 'เหลือเวลา ${widget.roomModel.timeGroup} ',
          textStyle: AppConstant().h3Style(color: Colors.black),
        ),
        WidgetText(
          text: 'ผู้ที่กดเข้าร่วม 1 ',
          textStyle: AppConstant().h3Style(color: Colors.black),
        ),
      ],
    );
  }
}
