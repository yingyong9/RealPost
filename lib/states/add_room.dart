import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realpost/models/room_model.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_form.dart';
import 'package:realpost/widgets/widget_text.dart';
import 'package:realpost/widgets/widget_text_button.dart';

class AddRoom extends StatefulWidget {
  const AddRoom({super.key});

  @override
  State<AddRoom> createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  String? room;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      appBar: AppBar(
        title: WidgetText(text: 'ยินดีต้อนรับ สู่การสร้าง Real Post Room'),
      ),
      body: Center(
        child: Column(
          children: [
            const Divider(
              color: Colors.grey,
            ),
            WidgetForm(
              changeFunc: (p0) {
                room = p0.trim();
              },
              hint: 'กรอก ชื่อที่ คุณต้องการ',
              hintStyle: AppConstant().h3Style(
                color: AppConstant.grey,
                size: 24,
              ),
              width: 250,
              textStyle: AppConstant().h3Style(size: 24),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: AppConstant.grey))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WidgetTextButton(
                    text: '+ คลิกสร้าง',
                    pressFunc: () async {
                      if (room?.isEmpty ?? true) {
                        //Have Space
                      } else {
                        var user = FirebaseAuth.instance.currentUser;
                        RoomModel roomModel =
                            RoomModel(uidCreate: user!.uid, room: room!);
                        await AppService()
                            .processInsertRoom(roomModel: roomModel)
                            .then((value) => Get.back());
                      }
                    },
                    color: Colors.grey.shade400,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
