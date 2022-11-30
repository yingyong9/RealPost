// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/widgets/widget_text.dart';

class BodyDiscovery extends StatefulWidget {
  const BodyDiscovery({super.key});

  @override
  State<BodyDiscovery> createState() => _BodyDiscoveryState();
}

class _BodyDiscoveryState extends State<BodyDiscovery> {
  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print('##27nov roomModels ==> ${appController.roomModels}');
          return appController.roomModels.isEmpty ? WidgetText(text: 'load') : WidgetText(text: 'This is Discovery') ;
        });
  }
}
