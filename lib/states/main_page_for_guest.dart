import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/widgets/widget_text.dart';

class MainPageForGuest extends StatefulWidget {
  const MainPageForGuest({super.key});

  @override
  State<MainPageForGuest> createState() => _MainPageForGuestState();
}

class _MainPageForGuestState extends State<MainPageForGuest> {
  AppController appController = Get.put(AppController());

  @override
  void initState() {
    super.initState();
    appController.readAllRoom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        print('##7june roomModels ---> ${appController.roomModels.length}');
        return WidgetText(
          text: 'Area for Geaust',
          textStyle: AppConstant().h2Style(color: Colors.black),
        );
      }),
    );
  }
}
