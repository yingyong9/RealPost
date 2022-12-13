// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class WidgetCircularImage extends StatelessWidget {
  const WidgetCircularImage({
    Key? key,
    required this.urlImage,
    this.tapFunc,
  }) : super(key: key);

  final String urlImage;
  final Function()? tapFunc;

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: tapFunc,
      child: CircleAvatar(
        backgroundImage: NetworkImage(urlImage),
      ),
    );
  }
}
