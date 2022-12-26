// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/widgets/widget_icon_button.dart';
import 'package:realpost/widgets/widget_image_internet.dart';

class DisplayBigImage extends StatefulWidget {
  const DisplayBigImage({
    Key? key,
    required this.albums,
    required this.index,
  }) : super(key: key);

  final List<String> albums;
  final int index;

  @override
  State<DisplayBigImage> createState() => _DisplayBigImageState();
}

class _DisplayBigImageState extends State<DisplayBigImage> {
  var albums = <String>[];
  int? indexBody;
  PageController? pageController;
  var bodys = <Widget>[];

  @override
  void initState() {
    super.initState();
    albums.addAll(widget.albums);
    indexBody = widget.index;
    pageController = PageController(initialPage: indexBody!);

    for (var element in albums) {
      bodys.add(createWidget(urlImage: element));
    }
  }

  Widget createWidget({required String urlImage}) {
    return Stack(
      children: [
        WidgetImageInternet(urlImage: urlImage),
        Positioned(bottom: 0,right: 0,
          child: Row(mainAxisSize: MainAxisSize.min,
            children: [
              WidgetIconButton(iconData: Icons.save,
                pressFunc: () {},
              ),
               WidgetIconButton(iconData: Icons.ios_share,
                pressFunc: () {},
              ),
            ],
          ),
        )
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
      backgroundColor: AppConstant.bgColor,
      appBar: AppBar(),
      body: PageView(
        controller: pageController,
        children: bodys,
      ),
    );
  }
}
