// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:realpost/models/chat_model.dart';
import 'package:realpost/models/comment_salse_model.dart';
import 'package:realpost/models/friend_model.dart';
import 'package:realpost/models/otp_require_thaibulk.dart';
import 'package:realpost/models/private_chat_model.dart';
import 'package:realpost/models/room_model.dart';
import 'package:realpost/models/salse_group_model.dart';
import 'package:realpost/models/stat_data_model.dart';
import 'package:realpost/models/user_model.dart';
import 'package:realpost/states/comment_chat.dart';
import 'package:realpost/states/display_name.dart';
import 'package:realpost/states/main_page_view.dart';
import 'package:realpost/states/take_photo_only.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_controller.dart';
import 'package:realpost/utility/app_dialog.dart';
import 'package:realpost/utility/app_snackbar.dart';
import 'package:realpost/widgets/widget_image.dart';
import 'package:realpost/widgets/widget_text.dart';
import 'package:realpost/widgets/widget_text_button.dart';
import 'package:url_launcher/url_launcher.dart';

class AppService {
  AppController appController = Get.put(AppController());

  Future<void> updateCommentChat(
      {required Map<String, dynamic> map, required String docIdComment}) async {
    FirebaseFirestore.instance
        .collection('comment')
        .doc(docIdComment)
        .update(map);
  }

  Future<void> checkOwnerComment(
      {required String docIdComment,
      required ChatModel commentChatModel,
      required bool readed,
      required Map<String, dynamic> map}) async {
    if (appController.mainUid.value == commentChatModel.uidChat) {
      // Map<String, dynamic> map = commentChatModel.toMap();
      map['readed'] = readed;
      FirebaseFirestore.instance
          .collection('room')
          .doc(AppConstant.docIdRoomData)
          .collection('chat')
          .doc(AppConstant.docIdChat)
          .collection('comment')
          .doc(docIdComment)
          .update(map)
          .then((value) {
        print('##13june Owner OK');
      });
    }
  }

  Future<void> readAnswer({required String docIdComment}) async {
    if (appController.answerChatModels.isNotEmpty) {
      appController.answerChatModels.clear();
    }

    FirebaseFirestore.instance
        .collection('comment')
        .doc(docIdComment)
        .collection('answer')
        .orderBy('timestamp')
        .snapshots()
        .listen((event) {
      if (event.docs.isNotEmpty) {
        if (appController.answerChatModels.isNotEmpty) {
          appController.answerChatModels.clear();
        }

        for (var element in event.docs) {
          ChatModel answerChatModel = ChatModel.fromMap(element.data());
          appController.answerChatModels.add(answerChatModel);
        }
      }
    });
  }

  Future<void> insertAnswer(
      {required ChatModel chatModel, required String docIdComment}) async {
    await FirebaseFirestore.instance
        .collection('comment')
        .doc(docIdComment)
        .collection('answer')
        .doc()
        .set(chatModel.toMap())
        .then((value) {
      print('##11june ---> Success at insertAnser');
    });
  }

  Future<void> readChatForDelete() async {
    await FirebaseFirestore.instance
        .collection('room')
        .doc(AppConstant.docIdRoomData)
        .collection('chat')
        .get()
        .then((value) async {
      int i = 0;
      for (var element in value.docs) {
        String docIdChat = element.id;

        if (i < 500) {
          print('##27may docIdChat --> $docIdChat');

          await FirebaseFirestore.instance
              .collection('room')
              .doc(AppConstant.docIdRoomData)
              .collection('chat')
              .doc(docIdChat)
              .delete();
        }

        i++;
      }
    });
  }

  Future<void> readStatData() async {
    FirebaseFirestore.instance
        .collection('statdata')
        .snapshots()
        .listen((event) {
      if (appController.statDataModels.isNotEmpty) {
        appController.statDataModels.clear();
      }

      for (var element in event.docs) {
        StatDataModel statDataModel = StatDataModel.fromMap(element.data());
        appController.statDataModels.add(statDataModel);
      }
    });
  }

