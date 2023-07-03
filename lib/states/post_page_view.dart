import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realpost/states/answer_chat.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_text.dart';

class PostPageView extends StatefulWidget {
  const PostPageView({super.key});

  @override
  State<PostPageView> createState() => _PostPageViewState();
}

class _PostPageViewState extends State<PostPageView> {
  AppController appController = Get.put(AppController());

  PageController? pageController;

  @override
  void initState() {
    super.initState();

    AppService().freshUserModelLogin().then((value) {
       AppService().readAllPost();
    });
    AppService().aboutNoti(context: context);

    pageController = PageController(initialPage: 0);
   
  }

  @override
  void dispose() {
    pageController!.dispose();
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
                  controller: pageController,
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
