// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realpost/states/answer_chat.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_service.dart';

class PostPageView extends StatefulWidget {
  const PostPageView({super.key});

  @override
  State<PostPageView> createState() => _PostPageViewState();
}

class _PostPageViewState extends State<PostPageView> {

  AppController appController = Get.put(AppController());
  

  @override
  void initState() {
    super.initState();

    AppService().freshUserModelLogin().then((value) {
       AppService().readAllPost();
    });

    AppService().aboutNoti(context: context);
    appController.postPageControllers.last = PageController(initialPage: appController.indexBodyPost.value);
   
  }

  @override
  void dispose() {
    appController.postPageControllers.last.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Obx(() {
          return appController.postChatModels.isEmpty
              ? const SizedBox()
              : PageView(
                  controller: appController.postPageControllers.last,
                  children: appController.docIdPosts
                      .map(
                        (element) => AnswerChat(
                          docIdPost: element,
                        ),
                      )
                      .toList(),
                  onPageChanged: (value) {
                    appController.indexBodyPost.value = value;
                  },
                  scrollDirection: Axis.vertical,
                );
        }),
      ),
    );
  }
}
