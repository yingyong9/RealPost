// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:realpost/widgets/widget_icon_button.dart';

class WidgetTakePhoto extends StatelessWidget {
  const WidgetTakePhoto({
    Key? key,
    this.size,
    required this.cameraFunc,
    required this.galleryFunc,
    required this.emojiFunc,
  }) : super(key: key);

  final double? size;
  final Function() cameraFunc;
  final Function() galleryFunc;
  final Function() emojiFunc;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? 200,
      child: Row(
        children: [
          WidgetIconButton(
            iconData: Icons.add_a_photo,
            pressFunc: cameraFunc,
          ),
          WidgetIconButton(
            iconData: Icons.add_photo_alternate,
            pressFunc: galleryFunc,
          ),
          WidgetIconButton(
            iconData: Icons.emoji_emotions,
            pressFunc: emojiFunc,
          ),
        ],
      ),
    );
  }
}
