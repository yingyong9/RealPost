import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realpost/models/room_model.dart';
import 'package:realpost/states/add_product.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_button.dart';
import 'package:realpost/widgets/widget_image.dart';
import 'package:realpost/widgets/widget_image_internet.dart';
import 'package:realpost/widgets/widget_text.dart';

class AppBottomSheet {
  void salseBottomSheet(
      {required RoomModel roomModel,
      required bool single,
      required BoxConstraints boxConstraints}) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              // topLeft: Radius.circular(30),
              // topRight: Radius.circular(30),
              ),
        ),
        height: 120,
        child: ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: WidgetImageInternet(
                    urlImage: roomModel.urlRooms.last,
                    width: 100,
                    height: 100,
                    boxFit: BoxFit.cover,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  height: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WidgetText(
                        text: AppService()
                            .cutWord(string: roomModel.room, word: 25),
                        textStyle: AppConstant().h2Style(color: Colors.black),
                      ),
                      SizedBox(
                        width: boxConstraints.maxWidth - 90,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            WidgetText(
                              text: AppService()
                                  .cutWord(string: roomModel.detail!, word: 25),
                              textStyle:
                                  AppConstant().h3Style(color: Colors.black),
                            ),
                            WidgetButton(
                              label: 'ซื้อ',
                              pressFunc: () {},
                              bgColor: Colors.red.shade700,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: boxConstraints.maxWidth - 100,
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            WidgetText(
                              text: '฿${roomModel.singlePrice!}',
                              textStyle: AppConstant()
                                  .h2Style(color: Colors.red.shade700),
                            ),
                            WidgetText(
                              text: 'จำนวน',
                              textStyle: AppConstant()
                                  .h3Style(color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void productBottomSheet({required BoxConstraints boxConstraints}) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        height: boxConstraints.maxHeight * 0.8,
        width: boxConstraints.maxWidth,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              child: SizedBox(
                width: boxConstraints.maxWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(const AddProduct());
                      },
                      child: WidgetImage(
                        path: 'images/addgreen.png',
                        size: 36,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
