import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/widgets/widget_text.dart';

class WidgetDisplayPrice extends StatelessWidget {
  const WidgetDisplayPrice({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
      return GetX(
          init: AppController(),
          builder: (AppController appController) {
            print('appController --> ${appController.roomModels.length}');
            return appController
                    .roomModels[appController.indexBodyMainPageView.value]
                    .safeProduct!
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(mainAxisSize: MainAxisSize.min,
                              children: [
                                WidgetText(
                                  text:
                                      'ราคา ${appController.roomModels[appController.indexBodyMainPageView.value].singlePrice!}',
                                  textStyle: AppConstant().h2Style(color: Colors.red),
                                ),
                                WidgetText(
                                  text: appController.roomModels[appController.indexBodyMainPageView.value].minPrice!.isEmpty ? ' thb' : 
                                      ' - ${appController.roomModels[appController.indexBodyMainPageView.value].minPrice} thb',
                                  textStyle: AppConstant().h2Style(color: Colors.red),
                                ),
                              ],
                            ),
                            WidgetText(
                              text:
                                  'ลด ${appController.roomModels[appController.indexBodyMainPageView.value].totalPrice} thb/ 5 คน',
                              textStyle: AppConstant()
                                  .h3Style(color: Colors.green.shade900),
                            ),
                          ],
                        ),
                      ),
                      Container(padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                        decoration: AppConstant().boxBlack(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            WidgetText(
                              text:
                                  'จำนวนผู้เข้าร่วม ${appController.commentSalses.length} คน ',
                              textStyle:
                                  AppConstant().h3Style(color: Colors.black),
                            ),
                            WidgetText(
                              text:
                                  'Stock ${appController.roomModels[appController.indexBodyMainPageView.value].stock}',
                              textStyle:
                                  AppConstant().h3Style(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox();
          });
    });
  }
}
