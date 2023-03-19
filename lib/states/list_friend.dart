import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realpost/states/private_chat.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_circular_image.dart';
import 'package:realpost/widgets/widget_text.dart';

class ListFriend extends StatefulWidget {
  const ListFriend({super.key});

  @override
  State<ListFriend> createState() => _ListFriendState();
}

class _ListFriendState extends State<ListFriend> {
  @override
  void initState() {
    super.initState();
    AppService().findArrayFriendUid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      appBar: AppBar(
        title: WidgetText(
          text: 'List Friend',
          textStyle: AppConstant().h2Style(),
        ),
      ),
      body: GetX(
          init: AppController(),
          builder: (AppController appController) {
            print(
                '##19mar uid ที่ login อยู่ ---> ${appController.mainUid.value}');
            print('##19mar uidFriend ===> ${appController.uidFriends.length}');
            print(
                '##19mar userModelPrivateChat ===> ${appController.userModelPrivateChats.length}');
            return ((appController.uidFriends.isNotEmpty) &&
                    (appController.userModelPrivateChats.isNotEmpty))
                ? ListView.builder(
                    itemCount: appController.userModelPrivateChats.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        Get.to(PrivateChat(uidFriend: appController.uidFriends[index]));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            WidgetCircularImage(
                                urlImage: appController
                                    .userModelPrivateChats[index].urlAvatar!),
                            const SizedBox(
                              width: 16,
                            ),
                            WidgetText(
                              text: appController
                                  .userModelPrivateChats[index].displayName!,
                              textStyle: AppConstant()
                                  .h3Style(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox();
          }),
    );
  }
}
