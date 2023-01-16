// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_content_box_white.dart';
import 'package:realpost/widgets/widget_text.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgGrey,
      appBar: AppBar(
        backgroundColor: AppConstant.bgGrey,
        foregroundColor: Colors.black,
      ),
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return GetX(
            init: AppController(),
            builder: (AppController appController) {
              print('##16jan xfiles --> ${appController.xFiles.length}');
              return ListView(
                children: [
                  WidgetContenBoxWhite(
                    head: 'ภาพ',
                    width: boxConstraints.maxWidth,
                    contentWidget: SizedBox(
                      width: 80,
                      height: 80,
                      child: cardImage(string: '0/9'),
                    ),
                  ),
                  WidgetContenBoxWhite(
                    head: 'ชื่อ',
                    width: boxConstraints.maxWidth,
                    contentWidget: const SizedBox(),
                  ),
                  WidgetContenBoxWhite(
                    head: 'คำอธิบาย',
                    width: boxConstraints.maxWidth,
                    contentWidget: const SizedBox(),
                  ),
                ],
              );
            });
      }),
    );
  }

  InkWell cardImage({required String string}) {
    return InkWell(
      onTap: () {
        AppService().processChooseMultiImage();
      },
      child: Card(
        color: AppConstant.bgGrey,
        elevation: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: AppConstant.grey,
              size: 36,
            ),
            WidgetText(
              text: string,
              textStyle: AppConstant().h3Style(color: AppConstant.grey),
            ),
          ],
        ),
      ),
    );
  }
}
