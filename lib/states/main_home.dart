import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realpost/bodys/body_discovery.dart';
import 'package:realpost/bodys/body_me.dart';
import 'package:realpost/states/add_room.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_icon_button.dart';
import 'package:realpost/widgets/widget_text.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  var tabs = <Widget>[
    WidgetText(
      text: 'Discovery',
      textStyle: AppConstant().h2Style(),
    ),
    WidgetText(
      text: 'Me',
      textStyle: AppConstant().h2Style(),
    )
  ];

  var bodys = <Widget>[
    const BodyDiscovery(),
    const BodyMe(),
  ];

  AppController appController = Get.put(AppController());

  @override
  void initState() {
    super.initState();
    AppService().initialSetup(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
          return SizedBox(
            width: boxConstraints.maxWidth,
            height: boxConstraints.maxHeight,
            child: Stack(
              children: [
                SizedBox(
                  width: boxConstraints.maxWidth,
                  height: boxConstraints.maxHeight - 80,
                  child: const BodyDiscovery(),
                ),
                contentBottom()
              ],
            ),
          );
        }),
      ),
    );
  }

  Column contentBottom() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            WidgetIconButton(
              iconData: Icons.search_outlined,
              pressFunc: () {},
            ),
            WidgetIconButton(
              iconData: Icons.add_box_outlined,
              pressFunc: () {
                Get.to(const AddRoom());
              },
            ),
            WidgetIconButton(
              iconData: Icons.exit_to_app,
              pressFunc: () {
                AppService().processSignOut();
              },
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
