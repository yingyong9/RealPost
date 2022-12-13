// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:realpost/models/chat_model.dart';
import 'package:realpost/models/room_model.dart';
import 'package:realpost/models/user_model.dart';
import 'package:realpost/states/display_name.dart';
import 'package:realpost/states/otp_check.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_dialog.dart';
import 'package:realpost/widgets/widget_text_button.dart';
import 'package:url_launcher/url_launcher.dart';

class AppService {
  Future<void> processLunchUrl({required String url}) async {
    print('url ----> $url');
    final Uri uri = Uri.parse(url);
    await canLaunchUrl(uri) ? await launchUrl(uri) : throw 'Link False';
  }

  Future<Position?> processFindPosition({
    required BuildContext context,
  }) async {
    Position? position;
    bool locationServiceEnable = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission;
    if (locationServiceEnable) {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        alertDeniedForever(context: context);
      } else {
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if ((permission != LocationPermission.always) &&
              (permission != LocationPermission.whileInUse)) {
            alertDeniedForever(context: context);
          } else {
            position = await Geolocator.getCurrentPosition();
          }
        } else {
          position = await Geolocator.getCurrentPosition();
        }
      }
    } else {
      AppDialog(context: context).normalDialog(
        title: 'Location Service ปิดอยู่',
        leadingWidget: const Icon(
          Icons.pin_drop,
          size: 48,
        ),
        actions: <Widget>[
          WidgetTextButton(
            text: 'คลิกเปิด',
            pressFunc: () {
              Geolocator.openLocationSettings();
              exit(0);
            },
          )
        ],
      );
    }

    return position;
  }

  void alertDeniedForever({required BuildContext context}) {
    AppDialog(context: context).normalDialog(
      title: 'RealPost ต้องการพิกัดของคุณ กรุณาเปิด',
      leadingWidget: const Icon(
        Icons.pin_drop,
        size: 48,
      ),
      actions: <Widget>[
        WidgetTextButton(
          text: 'คลิกเปิด',
          pressFunc: () {
            Geolocator.openAppSettings();
            exit(0);
          },
        )
      ],
    );
  }

  Future<UserModel?> findUserModel({required String uid}) async {
    UserModel? userModel;
    var result =
        await FirebaseFirestore.instance.collection('user').doc(uid).get();
    userModel = UserModel.fromMap(result.data()!);
    return userModel;
  }

  Future<void> editUrlAvatar() async {
    AppController appController = Get.put(AppController());

    Map<String, dynamic> map = appController.userModels[0].toMap();
    print('map at editUrlAvatar before ===> $map');

    map['urlAvatar'] = appController.urlAvatarChooses[0];
    print('map at editUrlAvatar after ===> $map');

    var user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .update(map)
        .then((value) {
      print('Edit Avatar Success');
      appController.fileAvatars.clear();
      appController.urlAvatarChooses.clear();
      appController.findUserModels();
    });
  }

  Future<void> processInsertChat(
      {required ChatModel chatModel, required String docIdRoom}) async {
    AppController appController = Get.put(AppController());
    await FirebaseFirestore.instance
        .collection('room')
        .doc(docIdRoom)
        .collection('chat')
        .doc()
        .set(chatModel.toMap())
        .then((value) {
      print('Process Insert Chat Success');
      appController.urlRealPostChooses.clear();
    });
  }

  String timeStampToString({required Timestamp timestamp, String? newPattern}) {
    DateFormat dateFormat = DateFormat(newPattern ?? 'dd MMM');
    String result = dateFormat.format(timestamp.toDate());
    return result;
  }

  Future<String?> processUploadPhoto(
      {required File file, required String path}) async {
    String? urlPhoto;
    String nameFile = 'photo${Random().nextInt(1000000)}.jpg';
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child('$path/$nameFile');
    UploadTask uploadTask = reference.putFile(file);
    await uploadTask.whenComplete(() async {
      urlPhoto = await reference.getDownloadURL();
    });
    return urlPhoto;
  }

  Future<File?> processTakePhoto({required ImageSource source}) async {
    File? file;
    var result = await ImagePicker().pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (result != null) {
      file = File(result.path);
    }
    return file;
  }

  Future<void> processInsertRoom({required RoomModel roomModel}) async {
    await FirebaseFirestore.instance
        .collection('room')
        .doc()
        .set(roomModel.toMap());
  }

  Future<void> processSignOut() async {
    await FirebaseAuth.instance.signOut().then((value) {
      print('##24nov SignOut Success');
    });
  }

  Future<void> processSentSMS({required String fullPhoneNumber}) async {
    // String phoneNumber = '+66 81 859 5309';
    String phoneNumber = '+66 ${fullPhoneNumber.substring(1)}';
    print('##24nov phoneNumber = $phoneNumber');
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {
        print('##24nov varificationComplete Work');
      },
      verificationFailed: (error) {
        print('##24nov verificationFalie error ==> $error');
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        print('##24nov code Sent ==> $verificationId');
        // verifyPhone(verificationId: verificationId);
        Get.offAll(OtpCheck(verificationId: verificationId));
      },
      codeAutoRetrievalTimeout: (verificationId) {
        print('##24nov TimeOut');
      },
    );
  }

  Future<void> verifyPhone(
      {required String verificationId, required String smsCode}) async {
    await FirebaseAuth.instance
        .signInWithCredential(PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode))
        .then((value) async {
      String uid = value.user!.uid;
      print('##24nov uid ==> $uid');

      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .get()
          .then((value) {
        print('##24nov value ==> $value');
        if (value.data() == null) {
          Get.offAll(DisplayName(uidLogin: uid));
        } else {
          print('have Data user');
          Get.offAllNamed(AppConstant.pageMainHome);
        }
      });
    }).catchError((onError) {
      print('##24nov otp False ##############');
    });
  }
}
