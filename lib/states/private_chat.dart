// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_circular_image.dart';
import 'package:realpost/widgets/widget_content_form.dart';
import 'package:realpost/widgets/widget_image.dart';
import 'package:realpost/widgets/widget_image_internet.dart';
import 'package:realpost/widgets/widget_progress.dart';
import 'package:realpost/widgets/widget_text.dart';

class PrivateChat extends StatefulWidget {
  const PrivateChat({
    Key? key,
    required this.uidFriend,
  }) : super(key: key);

  final String uidFriend;

  @override
  State<PrivateChat> createState() => _PrivateChatState();
}

class _PrivateChatState extends State<PrivateChat> {
  TextEditingController textEditingController = TextEditingController();
  var user = FirebaseAuth.instance.currentUser;
  String? uidFriend, uidLogin;

  AppController controller = Get.put(AppController());

  @override
  void initState() {
    super.initState();
    uidFriend = widget.uidFriend;
    uidLogin = user!.uid;

    // controller.load = true;
    controller.processFindDocIdPrivateChat(
        uidLogin: uidLogin!, uidFriend: uidFriend!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      appBar: AppBar(),
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return GetX(
            init: AppController(),
            builder: (AppController appController) {
              print(
                  ' ##17dec docIdPrivateChats ---> ${appController.docIdPrivateChats}');
              print('##17dec load ---> ${appController.load}');
              return GestureDetector( behavior: HitTestBehavior.opaque,
                onTap: () =>
                    FocusScope.of(context).requestFocus(FocusScopeNode()),
                child: SizedBox(
                  width: boxConstraints.maxWidth,
                  height: boxConstraints.maxHeight,
                  child: Stack(
                    children: [
                      appController.load.value
                          ? const WidgetProgress()
                          : appController.docIdPrivateChats.isEmpty
                              ? const SizedBox()
                              : SizedBox(
                                  width: boxConstraints.maxWidth,
                                  height: boxConstraints.maxHeight - 100,
                                  child: ListView.builder(
                                    reverse: true,
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16),
                                    itemCount: appController.privateChatModels.length,
                                    itemBuilder: (context, index) => Container(
                                      margin: const EdgeInsets.only(top: 16),
                                      child: Row(
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              WidgetCircularImage(
                                                urlImage: appController
                                                    .privateChatModels[index]
                                                    .urlAvatar,
                                                tapFunc: () {
                                                  String uid = appController
                                                      .privateChatModels[index]
                                                      .uidChat;
                                                  print(
                                                      'You tap avatar uid ---> $uid');

                                                  if (uid != user!.uid) {
                                                    print('Open Private Chat');
                                                    Get.to(PrivateChat(uidFriend: uid,));
                                                  }
                                                },
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  WidgetText(
                                                      text: appController
                                                                  .privateChatModels[
                                                                      index]
                                                                  .uidChat ==
                                                              user!.uid
                                                          ? 'ฉัน'
                                                          : appController
                                                              .privateChatModels[index]
                                                              .disPlayName),
                                                  Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16,
                                                        vertical: 6),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 8),
                                                    decoration: AppConstant()
                                                        .boxChatLogin(),
                                                    child: WidgetText(
                                                        text: appController
                                                                .privateChatModels[
                                                                    index]
                                                                .message
                                                                .isEmpty
                                                            ? '...'
                                                            : appController
                                                                .privateChatModels[
                                                                    index]
                                                                .message),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 16,
                                          ),
                                          appController.privateChatModels[index]
                                                      .geoPoint!.latitude !=
                                                  0
                                              ? SizedBox(
                                                  width: 100,
                                                  height: 100,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child: Stack(
                                                      children: [
                                                      
                                                        WidgetImage(
                                                          path:
                                                              'images/map.png',
                                                          tapFunc: () {
                                                            double? lat =
                                                                appController
                                                                    .privateChatModels[
                                                                        index]
                                                                    .geoPoint!
                                                                    .latitude;
                                                            double? lng =
                                                                appController
                                                                    .privateChatModels[
                                                                        index]
                                                                    .geoPoint!
                                                                    .longitude;
                                                            String url =
                                                                'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
                                                            AppService()
                                                                .processLunchUrl(
                                                                    url: url);
                                                          },
                                                        ),
                                                       
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : appController.privateChatModels[index]
                                                      .urlRealPost.isEmpty
                                                  ? const SizedBox()
                                                  : WidgetImageInternet(
                                                      urlImage: appController
                                                          .privateChatModels[index]
                                                          .urlRealPost,
                                                      width: 100,
                                                      height: 100,
                                                    ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                      WidgetContentForm(
                        boxConstraints: boxConstraints,
                        appController: appController,
                        textEditingController: textEditingController,
                        collection: 'privatechat',
                      ),
                    ],
                  ),
                ),
              );
            });
      }),
    );
  }
}
