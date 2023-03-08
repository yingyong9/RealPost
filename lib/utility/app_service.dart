// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:realpost/models/chat_model.dart';
import 'package:realpost/models/checkphone_model.dart';
import 'package:realpost/models/comment_salse_model.dart';
import 'package:realpost/models/otp_require_thaibulk.dart';
import 'package:realpost/models/private_chat_model.dart';
import 'package:realpost/models/room_model.dart';
import 'package:realpost/models/salse_group_model.dart';
import 'package:realpost/models/user_model.dart';
import 'package:realpost/states/display_name.dart';
import 'package:realpost/states/take_photo_only.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_dialog.dart';
import 'package:realpost/utility/app_snackbar.dart';
import 'package:realpost/widgets/widget_text_button.dart';
import 'package:url_launcher/url_launcher.dart';

class AppService {
  AppController appController = Get.put(AppController());

  Future<void> readAllUserModel() async {
    if (appController.userModels.isNotEmpty) {
      appController.userModels.clear();
    }

    await FirebaseFirestore.instance.collection('user').get().then((value) {
      for (var element in value.docs) {
        UserModel userModel = UserModel.fromMap(element.data());
        appController.userModels.add(userModel);
      }
    });
  }

  Future<void> countTime() async {
    await Future.delayed(
      const Duration(seconds: 1),
      () {
        if (appController.timeOtp >= 0) {
          appController.timeOtp--;
          countTime();
        }
      },
    );
  }

