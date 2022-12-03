// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class WidgetImageInternet extends StatelessWidget {
  const WidgetImageInternet({
    Key? key,
    required this.urlImage,
    this.width,
    this.height,
    this.boxFit,
    this.tapFunc,
  }) : super(key: key);

  final String urlImage;
  final double? width;
  final double? height;
  final BoxFit? boxFit;
  final Function()? tapFunc;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tapFunc,
      child: Image.network(
        urlImage,
        width: width,
        height: height,
        fit: boxFit,
      ),
    );
  }
}