  Future<void> increaseValueGraph(
      {required String docIdChat, required ChatModel chatModel}) async {
    print('##26may you click docIdChat --> $docIdChat');
    print('##26may chatModel --> ${chatModel.amountGraph}');

    int amountGraphInt = chatModel.amountGraph;
    amountGraphInt++;
    Map<String, dynamic> map = chatModel.toMap();
    map['amountGraph'] = amountGraphInt;
    ChatModel newChatModel = ChatModel.fromMap(map);
    print('##26may newChatModel ---> ${newChatModel.amountGraph}');

    await FirebaseFirestore.instance
        .collection('room')
        .doc(AppConstant.docIdRoomData)
        .collection('chat')
        .doc(docIdChat)
        .update(newChatModel.toMap())
        .then((value) {
      print('##26may update Success');
    });
  }

  Future<void> increaseValueComment(
      {required String docIdChat, required ChatModel chatModel}) async {
    int amountCommentInt = chatModel.amountComment;
    amountCommentInt++;
    Map<String, dynamic> map = chatModel.toMap();
    map['amountComment'] = amountCommentInt;
    ChatModel newChatModel = ChatModel.fromMap(map);

    await FirebaseFirestore.instance
        .collection('room')
        .doc(AppConstant.docIdRoomData)
        .collection('chat')
        .doc(docIdChat)
        .update(newChatModel.toMap())
        .then((value) {
      print('##26may update Success');
    });
  }

  Future<void> increaseValueUp(
      {required String docIdChat, required ChatModel chatModel}) async {
    print('##27may docIdChat --> $docIdChat');
    print('##27may up before --> ${chatModel.up}');

    int upInt = chatModel.up!;
    print('##27may upInt before --> $upInt');

    upInt = upInt + 1;
    print('##27may upInt after --> $upInt');

    Map<String, dynamic> map = chatModel.toMap();
    map['up'] = upInt;
    map['timestamp'] = Timestamp.fromDate(DateTime.now());
    ChatModel newChatModel = ChatModel.fromMap(map);

    print('##27may up after --> ${newChatModel.up}');

    await FirebaseFirestore.instance
        .collection('room')
        .doc(AppConstant.docIdRoomData)
        .collection('chat')
        .doc(docIdChat)
        .update(newChatModel.toMap())
        .then((value) {
      print('##26may update Success');
      Get.back();
    });
  }

  bool checkJoin({required String uidOwnerRoom}) {
    var result =
        appController.userModelsLogin.last.followings.contains(uidOwnerRoom);
    return result;
  }

  void processUnJoin() {}

  Future<void> processJoin({required String uidFollowing}) async {
    //ส่วนของการเพิ่ม Follower คนที่ตามเรา
    var userModelFollowing = await findUserModel(uid: uidFollowing);
    if (userModelFollowing != null) {
      Map<String, dynamic> mapFollowing = userModelFollowing.toMap();
      var followers = mapFollowing['followers'];
      followers.add(appController.mainUid.value);
      print('followers ---> $followers');

      await FirebaseFirestore.instance
          .collection('user')
          .doc(uidFollowing)
          .update(mapFollowing)
          .then((value) {
        print('ส่วนของการเพิ่ม Follower คนที่ตามเรา');
      });
    }

    //ส่วนของการเพิ่ม Following คนที่ตามเราตามเขา
    Map<String, dynamic> mapFollowering =
        appController.userModelsLogin.last.toMap();

    var following = mapFollowering['followings'];
    following.add(uidFollowing);
    print('following ---> $following');

    // mapFollowering['following'].add(uidFollowing);
    await FirebaseFirestore.instance
        .collection('user')
        .doc(appController.mainUid.value)
        .update(mapFollowering)
        .then((value) {
      print('ส่วนของการเพิ่ม Following คนที่ตามเราตามเขา');
    });
  }

  Future<void> checkInOwnerChat(
      {required String docIdChat,
      required ChatModel chatModel,
      required bool checkIn}) async {
    if (appController.mainUid.toString() == chatModel.uidChat) {
      //Owner Check In
      print('##18may Owner CheckIn at docIdChat ---> $docIdChat');

      Map<String, dynamic> map = chatModel.toMap();
      map['checkInOwnerChat'] = checkIn;
      ChatModel updateChagModel = ChatModel.fromMap(map);

      print('##18may updateChangMOdel ---> ${updateChagModel.toMap()}');

      processUpdateChat(docIdChat: docIdChat, chatModel: updateChagModel);
    }
  }

