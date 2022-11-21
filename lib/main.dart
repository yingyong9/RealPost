import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realpost/states/display_name.dart';
import 'package:realpost/utility/app_constant.dart';

var getPages = <GetPage<dynamic>>[
  GetPage(
    name: AppConstant.pageDisplayName,
    page: () => const DisplayName(),
  ),
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstant.appName,
      getPages: getPages,
      initialRoute: AppConstant.pageDisplayName,
      theme: ThemeData(
          primarySwatch: Colors.grey,
          appBarTheme: AppBarTheme(
            backgroundColor: AppConstant.bgColor,
            foregroundColor: AppConstant.dark,
          )),
    );
  }
}
