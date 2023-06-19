// ignore_for_file: avoid_print

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:realpost/states/comment_chat.dart';
import 'package:realpost/states/delete_comment.dart';
import 'package:realpost/states/main_home.dart';
import 'package:realpost/states/main_page_for_guest.dart';
import 'package:realpost/states/main_page_view.dart';
import 'package:realpost/states/main_web_view.dart';
import 'package:realpost/states/phone_number.dart';
import 'package:realpost/states/upgrade_alert_page.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:upgrader/upgrader.dart';

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
  ),
  GetPage(
    name: '/upgradeAlertPage',
    page: () => const UpgradeAlertPage(),
  ),
  GetPage(
    name: '/mainPageForGuest',
    page: () => const MainPageForGuest(),
  ),
  GetPage(
    name: '/commentChat',
    page: () => const CommentChat(),
  ),
  GetPage(
    name: '/deleteComment',
    page: () => const DeleteComment(),
  ),
  GetPage(
    name: '/upgradeAlertPage',
    page: () => const UpgradeAlertPage(),
  ),
];

String? keyPage;

Future<void> main() async {
  HttpOverrides.global = MyHttpOverride();
  WidgetsFlutterBinding.ensureInitialized();

  await Upgrader.clearSavedSettings();

  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  await Firebase.initializeApp().then((value) {
    AppController appController = Get.put(AppController());
    

    FirebaseAuth.instance.authStateChanges().listen((event) async {
      if (event == null) {
        keyPage = AppConstant.pagePhoneNumber;
       
        runApp(const MyApp());
      } else {
        appController.mainUid.value = event.uid;
        keyPage = '/upgradeAlertPage';
        runApp(const MyApp());
      }
    });
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
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
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