  Future<void> processUpdateChat(
      {required String docIdChat, required ChatModel chatModel}) async {
    // print('##17may chatModel ---> ${chatModel.toMap()}');

    await FirebaseFirestore.instance
        .collection('room')
        .doc(AppConstant.docIdRoomData)
        .collection('chat')
        .doc(docIdChat)
        .update(chatModel.toMap())
        .then((value) {
      print('##18may processUpdateChat Success');
    });
  }

  Future<void> increaseDecrestTraffic(
      {required String docIdChat,
      required bool increase,
      required ChatModel chatModel}) async {
    Map<String, dynamic> map = chatModel.toMap();
    print('##16may before traffic --> ${map['traffic']}');
    if (increase) {
      map['traffic'] = map['traffic'] + 1;
    } else {
      map['traffic'] = map['traffic'] - 1;
    }
    print('##16may after traffic --> ${map['traffic']}');

    await FirebaseFirestore.instance
        .collection('room')
        .doc(AppConstant.docIdRoomData)
        .collection('chat')
        .doc(docIdChat)
        .update(map);
  }

  Future<void> insertCommentChat({required ChatModel commentChatModel}) async {
    await FirebaseFirestore.instance
        .collection('comment')
        .doc()
        .set(commentChatModel.toMap())
        .then((value) {
      String urlNewImage = '';

      if (commentChatModel.urlRealPost.isNotEmpty) {
        urlNewImage = commentChatModel.urlRealPost;
      } else if (commentChatModel.urlMultiImages.isNotEmpty) {
        urlNewImage = commentChatModel.urlMultiImages[0];
      }
    });
  }

  Future<void> readCommentChat() async {
    FirebaseFirestore.instance
        .collection('comment')
        .orderBy('timestamp')
        .snapshots()
        .listen((event) async {
      if (appController.commentChatModels.isNotEmpty) {
        appController.commentChatModels.clear();
        appController.docIdCommentChats.clear();
      }

      if (event.docs.isNotEmpty) {
        for (var element in event.docs) {
          ChatModel commentChatModel = ChatModel.fromMap(element.data());
          appController.commentChatModels.add(commentChatModel);
          appController.docIdCommentChats.add(element.id);
        }
      }
    });
  }

  Future<void> deleteComment() async {
    print(
        '##18june docIdComment -------------> ${appController.docIdCommentChats.length}');

    int i = 0;
    for (var element in appController.docIdCommentChats) {
      print('##18june before delete docIdComment ----> $element');

      if (i > 10) {
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          transaction.delete(FirebaseFirestore.instance
              .collection('room')
              .doc(AppConstant.docIdRoomData)
              .collection('chat')
              .doc(AppConstant.docIdChat)
              .collection('comment')
              .doc(element));
        });
        print('##18june after delete docIdComment ----> $element');
      }

