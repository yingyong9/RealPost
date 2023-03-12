// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:realpost/models/room_model.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/widgets/widget_button.dart';
import 'package:realpost/widgets/widget_text.dart';

class CalculatePriceAndTime extends StatefulWidget {
  const CalculatePriceAndTime({
    Key? key,
    required this.roomModel,
    required this.amountPin,
    required this.maxWidth,
  }) : super(key: key);

  final RoomModel roomModel;
  final int amountPin;
  final double maxWidth;

  @override
  State<CalculatePriceAndTime> createState() => _CalculatePriceAndTimeState();
}

class _CalculatePriceAndTimeState extends State<CalculatePriceAndTime> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
      print('##9mar maxWidth ---> ${widget.maxWidth}');
      return Container(
        margin: const EdgeInsets.only(top: 8),
        width: 200,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 200,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  WidgetText(
                      text:
                          'เหลือ ${int.parse(widget.roomModel.amountGroup!) - widget.amountPin} คน',
                      textStyle: AppConstant().h3Style(color: Colors.black)),
                  const Spacer(),
                  WidgetButton(
                   label: 'ซื้อเลย',
                    pressFunc: () {
                      
                    },
                    bgColor: Colors.red.shade700,
                  )
                ],
              ),
            ),
            // const Divider(color: Colors.black,),
          ],
        ),
      );
    });
  }
}
