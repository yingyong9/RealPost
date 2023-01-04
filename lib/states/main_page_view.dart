// ignore_for_file: avoid_print, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_circular_image.dart';
import 'package:realpost/widgets/widget_image_internet.dart';
import 'package:realpost/widgets/widget_text.dart';

class MainPageView extends StatefulWidget {
  const MainPageView({super.key});

  @override
  State<MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
  AppController controller = Get.put(AppController());

  @override
  void initState() {
    super.initState();
    AppService().initialSetup(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return GetX(
            init: AppController(),
            builder: (AppController appController) {
              print('##3jan roomModels --> ${appController.roomModels.length}');
              return SafeArea(
                child: appController.roomModels.isEmpty
                    ? const SizedBox()
                    : PageView(
                        children: appController.roomModels
                            .map(
                              (element) => SizedBox(
                                width: boxConstraints.maxWidth,
                                height: boxConstraints.maxHeight,
                                child: Stack(
                                  children: [
                                    WidgetImageInternet(
                                      urlImage: element.urlRoom,
                                      width: boxConstraints.maxWidth,
                                      height: boxConstraints.maxHeight * 0.6,
                                      boxFit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      top: boxConstraints.maxHeight * 0.6,
                                      child: SizedBox(
                                        width: boxConstraints.maxWidth,
                                        height: boxConstraints.maxHeight -
                                            (boxConstraints.maxHeight * 0.4),
                                        child: ListView.builder(
                                          reverse: true,
                                          shrinkWrap: true,
                                          physics: const ScrollPhysics(),
                                          itemCount:
                                              appController.chatModels.length,
                                          itemBuilder: (context, index) => Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 16,
                                                    right: 16,
                                                    bottom: 24),
                                                child: WidgetCircularImage(
                                                    urlImage: appController
                                                        .chatModels[index]
                                                        .urlAvatar),
                                              ),
                                              Container(
                                                constraints: BoxConstraints(
                                                    maxWidth: boxConstraints
                                                            .maxWidth *
                                                        0.5),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4,
                                                        horizontal: 12),
                                                margin: const EdgeInsets.only(
                                                    top: 4),
                                                decoration: AppConstant()
                                                    .boxChatGuest(),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    WidgetText(
                                                      text: appController
                                                          .chatModels[index]
                                                          .disPlayName,
                                                      textStyle: AppConstant()
                                                          .h3Style(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                    WidgetText(
                                                        text: appController
                                                            .chatModels[index]
                                                            .message),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        controller: PageController(
                            initialPage:
                                appController.indexBodyMainPageView.value),
                        scrollDirection: Axis.vertical,
                        onPageChanged: (value) {
                          appController.indexBodyMainPageView.value = value;
                          appController.readAllChat(
                              docIdRoom: appController.docIdRooms[
                                  appController.indexBodyMainPageView.value]);
                        },
                      ),
              );
            });
      }),
    );
  }
}