      i++;
    }
  }

  Future<void> addFavorite(
      {required String docIdChat,
      required ChatModel chatModel,
      required bool increse,
      required int index}) async {
    Map<String, dynamic> map = chatModel.toMap();

    print('##9may you tap addFavorite at docIdChat ---> $docIdChat');

    bool currentIncrese = increse;

    if (increse) {
      if (appController.processUps[index]) {
        // กดซ้ำ
        currentIncrese = !currentIncrese;
      }
      appController.processUps[index] = !appController.processUps[index];
    } else {
      //สำหรับ ลด
      if (appController.processDowns[index]) {
        //ซ้ำ
        currentIncrese = !currentIncrese;
      }
      appController.processDowns[index] = !appController.processDowns[index];
    }

    if (currentIncrese) {
      map['favorit'] = map['favorit'] + 1;
    } else {
      map['favorit'] = map['favorit'] - 1;
    }

    await FirebaseFirestore.instance
        .collection('room')
        .doc(
            appController.docIdRooms[appController.indexBodyMainPageView.value])
        .collection('chat')
        .doc(docIdChat)
        .update(map);
  }

  Future<bool> findPatnerFriend({required String uidCheckFriend}) async {
    bool result = true; // display add friend

    var snapshot = await FirebaseFirestore.instance.collection('friend').get();
    for (var element in snapshot.docs) {
      FriendModel friendModel = FriendModel.fromMap(element.data());
      if (friendModel.uidFriends.contains(appController.mainUid.toString())) {
        if (friendModel.uidFriends.contains(uidCheckFriend)) {
          result = false;
        }
      }
    }

    return result;
  }

  Future<void> processAddFriend({required String uidFriend}) async {
    var friends = <String>[];
    friends.add(appController.mainUid.toString());
    friends.add(uidFriend);
    FriendModel friendModel = FriendModel(uidFriends: friends);
    await FirebaseFirestore.instance
        .collection('friend')
        .doc()
        .set(friendModel.toMap());
  }

  Future<void> delayListFriend() async {
    await Future.delayed(
      const Duration(seconds: 3),
      () {
        appController.listFriendLoad.value = false;
      },
    );
  }

  Future<void> processSendNotiAllUser(
      {required String title, required String body}) async {
    await FirebaseFirestore.instance
        .collection('user')
        .get()
        .then((value) async {
      for (var element in value.docs) {
        UserModel userModel = UserModel.fromMap(element.data());
        if (userModel.uidUser != appController.mainUid.toString()) {
          processSentNoti(title: title, body: body, token: userModel.token!);
        }
      }
    });
  }

  Future<void> genIdReal() async {
    await FirebaseFirestore.instance
        .collection('user')
        .get()
        .then((value) async {
      for (var element in value.docs) {
        UserModel userModel = UserModel.fromMap(element.data());
        String idReal = userModel.uidUser!.substring(0, 10);
        Map<String, dynamic> map = userModel.toMap();
        map['idReal'] = idReal;

        await FirebaseFirestore.instance
            .collection('user')
            .doc(element.id)
            .update(map)
            .then((value) => print('genIdReal Success'));
      }
    });
  }

  Future<void> makeReadChat() async {
    await FirebaseFirestore.instance
        .collection('privatechat')
        .doc(appController.docIdPrivateChats.last)
        .collection('chat')
        .get()
        .then((value) async {
      for (var element in value.docs) {
        ChatModel chatModel = ChatModel.fromMap(element.data());
        if (!chatModel.readed!) {
          Map<String, dynamic> map = chatModel.toMap();
          map['readed'] = true;

          await FirebaseFirestore.instance
              .collection('privatechat')
              .doc(appController.docIdPrivateChats.last)
              .collection('chat')
              .doc(element.id)
              .update(map)
              .then((value) => null);
        }
      }
    });
  }

  String findUrlImageWork({required List<ChatModel> chatmodels}) {
    String result = '';
    for (var element in chatmodels) {
      if (element.urlRealPost.isNotEmpty) {
        result = element.urlRealPost;
      }
    }
    return result;
  }

  String findContentMessage({required List<ChatModel> chatmodels}) {
    String result = '';
    for (var element in chatmodels) {
      if (element.message.isNotEmpty) {
        result = element.message;
      }
    }
    return result;
  }

  Future<void> freshUserModelLogin() async {
    var user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get()
        .then((value) {
      if (value.data() != null) {
        UserModel userModel = UserModel.fromMap(value.data()!);
        appController.userModelsLogin.add(userModel);
      }
    });
  }

  Future<void> readAllChatOwner({required String docIdRoom}) async {
    if (appController.chatOwnerModels.isNotEmpty) {
      appController.chatOwnerModels.clear();
    }

    FirebaseFirestore.instance
        .collection('room')
        .doc(docIdRoom)
        .collection('chatOwner')
        .orderBy('timestamp')
        .snapshots()
        .listen((event) {
      if (appController.chatOwnerModels.isNotEmpty) {
        appController.chatOwnerModels.clear();
      }

      for (var element in event.docs) {
        ChatModel model = ChatModel.fromMap(element.data());
        appController.chatOwnerModels.add(model);
      }
    });
  }

  Future<void> aboutNoti({required BuildContext context}) async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? token = await firebaseMessaging.getToken();
    if (token != null) {
      print('##24mar token ----> $token');
      print('##24mar uidLogin ---> ${appController.mainUid}');

      await FirebaseFirestore.instance
          .collection('user')
          .doc(appController.mainUid.value)
          .get()
          .then((value) async {
        UserModel userModel = UserModel.fromMap(value.data()!);
        Map<String, dynamic> map = userModel.toMap();
        print('##24mar map before ==> $map');

        map['token'] = token;
        await FirebaseFirestore.instance
            .collection('user')
            .doc(appController.mainUid.value)
            .update(map);
      });
    }

    FirebaseMessaging.onMessage.listen((event) {
      print('##5june onMessage Work body --> ${event.notification!.body!}');

      activeReceiveNoti(
          title: event.notification!.title!,
          body: event.notification!.body!,
          statusOnMessage: true,
          context: context);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      activeReceiveNoti(
          title: event.notification!.title!,
          body: event.notification!.body!,
          statusOnMessage: false,
          context: context);
    });
  }

  Future<void> activeReceiveNoti(
      {required String title,
      required String body,
      required bool statusOnMessage,
      required BuildContext context}) async {
    if (body.contains('#')) {
      var bodys = body.split('#');

      print('##5june bodys last ---> ${bodys.last}');

      try {
        int indexChat = int.parse(bodys.last);

        print('##5june  indexChat ---> $indexChat');

        AppDialog(context: context).normalDialog(
          title: title,
          leadingWidget: const WidgetImage(path: 'images/icon.png', size: 80),
          contentWidget: WidgetText(
            text: body,
            textStyle: AppConstant().h3Style(color: Colors.black),
          ),
          actions: [
            WidgetTextButton(
              text: 'ดู',
              pressFunc: () {
                Get.back();
                Get.to(const CommentChat());
              },
            ),
            WidgetTextButton(
              text: 'ไว้ภายหลัง',
              pressFunc: () {
                Get.back();
              },
            )
          ],
        );
      } on Exception catch (e) {
        print('error at activeReceiveNoti --> $e');
      }
    } else {
      AppDialog(context: context).normalDialog(
        title: title,
        leadingWidget: const WidgetImage(path: 'images/icon.png', size: 80),
        contentWidget: WidgetText(
          text: body,
          textStyle: AppConstant().h3Style(color: Colors.black),
        ),
        actions: [
          WidgetTextButton(
            text: 'ดู',
            pressFunc: () {
              Get.back();
              Get.offAll(const MainPageView());
            },
          ),
          WidgetTextButton(
            text: 'ไว้ภายหลัง',
            pressFunc: () {
              Get.back();
            },
          )
        ],
      );
    }
  }

  Future<void> findArrayFriendUid() async {
    if (appController.uidFriends.isNotEmpty) {
      appController.uidFriends.clear();
      appController.userModelPrivateChats.clear();
      appController.unReads.clear();
    }
    var result =
        await FirebaseFirestore.instance.collection('privatechat').get();

    if (result.docs.isNotEmpty) {
      for (var element in result.docs) {
        //private ทั้งหมด
        PrivateChatModel privateChatModel =
            PrivateChatModel.fromMap(element.data());

        String docIdPrivatechat = element.id;

        if (privateChatModel.uidchats.contains(appController.mainUid.value)) {
          print('##19mar uidChats ---> ${privateChatModel.uidchats}');
          for (var element in privateChatModel.uidchats) {
            if (element != appController.mainUid.value) {
              appController.uidFriends.add(element);
              await findUserModel(uid: element).then((value) async {
                appController.userModelPrivateChats.add(value!);

                await FirebaseFirestore.instance
                    .collection('privatechat')
                    .doc(docIdPrivatechat)
                    .collection('chat')
                    .get()
                    .then((value) {
                  int unRead = 0;
                  if (value.docs.isNotEmpty) {
                    for (var element in value.docs) {
                      ChatModel chatModel = ChatModel.fromMap(element.data());
                      if (!chatModel.readed!) {
                        if (chatModel.uidChat !=
                            appController.mainUid.toString()) {
                          unRead++;
                        }
                      }
                    }
                  }

                  print(
                      '##12april docIdPrivatechat ที่มีการ Chat ---> $docIdPrivatechat unRead ===> $unRead');
                  appController.unReads.add(unRead);
                  appController.load.value = false;
                });
              });
            }
          }
        }
      }
    }
  }

  bool compareCurrentTime({required DateTime otherDatetime}) {
    DateTime currentDateTime = DateTime.now();
    DateTime curOnlyDate = DateTime(
        currentDateTime.year, currentDateTime.month, currentDateTime.day);
    DateTime otherOnlyDate =
        DateTime(otherDatetime.year, otherDatetime.month, otherDatetime.day);

    bool result = false; // false วันไม่ตรงกัน
    if (curOnlyDate.compareTo(otherOnlyDate) == 0) {
      result = true;
    }

    return result;
  }

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
        readAllUserModel().then((value) async {
          UserModel? havePhoneUserModel;

          bool havePhone = false;

          print(
              '##13may userModels.length ---->>>${appController.userModels.length}');

          for (var element in appController.userModels) {
            if (element.phoneNumber == phoneNumber) {
              havePhone = true;
              havePhoneUserModel = element;
            }
          }
          print('##13may havePhone = $havePhone');

          if (havePhone) {
            print('##13may เคยเอาเบอร์นี่ไปสมัครแล้ว');
            print('##13may havePhoneModel ---> ${havePhoneUserModel!.toMap()}');

            await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: havePhoneUserModel.email!,
                    password: havePhoneUserModel.password!)
                .then((value) {
              appController.mainUid.value = value.user!.uid;
              Get.offAllNamed('/mainPageView');
            });
          } else {
            print('##13may เบอร์ใหม่');

            print('##13may ต่อไปก็ไป สมัครสมาชิกใหม่');

            String email = 'phone$phoneNumber@realpost.com';
            String password = '123456';

            await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: email, password: password)
                .then((value) {
              String uidUser = value.user!.uid;
              appController.mainUid.value = uidUser;
              print('##13may uidUser ---> $uidUser');
              Get.offAll(DisplayName(
                  uidLogin: uidUser,
                  phoneNumber: phoneNumber,
                  email: email,
                  password: password));
            }).catchError((onError) {
              print(
                  '##13may onError on create new accoount ---> ${onError.message}');
            });
          }
        });
      } else {
        appController.showFalseOTP.value = true;

        // AppSnackBar().normalSnackBar(
        //   title: 'OTP ผิด',
        //   message: 'กรอกใหม่อีกครั้ง',
        //   second: 3,
        //   textColor: Colors.red,
        // );
      }
    }).catchError((onError) {
      print('##22feb errer code 400');

      appController.showFalseOTP.value = true;

      // AppSnackBar().normalSnackBar(
      //   title: 'OTP ผิด',
      //   message: 'กรอกใหม่อีกครั้ง',
      //   second: 3,
      //   textColor: Colors.red,
      // );
    });
  }

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
        // Get.back();

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
        timeGroup: timeGroup,
        roomPublic: appController.roomPublic.value);

    return roomModel;
  }

  Future<void> initialSetup({required BuildContext context}) async {
    appController.readAllRoom().then((value) {
      appController.noRoom.value = false;

      appController.processReadCommentSalses();

      if (appController.noRoom.value) {
        Get.to(const TakePhotoOnly());
      } else {
        print('##1april Have Room');
      }

      appController.readAllChat(docIdRoom: appController.docIdRooms[0]);
      AppService().readAllChatOwner(docIdRoom: appController.docIdRooms[0]);

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
      print('##17mar insert new PrivateChatSuccess');
    });
  }

  Future<ChatModel> createChatModel(
      {String? urlBigImage, String? urlRealPost}) async {
    print('createChatmethod work');
    print('xFiles ---> ${appController.xFiles.length}');
    ChatModel chatModel;

    if (appController.xFiles.isEmpty) {
      //ไม่มี album

      print('##20mar WorkHere');

      chatModel = ChatModel(
        message: appController.messageChats.isEmpty
            ? ''
            : appController.messageChats.last,
        timestamp: Timestamp.fromDate(DateTime.now()),
        uidChat: appController.mainUid.value,
        urlRealPost: urlRealPost ?? '',
        disPlayName: appController.userModelsLogin.last.displayName!,
        urlAvatar: appController.userModelsLogin.last.urlAvatar ??
            AppConstant.urlAvatar,
        article: '',
        link: '',
        geoPoint: appController.shareLocation.value
            ? GeoPoint(appController.positions[0].latitude,
                appController.positions[0].longitude)
            : null,
        albums: [],
        urlBigImage: urlBigImage ?? '',
        urlMultiImages: [],
        up: 0,
        amountComment: 0,
        amountGraph: 0,
      );
    } else {
      //มี album
      print('มี album');

      var albums = await processUploadMultiPhoto();

      chatModel = ChatModel(
        message: appController.messageChats.isEmpty
            ? ''
            : appController.messageChats.last,
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
        urlBigImage: urlBigImage ?? '',
        urlMultiImages: [],
        up: 0,
        amountComment: 0,
        amountGraph: 0,
      );
    }

    print(
        '##8jan at createModel app service chartModel ==> ${chatModel.toMap()}');

    return chatModel;
  }

  Future<void> processChooseMultiImage() async {
    AppController appController = Get.put(AppController());

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

  Future<void> processChooseMultiImageChat() async {
    AppController appController = Get.put(AppController());

    if (appController.xFiles.isNotEmpty) {
      appController.xFiles.clear();
    }

    await ImagePicker()
        .pickMultiImage(maxWidth: 800, maxHeight: 800)
        .then((value) {
      appController.xFiles.addAll(value);
    });
  }

  Future<void> takePhotoforMultiImage() async {
    XFile? xFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxWidth: 800, maxHeight: 800);
    if (xFile != null) {
      if (appController.xFiles.length <= 9) {
        appController.xFiles.add(xFile);
      } else {
        Get.snackbar(
            'คุณเลือกภาพเกินที่กำหนด', 'เราอนุญาติให้เลือกภาพไม่เกิน 9 รูป');
      }
    }
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
      required String docIdRoom,
      String? collection,
      String? collectionChat}) async {
    AppController appController = Get.put(AppController());

    DocumentReference reference = FirebaseFirestore.instance
        .collection(collection ?? 'room')
        .doc(docIdRoom)
        .collection(collectionChat ?? 'chat')
        .doc();

    await reference.set(chatModel.toMap()).then((value) async {
      String docIdChat = reference.id;

      print('##8june docIdChat = $docIdChat');
      AppService().insertCommentChat(commentChatModel: chatModel).then((value) {
        print('##8june Add coment Success');
      });

      processSendNotiAllUser(
          title: 'มีโพสใหม่ ของคุณ ${chatModel.disPlayName}',
          body: chatModel.message);

      appController.shareLocation.value = false;
      appController.messageChats.clear();
      appController.fileRealPosts.clear();
    });
  }

  Future<void> processSentNoti(
      {required String title,
      required String body,
      required String token}) async {
    print('##5june body --> $body');
    print('##5june token processSentNoti ---> $token');

    String urlApi =
        'https://www.androidthai.in.th/realpost/apiNotiRealPost.php?isAdd=true&token=$token&body=$body&title=$title';
    await Dio().get(urlApi).then((value) {
      print('##5june Sent Noti Success');
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

  Future<List<String>> processUploadMultiImageChat() async {
    AppController appController = Get.put(AppController());
    var urlMultiImageChats = <String>[];

    for (var element in appController.xFiles) {
      File file = File(element.path);
      String? url = await processUploadPhoto(file: file, path: 'chat');
      urlMultiImageChats.add(url!);
    }
    return urlMultiImageChats;
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
      print('##20april update Room Success');
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
