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
    return LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
      return Container(margin: const EdgeInsets.only(top: 8),
        width: 150,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: AppConstant().boxCurve(),
        child: WidgetText(
          text:
              'ราคา ${widget.roomModel.singlePrice} บาท เหลือเวลา ${widget.roomModel.timeGroup}',
          textStyle: AppConstant().h3Style(color: Colors.black),
        ),
      );
    });
  }
}
