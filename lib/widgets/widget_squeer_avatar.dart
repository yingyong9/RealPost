// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class WidgetSqueerAvatar extends StatelessWidget {
  const WidgetSqueerAvatar({
    Key? key,
    required this.urlImage,
    this.size,
  }) : super(key: key);

  final String urlImage;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? 60,
      height: size ?? 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(
          image: NetworkImage(urlImage),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
