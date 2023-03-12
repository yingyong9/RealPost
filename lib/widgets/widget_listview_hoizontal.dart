// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:realpost/models/room_model.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/widgets/widget_image_internet.dart';

class WidgetListViewHorizontal extends StatefulWidget {
  const WidgetListViewHorizontal({
    Key? key,
    required this.roomModel,
  }) : super(key: key);

  final RoomModel roomModel;

  @override
  State<WidgetListViewHorizontal> createState() =>
      _WidgetListViewHorizontalState();
}

class _WidgetListViewHorizontalState extends State<WidgetListViewHorizontal> {
  AppController controller = Get.put(AppController());

  @override
  void initState() {
    super.initState();

    if (controller.tabChooses.isNotEmpty) {
      controller.tabChooses.clear();
    }

    for (var i = 0; i < widget.roomModel.urlRooms.length; i++) {
      controller.tabChooses.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print('tabChooses ---> ${appController.tabChooses.length}');
          return SizedBox(
            height: 100,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: widget.roomModel.urlRooms.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Container(
                decoration: appController.tabChooses[index]
                    ? AppConstant().boxCurve()
                    : null,
                padding: const EdgeInsets.all(4.0),
                child: WidgetImageInternet(
                  urlImage: widget.roomModel.urlRooms[index],
                  width: 100,
                  height: 100,
                  boxFit: BoxFit.cover,
                  tapFunc: () {
                    print('You tap index ---> $index');

                    int i = 0;
                    for (var element in appController.tabChooses) {
                      if (element) {
                        appController.tabChooses[i] = false;
                      }
                      i++;
                    }

                    appController.tabChooses[index] = true;
                  },
                ),
              ),
            ),
          );
        });
  }
}
