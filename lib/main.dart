import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realpost/states/main_home.dart';
import 'package:realpost/states/phone_number.dart';
import 'package:realpost/utility/app_constant.dart';

var getPages = <GetPage<dynamic>>[
  GetPage(
    name: AppConstant.pagePhoneNumber,
    page: () => const PhoneNumber(),
  ),
  GetPage(
    name: AppConstant.pageMainHome,
    page: () => const MainHome(),
  ),
];

String? keyPage;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event == null) {
        keyPage = AppConstant.pagePhoneNumber;
        runApp(const MyApp());
      } else {
        keyPage = AppConstant.pageMainHome;
        runApp(const MyApp());
      }
    });
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(debugShowCheckedModeBanner: false,
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
