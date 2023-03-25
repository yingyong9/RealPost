// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:realpost/models/chat_model.dart';
import 'package:realpost/states/chat_page.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_dialog.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_form.dart';
import 'package:realpost/widgets/widget_icon_button.dart';
import 'package:realpost/widgets/widget_image_internet.dart';

class DisplayBigImage extends StatefulWidget {
  const DisplayBigImage({
    Key? key,
    required this.albums,
    required this.index,
    required this.chatModel,
  }) : super(key: key);

  final List<String> albums;
  final int index;
  final ChatModel chatModel;

  @override
  State<DisplayBigImage> createState() => _DisplayBigImageState();
}

class _DisplayBigImageState extends State<DisplayBigImage> {
  var albums = <String>[];
  int? indexBody;
  ChatModel? chatModel;
  PageController? pageController;
  var bodys = <Widget>[];
  var user = FirebaseAuth.instance.currentUser;

  AppController controller = Get.put(AppController());

  @override
  void initState() {
    super.initState();
    albums.addAll(widget.albums);
    indexBody = widget.index;
    chatModel = widget.chatModel;
    pageController = PageController(initialPage: indexBody!);

    for (var element in albums) {
      bodys.add(createWidget(urlImage: element));
    }
  }

  Widget createWidget({
    required String urlImage,
  }) {
    return WidgetImageInternet(urlImage: urlImage);
  }

  Widget contentForm(String urlImage) {
    return Row(
      children: [
        Expanded(
          child: WidgetForm(hintStyle: AppConstant().h3Style(),
            hint: 'กรอกข้อความ Chat เกี่ยวสิ่งนี้',
            textStyle: AppConstant().h3Style(),
            height: 40,
            inputBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppConstant.dark),
            ),
          ),
        ),
        WidgetIconButton(
          iconData: Icons.send,
          pressFunc: () async {
            await AppService()
                .createChatModel(urlBigImage: urlImage)
                .then((value) async {
              await AppService()
                  .processInsertChat(
                      chatModel: value, docIdRoom: controller.docIdRoomChooses.last)
                  .then((value) {
                Get.offAll(
                    ChatPage(docIdRoom: controller.docIdRoomChooses.last));
              });
            });
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppConstant.bgColor,
      appBar: AppBar(
          title: user!.uid == chatModel!.uidChat
              ? const SizedBox()
              : contentForm('urlImage')),
      body: PageView(
        controller: pageController,
        children: bodys,
      ),
    );
  }
}