  Future<void> verifyOTPThaibulk(
      {required String token,
      required String pin,
      required BuildContext context,
      required String phoneNumber}) async {
    print(
        '##22feb token --> $token, pin --> $pin, phoneNumber --> $phoneNumber');

    String urlApi = 'https://otp.thaibulksms.com/v2/otp/verify';
    Map<String, dynamic> map = {};
    map['key'] = AppConstant.key;
    map['secret'] = AppConstant.secret;
    map['token'] = token;
    map['pin'] = pin;

    Dio dio = Dio();
    dio.options.headers['Content-Type'] = 'application/x-www-form-urlencoded';
    await dio.post(urlApi, data: map).then((value) async {
      print('##22feb statusCode --> ${value.statusCode}');
      if (value.statusCode == 200) {
        //Everything OK
        print('##28feb verifyOTP Success phone ที่กรอก ---> $phoneNumber');
        UserModel? havePhoneUserModel;

        bool havePhone = false;
        for (var element in appController.userModels) {
          if (element.phoneNumber == phoneNumber) {
            havePhone = true;
            havePhoneUserModel = element;
          }
        }
        print('##28feb havePhone = $havePhone');

        if (havePhone) {
          print('##28feb เคยเอาเบอร์นี่ไปสมัครแล้ว');
          print('##28feb havePhoneModel ---> ${havePhoneUserModel!.toMap()}');

          await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: havePhoneUserModel.email!,
                  password: havePhoneUserModel.password!)
              .then((value) {
            Get.offAllNamed('/mainPageView');
          });
        } else {
          print('##28feb เบอร์ใหม่');

          String email = 'phone$phoneNumber@realpost.com';
          String password = '123456';

          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password)
              .then((value) {
            String uidUser = value.user!.uid;
            print('##28feb uidUser ---> $uidUser');
            Get.offAll(DisplayName(
                uidLogin: uidUser,
                phoneNumber: phoneNumber,
                email: email,
                password: password));
          });
        }
      }
    }).catchError((onError) {
      print('##22feb errer code 400');
      AppSnackBar().normalSnackBar(
        title: 'OTP ผิด',
        message: 'กรอกใหม่อีกครั้ง',
        second: 3,
        textColor: Colors.red,
      );
    });
  }

  // Future<void> createAnonymouns({required String phoneNumber}) async {
  //   await FirebaseAuth.instance.signInAnonymously().then((value) async {
  //     String uid = value.user!.uid;
  //     print('##22feb uid from anonymouns --> $uid');

  //     await value.user!.getIdTokenResult().then((value) async {
  //       String? token = value.token;

  //       Map<String, dynamic> map = {};
  //       map['uid'] = uid;
  //       // map['token'] = token;

  //       print('##22feb map ---> $map');
  //       await FirebaseFirestore.instance
  //           .collection('checkphone')
  //           .doc(phoneNumber)
  //           .set(map)
  //           .then((value) {
  //         Get.offAll(DisplayName(uidLogin: uid));
  //       });
  //     });
  //   });
  // }

  Future<OtpRequireThaibulk> processSentSmsThaibulk(
      {required String phoneNumber}) async {
    String urlApi = 'https://otp.thaibulksms.com/v2/otp/request';

    Map<String, dynamic> map = {};
    map['key'] = AppConstant.key;
    map['secret'] = AppConstant.secret;
    map['msisdn'] = phoneNumber;

    Dio dio = Dio();
    dio.options.headers['Content-Type'] = 'application/x-www-form-urlencoded';

    var result = await dio.post(urlApi, data: map);
    OtpRequireThaibulk otpRequireThaibulk =
        OtpRequireThaibulk.fromMap(result.data);
    return otpRequireThaibulk;
  }

  Future<void> processUpdateUserModel(
      {required Map<String, dynamic> map}) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(appController.mainUid.value)
        .update(map)
        .then((value) {
      appController.findUserModels();
    });
  }

  Future<void> processInsertPrivateChat(
      {required String docIdPrivateChat, required ChatModel chatModel}) async {
    await FirebaseFirestore.instance
        .collection('privatechat')
        .doc(docIdPrivateChat)
        .collection('chat')
        .doc()
        .set(chatModel.toMap())
        .then((value) {
      print('##4feb insert Private Success');
    });
  }

  bool checkUserInCommentSalse() {
    bool result = true; //true => user ที่ยังไม่ได้เข้าร่วมซื้อ
    var user = FirebaseAuth.instance.currentUser;
    if (appController.commentSalses.isNotEmpty) {
      for (var element in appController.commentSalses) {
        if (user!.uid == element.uid) {
          result = false;
        }
      }
    }
    return result;
  }

  Future<bool> checkGuest({required String docIdcommentSalse}) async {
    bool status = true;

    var result = await FirebaseFirestore.instance
        .collection('room')
        .doc(
            appController.docIdRooms[appController.indexBodyMainPageView.value])
        .collection('commentsalse')
        .doc(docIdcommentSalse)
        .collection('salsegroup')
        .get();

    for (var element in result.docs) {
      SalseGroupModel salseGroupModel = SalseGroupModel.fromMap(element.data());
      if (salseGroupModel.map['uid'] == appController.mainUid.value) {
        status = false;
      }
    }
    return status;
  }

  Future<void> processInsertCommentSalse(
      {required CommentSalseModel commentSalseModel,
      required String docIdRoom,
      required BuildContext context}) async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('room')
        .doc(docIdRoom)
        .collection('commentsalse')
        .doc();

    await documentReference.set(commentSalseModel.toMap()).then((value) async {
      String docIdcommentSalse = documentReference.id;
      print('##28jan docIdcommentSalse ---> $docIdcommentSalse');

      if (commentSalseModel.single) {
        //ซื่อคนเดียว
        print('##28jan single Work');
        Get.back();

        // AppDialog(context: context).addressDialog();
      } else {
        //ซืั้อกลุ่ม
        print('##28jan buy Group');

        var user = FirebaseAuth.instance.currentUser;

        Map<String, dynamic> map = appController.userModels.last.toMap();
        map['uid'] = user!.uid;
        SalseGroupModel salseGroupModel = SalseGroupModel(
            map: map, timestamp: Timestamp.fromDate(DateTime.now()));

        await FirebaseFirestore.instance
            .collection('room')
            .doc(docIdRoom)
            .collection('commentsalse')
            .doc(docIdcommentSalse)
            .collection('salsegroup')
            .doc()
            .set(salseGroupModel.toMap())
            .then((value) {
          Get.back();
          print('##28jan insert salsegropu success');
        });
      }
    });
  }

  String cutWord({required String string, required int word}) {
    String result = string;
    if (result.length > word) {
      result = result.substring(0, word);
      result = '$result ...';
    }
    return result;
  }

  RoomModel createRoomModel({
    required String uidCreate,
    required String room,
    required Timestamp timestamp,
    required String urlCamera,
    required List<String> urlRooms,
    required String detail,
    required bool safeProduct,
    required String groupProduct,
    required String singlePrice,
    required String totalPrice,
    required String amountGroup,
    required String stock,
    required String timeGroup,
  }) {
    RoomModel roomModel = RoomModel(
        uidCreate: uidCreate,
        room: room,
        timestamp: timestamp,
        urlCamera: urlCamera,
        urlRooms: urlRooms,
        detail: detail,
        safeProduct: safeProduct,
        groupProduct: groupProduct,
        singlePrice: singlePrice,
        totalPrice: totalPrice,
        amountGroup: amountGroup,
        stock: stock,
        timeGroup: timeGroup);

    return roomModel;
  }

  void initialSetup({required BuildContext context}) {

    
   
    appController.readAllRoom().then((value) {
      print('##6mar docIdRoom.length --> ${appController.docIdRooms.length}');

      bool noRoom = true;

      for (var element in appController.roomModels) {
        if (appController.mainUid.value == element.uidCreate) {
          noRoom = false;
        }
      }

      appController.processReadCommentSalses();

      if (noRoom) {
        Get.to(const TakePhotoOnly());
      } else {
        print('##5jan Have Room');
      }

      appController.readAllChat(docIdRoom: appController.docIdRooms[0]);

      if (appController.docIdRoomChooses.isNotEmpty) {
        appController.docIdRoomChooses.clear();
      }
      appController.docIdRoomChooses.add(
          appController.docIdRooms[appController.indexBodyMainPageView.value]);
    });

    appController.findUserModels();
    appController.readAllStamp();

    if (appController.urlAvatarChooses.isNotEmpty) {
      appController.urlAvatarChooses.clear();
    }

    if (appController.urlRealPostChooses.isNotEmpty) {
      appController.urlRealPostChooses.clear();
    }

    Future.delayed(Duration.zero, (() async {
      Position? position =
          await AppService().processFindPosition(context: context);
      if (position != null) {
        appController.positions.add(position);
      }
      print('##11dec current Position --> $position');
    }));

    appController.readGroupProduct();
    appController.readTimeGroup();
    
  }

  Future<void> insertPrivateChat(
      {required String uidLogin, required String uidFriend}) async {
    var uidChats = <String>[];
    uidChats.add(uidLogin);
    uidChats.add(uidFriend);

    PrivateChatModel model = PrivateChatModel(uidchats: uidChats);

    await FirebaseFirestore.instance
        .collection('privatechat')
        .doc()
        .set(model.toMap())
        .then((value) {
      print('##17dec insert new PrivateChatSuccess');
    });
  }

  Future<ChatModel> createChatModel(
      {String? urlBigImage, String? urlRealPost}) async {
    AppController appController = Get.put(AppController());
    ChatModel chatModel;

    if (appController.xFiles.isEmpty) {
      //ไม่มี album
      chatModel = ChatModel(
          message: appController.messageChats.isEmpty
              ? ''
              : appController.messageChats.last,
          timestamp: Timestamp.fromDate(DateTime.now()),
          uidChat: FirebaseAuth.instance.currentUser!.uid,
          urlRealPost: urlRealPost != null
              ? urlRealPost
              : appController.urlRealPostChooses.isNotEmpty
                  ? appController.urlAvatarChooses.last
                  : '',
          disPlayName: appController.userModels.last.displayName!,
          urlAvatar: appController.userModels.last.urlAvatar!.isEmpty
              ? appController.urlAvatarChooses.last
              : appController.userModels.last.urlAvatar!,
          article: appController.articleControllers.last.text,
          link: appController.links.isEmpty ? '' : appController.links.last,
          geoPoint: appController.shareLocation.value
              ? GeoPoint(appController.positions[0].latitude,
                  appController.positions[0].longitude)
              : null,
          albums: [],
          urlBigImage: urlBigImage ?? '');
    } else {
      //มี album

      var albums = await processUploadMultiPhoto();

      chatModel = ChatModel(
          message: appController.messageChats.isEmpty
              ? ''
              : appController.messageChats[0],
          timestamp: Timestamp.fromDate(DateTime.now()),
          uidChat: FirebaseAuth.instance.currentUser!.uid,
          urlRealPost: appController.urlRealPostChooses.isEmpty
              ? ''
              : appController.urlRealPostChooses[0],
          disPlayName: appController.userModels[0].displayName!,
          urlAvatar: appController.userModels[0].urlAvatar!.isEmpty
              ? appController.urlAvatarChooses[0]
              : appController.userModels[0].urlAvatar!,
          article: appController.articleControllers[0].text,
          link: appController.links.isEmpty ? '' : appController.links.last,
          geoPoint: appController.shareLocation.value
              ? GeoPoint(appController.positions[0].latitude,
                  appController.positions[0].longitude)
              : null,
          albums: albums,
          urlBigImage: urlBigImage ?? '');
    }

    print(
        '##8jan at createModel app service chartModel ==> ${chatModel.toMap()}');

    return chatModel;
  }

  Future<void> processChooseMultiImage() async {
    AppController appController = Get.put(AppController());

    if (appController.xFiles.isNotEmpty) {
      appController.xFiles.clear();
    }

    await ImagePicker()
        .pickMultiImage(maxWidth: 800, maxHeight: 800)
        .then((value) {
      if (value.length <= (9 - appController.xFiles.length)) {
        appController.xFiles.addAll(value);
      } else {
        Get.snackbar(
            'คุณเลือกภาพเกินที่กำหนด', 'เราอนุญาติให้เลือกภาพไม่เกิน 9 รูป');
      }
    });
  }

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
      {required ChatModel chatModel,
      required String docId,
      String? collection}) async {
    AppController appController = Get.put(AppController());

    print(
        '##8jan @processInsertChat collection --> $collection, docId --> $docId');

    await FirebaseFirestore.instance
        .collection(collection ?? 'room')
        .doc(docId)
        .collection('chat')
        .doc()
        .set(chatModel.toMap())
        .then((value) {
      print('##19dec Process Insert Chat Success');
      appController.shareLocation.value = false;
    });
  }

  String timeStampToString({required Timestamp timestamp, String? newPattern}) {
    DateFormat dateFormat = DateFormat(newPattern ?? 'dd MMM');
    String result = dateFormat.format(timestamp.toDate());
    return result;
  }

  Future<List<String>> processUploadMultiPhoto({String? path}) async {
    AppController appController = Get.put(AppController());
    var albums = <String>[];

    for (var element in appController.xFiles) {
      File file = File(element.path);
      String? url =
          await processUploadPhoto(file: file, path: path ?? 'albums');
      albums.add(url!);
    }

    return albums;
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

  Future<void> processUpdateRoom(
      {required String docIdRoom, required Map<String, dynamic> data}) async {
    AppController appController = Get.put(AppController());
    await FirebaseFirestore.instance
        .collection('room')
        .doc(docIdRoom)
        .update(data)
        .then((value) {
      print('##5jan update Room Success');
      appController.readAllRoom();
    });
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
    print('##17feb phoneNumber = $phoneNumber');
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {
        print('##17feb varificationComplete Work');
      },
      verificationFailed: (error) {
        print('##17feb verificationFalie error ==> $error');
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        print('##17feb code Sent ==> $verificationId');
        // verifyPhone(verificationId: verificationId);
        // Get.offAll(OtpCheck(verificationId: verificationId));
      },
      codeAutoRetrievalTimeout: (verificationId) {
        print('##17feb TimeOut');
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
      print('##17feb uid ==> $uid');

      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .get()
          .then((value) {
        print('##24nov value ==> $value');
        if (value.data() == null) {
          // Get.offAll(DisplayName(uidLogin: uid));
        } else {
          print('have Data user');
          Get.offAllNamed('/mainPageView');
        }
      });
    }).catchError((onError) {
      print('##17feb otp False ##############');
      AppSnackBar().normalSnackBar(
        title: 'OTP ผิด',
        message: 'กรอก OTP ที่ส่งมาจาก sms',
        second: 3,
        bgColor: Colors.red.shade700,
        textColor: Colors.white,
      );
    });
  }
}
