// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print, sort_child_properties_last
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realpost/models/room_model.dart';

import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/utility/app_snackbar.dart';
import 'package:realpost/widgets/widget_button.dart';
import 'package:realpost/widgets/widget_content_box_white.dart';
import 'package:realpost/widgets/widget_content_box_white_row.dart';
import 'package:realpost/widgets/widget_form.dart';
import 'package:realpost/widgets/widget_icon_button.dart';
import 'package:realpost/widgets/widget_text.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String? name, detail, singlePrice, totalPrice, amountGroup, stock;
  var user = FirebaseAuth.instance.currentUser;

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
              print(
                  '##16jan chooseTimeGrup --> ${appController.chooseTimeGroups.length}');
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () =>
                    FocusScope.of(context).requestFocus(FocusScopeNode()),
                child: SizedBox(
                  width: boxConstraints.maxWidth,
                  height: boxConstraints.maxHeight,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: boxConstraints.maxWidth,
                        height: boxConstraints.maxHeight - 64,
                        child: ListView(
                          children: [
                            contentImage(boxConstraints, appController),
                            contentName(boxConstraints),
                            contentDetail(boxConstraints),
                            bottonSalse(appController),
                            contentGroup(
                                appController: appController,
                                boxConstraints: boxConstraints),
                            contentAddForm(
                                appController: appController,
                                boxConstraints: boxConstraints,
                                title: 'ราคาขาย',subHead: 'ราคาตั้งก่อนลด',
                                contentWidget: WidgetForm(
                                  width: boxConstraints.maxWidth * 0.5,
                                  textInputType: TextInputType.number,
                                  textAlign: TextAlign.end,
                                  changeFunc: (p0) {
                                    singlePrice = p0.trim();
                                  },
                                )),
                            contentAddForm(
                                appController: appController,
                                boxConstraints: boxConstraints,
                                title: 'ส่วนลด',subHead: 'ต่อผู้เข้าร่วมเข้าร่วม 5 คน',
                                contentWidget: WidgetForm(
                                  width: boxConstraints.maxWidth * 0.5,
                                  textInputType: TextInputType.number,
                                  textAlign: TextAlign.end,
                                  changeFunc: (p0) {
                                    totalPrice = p0.trim();
                                  },
                                )),
                          
                            contentAddForm(
                                appController: appController,
                                boxConstraints: boxConstraints,
                                title: 'จำนวนสินค้าที่จะขาย',
                                contentWidget: WidgetForm(
                                  width: boxConstraints.maxWidth * 0.5,
                                  textInputType: TextInputType.number,
                                  textAlign: TextAlign.end,
                                  changeFunc: (p0) {
                                    stock = p0.trim();
                                  },
                                )),
                            contentSetTime(
                                appController: appController,
                                boxConstraints: boxConstraints),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          width: boxConstraints.maxWidth,
                          child: WidgetButton(
                            label: 'เผยแพร่',
                            pressFunc: () async {
                              if (appController.xFiles.isEmpty) {
                                print('##16jan No Image');
                                AppSnackBar().normalSnackBar(
                                    title: 'No Image',
                                    message: 'Please Get Image');
                              } else if (name?.isEmpty ?? true) {
                                AppSnackBar().normalSnackBar(
                                    title: 'ไม่มีชื่อ',
                                    message: 'กรุณากรอกชื่อ');
                              } else {
                                if (appController.safseProduct.value) {
                                  //สถานะของการขายของด้วย
                                  print('##16jan ขายสินค้าด้วย');
                                  if (appController.chooseGroupProducts.last ==
                                      null) {
                                    AppSnackBar().normalSnackBar(
                                        title: 'ไม่ม่หมวดหมู่',
                                        message: 'กรุณาเลือกหมวดหมู่');
                                  } else if (singlePrice?.isEmpty ?? true) {
                                    AppSnackBar().normalSnackBar(
                                        title: 'ราคาขาย ?',
                                        message: 'กรุณากรอก ราคา');
                                  } else if (totalPrice?.isEmpty ?? true) {
                                    AppSnackBar().normalSnackBar(
                                        title: 'ส่วนลด ?',
                                        message: 'กรุณากรอก ราคา');
                                  } else  {
                                    //ขายของ
                                    var urlRooms = await AppService()
                                        .processUploadMultiPhoto(
                                            path: 'product');
                                    print(
                                        '##19jan urlRooms at ขายของ --> $urlRooms');

                                    RoomModel roomModel = AppService()
                                        .createRoomModel(
                                            uidCreate: user!.uid,
                                            room: name!,
                                            timestamp: Timestamp.fromDate(
                                                DateTime.now()),
                                            urlCamera: '',
                                            urlRooms: urlRooms,
                                            detail: detail ?? '',
                                            safeProduct: appController
                                                .safseProduct.value,
                                            groupProduct: appController
                                                    .chooseGroupProducts.last ??
                                                '',
                                            singlePrice: singlePrice ?? '',
                                            totalPrice: totalPrice ?? '',
                                            amountGroup: amountGroup ?? '',
                                            stock: stock ?? '',
                                            timeGroup: appController
                                                .chooseTimeGroups.last);

                                    print(
                                        '##6feb ขายของ roomModel --> ${roomModel.toMap()}');

                                    await AppService()
                                        .processInsertRoom(roomModel: roomModel)
                                        .then((value) {
                                      Get.back();
                                    });
                                  }
                                } else {
                                  //ไม่ได้ขายของ
                                  print('##16jan ไม่ขายสินค้าด้วย');
                                  var urlRooms = await AppService()
                                      .processUploadMultiPhoto(path: 'product');
                                  print(
                                      '##19jan urlRooms at ไม่ขายของ --> $urlRooms');

                                  RoomModel roomModel = AppService()
                                      .createRoomModel(
                                          uidCreate: user!.uid,
                                          room: name!,
                                          timestamp: Timestamp.fromDate(
                                              DateTime.now()),
                                          urlCamera: '',
                                          urlRooms: urlRooms,
                                          detail: detail ?? '',
                                          safeProduct:
                                              appController.safseProduct.value,
                                          groupProduct: appController
                                                  .chooseGroupProducts.last ??
                                              '',
                                          singlePrice: singlePrice ?? '',
                                          totalPrice: totalPrice ?? '',
                                          amountGroup: amountGroup ?? '',
                                          stock: stock ?? '',
                                          timeGroup: appController
                                              .chooseTimeGroups.last);

                                  print(
                                      '##19jan ไม่ขายของ roomModel --> ${roomModel.toMap()}');
                                  await AppService()
                                      .processInsertRoom(roomModel: roomModel)
                                      .then((value) {
                                    AppService().initialSetup(context: context);
                                    Get.back();
                                  });
                                }
                              }
                            },
                            bgColor: const Color.fromARGB(255, 51, 67, 209),
                            circular: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      }),
    );
  }

  Widget contentAddForm(
      {required AppController appController,
      required BoxConstraints boxConstraints,
      required String title,
      required Widget contentWidget,
      String? subHead}) {
    return appController.safseProduct.value
        ? WidgetContenBoxWhiteRow(
            head: title,
            width: boxConstraints.maxWidth,
            contentWidget: contentWidget,
            subHead: subHead,
          )
        : const SizedBox();
  }

  Widget contentGroup(
      {required AppController appController,
      required BoxConstraints boxConstraints}) {
    return appController.safseProduct.value
        ? WidgetContenBoxWhiteRow(
            head: 'หมวดหมู่',
            width: boxConstraints.maxWidth,
            contentWidget: DropdownButton(
              items: appController.groupProductModels
                  .map(
                    (element) => DropdownMenuItem(
                      child: WidgetText(
                        text: element.nameGroup,
                        textStyle: AppConstant().h3Style(color: Colors.black),
                      ),
                      value: element.nameGroup,
                    ),
                  )
                  .toList(),
              value: appController.chooseGroupProducts.last,
              hint: WidgetText(
                text: 'โปรดเลือกหมวดหมู่',
                textStyle: AppConstant().h3Style(color: Colors.black),
              ),
              onChanged: (value) {
                appController.chooseGroupProducts.add(value);
              },
            ),
          )
        : const SizedBox();
  }

  Widget contentSetTime(
      {required AppController appController,
      required BoxConstraints boxConstraints}) {
    return appController.safseProduct.value
        ? WidgetContenBoxWhiteRow(
            head: 'กำหนดเวลา',
            width: boxConstraints.maxWidth,
            contentWidget: DropdownButton(
              items: appController.timeGroupModels
                  .map(
                    (element) => DropdownMenuItem(
                      child: WidgetText(
                        text: element.times,
                        textStyle: AppConstant().h3Style(color: Colors.black),
                      ),
                      value: element.times,
                    ),
                  )
                  .toList(),
              value: appController.chooseTimeGroups.last,
              hint: WidgetText(
                text: 'โปรดเลือกกำหนดเวลา',
                textStyle: AppConstant().h3Style(color: Colors.black),
              ),
              onChanged: (value) {
                appController.chooseTimeGroups.add(value!);
              },
            ),
          )
        : const SizedBox();
  }

  Row bottonSalse(AppController appController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WidgetButton(
          label: 'ขายสินค้า',
          pressFunc: () {
            appController.safseProduct.value =
                !appController.safseProduct.value;

            if (appController.chooseGroupProducts.isNotEmpty) {
              appController.chooseGroupProducts.clear();
              appController.chooseGroupProducts.add(null);
            }
          },
          bgColor: Colors.white,
          textColor: Colors.black,
        ),
      ],
    );
  }

  WidgetContenBoxWhite contentDetail(BoxConstraints boxConstraints) {
    return WidgetContenBoxWhite(
      head: 'คำอธิบาย',
      width: boxConstraints.maxWidth,
      contentWidget: WidgetForm(
        hint: 'รายละเอียด',
        changeFunc: (p0) {
          detail = p0.trim();
        },
      ),
    );
  }

  WidgetContenBoxWhite contentName(BoxConstraints boxConstraints) {
    return WidgetContenBoxWhite(
      head: 'ชื่อ',
      width: boxConstraints.maxWidth,
      contentWidget: WidgetForm(
        hint: 'กรอกชื่อ',
        changeFunc: (p0) {
          name = p0.trim();
        },
      ),
    );
  }

  WidgetContenBoxWhite contentImage(
      BoxConstraints boxConstraints, AppController appController) {
    return WidgetContenBoxWhite(
      head: 'ภาพ',
      width: boxConstraints.maxWidth,
      contentWidget: SizedBox(
        height: 80,
        child: ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: [
            appController.xFiles.isEmpty
                ? const SizedBox()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 70,
                        child: ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: appController.xFiles.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 4),
                                width: 70,
                                height: 70,
                                child: Image.file(
                                  File(appController.xFiles[index].path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: WidgetIconButton(
                                  iconData: Icons.disabled_by_default,
                                  color: Colors.white54,
                                  padding: 1,
                                  pressFunc: () {
                                    print(
                                        '##16jan you delete index --> $index');
                                    appController.xFiles.removeAt(index);
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
            cardImage(string: '${appController.xFiles.length}/9'),
          ],
        ),
      ),
    );
  }

  Widget cardImage({required String string}) {
    return InkWell(
      onTap: () {
        AppService().processChooseMultiImage();
      },
      child: SizedBox(
        width: 80,
        height: 80,
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
      ),
    );
  }
}
