import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realpost/utility/app_controller.dart';

class MultiImageGridView extends StatefulWidget {
  const MultiImageGridView({
    super.key,
  });

  @override
  State<MultiImageGridView> createState() => _MultiImageGridViewState();
}

class _MultiImageGridViewState extends State<MultiImageGridView> {
  AppController appController = Get.put(AppController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: GridView.builder(
        itemCount: appController.xFiles.length,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 4, mainAxisSpacing: 4),
        itemBuilder: (context, index) => Image.file(
          File(appController.xFiles[index].path),
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
