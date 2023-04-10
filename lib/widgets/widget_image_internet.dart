// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:realpost/widgets/widget_image.dart';
import 'package:realpost/widgets/widget_progress.dart';

class WidgetImageInternet extends StatelessWidget {
  const WidgetImageInternet({
    Key? key,
    required this.urlImage,
    this.width,
    this.height,
    this.boxFit,
    this.tapFunc,
    this.radius,
  }) : super(key: key);

  final String urlImage;
  final double? width;
  final double? height;
  final BoxFit? boxFit;
  final Function()? tapFunc;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tapFunc,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 10),
        child: CachedNetworkImage(
          imageUrl: urlImage,
          width: width,
          height: height,
          fit: boxFit,
          placeholder: (context, url) => const WidgetProgress(),
          errorWidget: (context, url, error) => const WidgetImage(path: 'images/icon.png'),
        ),
      ),
    );
  }
}
