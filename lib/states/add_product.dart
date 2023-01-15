import 'package:flutter/material.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/widgets/widget_image.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppConstant.bgColor,
      appBar: AppBar(),
      body: WidgetImage(path: ''),
    );
  }
}
