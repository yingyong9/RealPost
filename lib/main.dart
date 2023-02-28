// ignore_for_file: avoid_print

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realpost/states/main_home.dart';
import 'package:realpost/states/main_page_view.dart';
import 'package:realpost/states/main_web_view.dart';
import 'package:realpost/states/phone_number.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_service.dart';

var getPages = <GetPage<dynamic>>[
  GetPage(
    name: AppConstant.pagePhoneNumber,
    page: () => const PhoneNumber(),
  ),
  GetPage(
    name: AppConstant.pageMainHome,
    page: () => const MainHome(),
  ),
  GetPage(
    name: '/mainPageView',
    page: () => const MainPageView(),
  ),
  GetPage(
    name: '/mainWebView',
    page: () => const MainWebView(),
  )
];

String? keyPage;

Future<void> main() async {
  HttpOverrides.global = MyHttpOverride();
  WidgetsFlutterBinding.ensureInitialized();

  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  await Firebase.initializeApp().then((value) {
    AppController appController = Get.put(AppController());
    AppService().readAllUserModel().then((value) {
      print('##28feb userModels ---> ${appController.userModels.length}');
    });

    FirebaseAuth.instance.authStateChanges().listen((event) async {
      // await FirebaseAuth.instance.signOut();

      if (event == null) {
        keyPage = AppConstant.pagePhoneNumber;
        runApp(const MyApp());
      } else {
        appController.mainUid.value = event.uid;

        keyPage = '/mainPageView';
        runApp(const MyApp());
      }
    });
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstant.appName,
      getPages: getPages,
      initialRoute: keyPage,
      theme: ThemeData(
          primarySwatch: Colors.grey,
          appBarTheme: AppBarTheme(
            backgroundColor: AppConstant.bgColor,
            foregroundColor: AppConstant.dark,
            elevation: 0,
          )),
    );
  }
}

class MyHttpOverride extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    // TODO: implement createHttpClient
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
