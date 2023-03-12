// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:realpost/models/comment_salse_model.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_dialog.dart';
import 'package:realpost/widgets/widget_icon_button.dart';
import 'package:realpost/widgets/widget_text.dart';

class WidgetDisplayPrice extends StatelessWidget {
  const WidgetDisplayPrice({
    Key? key,
    required this.maxWidth,
  }) : super(key: key);

  final double maxWidth;

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
                        child: WidgetText(
                          text:
                              'ราคา ${appController.roomModels[appController.indexBodyMainPageView.value].singlePrice!} thb     เหลือเวลา 24.00.00',
                          textStyle: AppConstant().h2Style(color: Colors.red),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 16),
                        decoration: AppConstant().boxBlack(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: WidgetIconButton(
                                    pressFunc: () {
                                      var commentSalses = <CommentSalseModel>[];
                                      for (var element
                                          in appController.commentSalses) {
                                        commentSalses.add(element);
                                      }

                                      AppDialog(context: context)
                                          .dialogCommentSalse(
                                              commentSalseModels: commentSalses,
                                              roomModel:
                                                  appController.roomModels[
                                                      appController
                                                          .indexBodyMainPageView
                                                          .value], maxWidth: maxWidth, docIdRoom: appController.docIdRooms[appController.indexBodyMainPageView.value]);
                                    },
                                    iconData: Icons.person,
                                    // padding: 1,
                                    color: Colors.black,
                                  ),
                                ),
                                WidgetText(
                                  text: appController.commentSalses.length
                                      .toString(),
                                  textStyle: AppConstant()
                                      .h3Style(color: Colors.black),
                                ),
                              ],
                            ),
                            WidgetText(
                              text:
                                  'Pin ${appController.roomModels[appController.indexBodyMainPageView.value].amountGroup}',
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
