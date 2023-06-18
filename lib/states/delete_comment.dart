import 'package:flutter/material.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_text.dart';

class DeleteComment extends StatefulWidget {
  const DeleteComment({super.key});

  @override
  State<DeleteComment> createState() => _DeleteCommentState();
}

class _DeleteCommentState extends State<DeleteComment> {

@override
void initState() {
  super.initState();
   AppService().initialSetup(context: context);
    AppService().aboutNoti(context: context);
    AppService()
        .readCommentChat()
        .then((value) {
      // print(
      //     '##18june docIdcomments ---> ${controller.docIdCommentChats.length}');
    });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const WidgetText(text: 'Delete Comment'),),);
  }
}