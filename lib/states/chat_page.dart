// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'package:flutter/material.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/widgets/widget_form.dart';
import 'package:realpost/widgets/widget_icon_button.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
    required this.docIdRoom,
  }) : super(key: key);

  final String docIdRoom;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String? docIdRoom;

  @override
  void initState() {
    super.initState();
    docIdRoom = widget.docIdRoom;
    print('docIdRoom ==> $docIdRoom');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      appBar: AppBar(),
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
          child: SizedBox(
            width: boxConstraints.maxWidth,
            height: boxConstraints.maxHeight,
            child: Stack(
              children: [
                contentForm(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Column contentForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        WidgetForm(
          textStyle: AppConstant().h3Style(),
          changeFunc: (p0) {},
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 150,
              child: Row(
                children: [
                  WidgetIconButton(
                    iconData: Icons.add_a_photo,
                    pressFunc: () {},
                  ),
                  WidgetIconButton(
                    iconData: Icons.add_photo_alternate,
                    pressFunc: () {},
                  ),
                  WidgetIconButton(
                    iconData: Icons.emoji_emotions,
                    pressFunc: () {},
                  ),
                ],
              ),
            ),
            WidgetIconButton(
              iconData: Icons.send,
              pressFunc: () {
                
              },
            ),
          ],
        ),
      ],
    );
  }
}
