// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:realpost/models/chat_model.dart';
import 'package:realpost/states/display_big_image.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/widgets/widget_image_internet.dart';

class DisplayAlbum extends StatefulWidget {
  const DisplayAlbum({
    Key? key,
    required this.chatModel,
  }) : super(key: key);

  final ChatModel chatModel;

  @override
  State<DisplayAlbum> createState() => _DisplayAlbumState();
}

class _DisplayAlbumState extends State<DisplayAlbum> {
  
  var albums = <String>[];

  @override
  void initState() {
    super.initState();
    albums.addAll(widget.chatModel.albums);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      appBar: AppBar(),
      body: GridView.builder(
        itemCount: albums.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        itemBuilder: (context, index) => WidgetImageInternet(
          urlImage: albums[index],
          boxFit: BoxFit.cover,
          radius: 4,
          tapFunc: () {
            Get.to(DisplayBigImage(albums: albums, index: index, chatModel: widget.chatModel,));
          },
        ),
      ),
    );
  }
}
