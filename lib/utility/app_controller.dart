// ignore_for_file: avoid_print

import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realpost/models/address_map_model.dart';
import 'package:realpost/models/chat_model.dart';
import 'package:realpost/models/comment_salse_model.dart';
import 'package:realpost/models/group_product_model.dart';
import 'package:realpost/models/private_chat_model.dart';
import 'package:realpost/models/room_model.dart';
import 'package:realpost/models/salse_group_model.dart';
import 'package:realpost/models/stamp_model.dart';
import 'package:realpost/models/time_group_model.dart';
import 'package:realpost/models/user_model.dart';
import 'package:realpost/utility/app_constant.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppController extends GetxController {
  RxList<RoomModel> roomModels = <RoomModel>[].obs;
  RxList<String> docIdRooms = <String>[].obs;
  RxList<String> docIdRoomChooses = <String>[].obs;
  RxList<UserModel> userModelAtRooms = <UserModel>[].obs;

  RxList<List<ChatModel>> listChatModels = <List<ChatModel>>[].obs;
  RxList<ChatModel> lastChatModelLogins = <ChatModel>[].obs;
  RxList<StampModel> stampModels = <StampModel>[].obs;
  RxList<String> emojiAddRoomChooses = <String>[].obs;
  RxList<ChatModel> chatModels = <ChatModel>[].obs;
  RxList<String> addressMaps = <String>[].obs;

  RxBool load = true.obs;
  RxBool shareLocation = false.obs;

  RxList<UserModel> userModels = <UserModel>[].obs;

  RxList<File> fileAvatars = <File>[].obs;
  RxList<String> urlAvatarChooses = <String>[].obs;
  RxList<File> fileRealPosts = <File>[].obs;
  RxList<String> urlRealPostChooses = <String>[].obs;
  RxList<String> messageChats = <String>[].obs;
  RxList<TextEditingController> articleControllers =
      <TextEditingController>[TextEditingController()].obs;
  RxList<Position> positions = <Position>[].obs;

  RxList<String> docIdPrivateChats = <String>[].obs;
  RxList<ChatModel> privateChatModels = <ChatModel>[].obs;

  RxList<String> links = <String>[].obs;
  RxList<XFile> xFiles = <XFile>[].obs;
  RxInt indexBodyMainPageView = 0.obs;
  RxList<File> cameraFiles = <File>[].obs;
  RxList<WebViewController> webViewControllers = <WebViewController>[].obs;
  RxList<VideoPlayerController> videoPlayControllers =
      <VideoPlayerController>[].obs;
  RxList<ChewieController> chewieControllers = <ChewieController>[].obs;
  RxBool safseProduct = false.obs;
  RxList<GroupProductModel> groupProductModels = <GroupProductModel>[].obs;
  RxList<String?> chooseGroupProducts = <String?>[null].obs;
  RxList<TimeGroupModel> timeGroupModels = <TimeGroupModel>[].obs;
  RxList<String> chooseTimeGroups = <String>[].obs;
  RxList<int> indexTabs = <int>[0].obs;
  RxInt amountSalse = 1.obs;

  RxList commentSalses = <CommentSalseModel>[].obs;
  RxList docIdCommentSalses = <String>[].obs;

  RxList salsegroups = <SalseGroupModel>[].obs;

  RxBool haveUserLoginInComment = false.obs;

  RxString docIdRoomClickHome = ''.obs;
  RxInt indexPageHome = 0.obs;

  RxInt timeOtp = AppConstant.timeCountsec.obs;

  RxString mainUid = ''.obs;

  RxList<bool> tabChooses = <bool>[].obs;

  Future<void> readSalseGroups({required String docIdCommentSalse}) async {
    if (salsegroups.isNotEmpty) {
      salsegroups.clear();
    }

    await FirebaseFirestore.instance
        .collection('room')
        .doc(docIdRooms[indexBodyMainPageView.value])
        .collection('commentsalse')
        .doc(docIdCommentSalse)
        .collection('salsegroup')
        .orderBy('timestamp')
        .get()
        .then((value) {
      for (var element in value.docs) {
        SalseGroupModel model = SalseGroupModel.fromMap(element.data());
        salsegroups.add(model);
      }
    });
  }

  Future<void> processReadCommentSalses() async {
    if (commentSalses.isNotEmpty) {
      commentSalses.clear();
      docIdCommentSalses.clear();
    }

    print(
        '##6mar processReadCommentSalse Work at indexBody --> ${indexBodyMainPageView.value}');
    var user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('room')
        .doc(docIdRooms[indexBodyMainPageView.value])
        .collection('commentsalse')
        .orderBy('timeComment', descending: true)
        .snapshots()
        .listen((event) {
      if (event.docs.isNotEmpty) {
        if (commentSalses.isNotEmpty) {
          commentSalses.clear();
          docIdCommentSalses.clear();
        }

        for (var element in event.docs) {
          CommentSalseModel model = CommentSalseModel.fromMap(element.data());
          commentSalses.add(model);
          docIdCommentSalses.add(element.id);

          print('##6mar uidComment ---> ${model.uid}');

          if (user!.uid == model.uid) {
            haveUserLoginInComment.value = true;
          }

          
        }
        print(
            '##6mar haveUserLoginInCommenent ---> ${haveUserLoginInComment.value} ');
        print('##6mar uidLogin อยู่ --> ${user!.uid}');
      }
    });
  }

  Future<void> readTimeGroup() async {
    await FirebaseFirestore.instance
        .collection('timesGroup')
        .orderBy('id')
        .get()
        .then((value) {
      for (var element in value.docs) {
        TimeGroupModel timeGroupModel = TimeGroupModel.fromMap(element.data());
        timeGroupModels.add(timeGroupModel);
      }
      chooseTimeGroups.add(timeGroupModels[0].times);
    });
  }

  Future<void> readGroupProduct() async {
    await FirebaseFirestore.instance
        .collection('groupProduct')
        .get()
        .then((value) {
      for (var element in value.docs) {
        GroupProductModel groupProductModel =
            GroupProductModel.fromMap(element.data());
        groupProductModels.add(groupProductModel);
      }
    });
  }

  void createVideoPlayControllers() {
    String urlVideo =
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

    //  String urlVideo =
    // 'https://firebasestorage.googleapis.com/v0/b/sharetravelung.appspot.com/o/flutterLand.mp4?alt=media&token=4ec7e35f-d77d-4cbe-bd06-626c31bedabb';

    VideoPlayerController videoPlayerController =
        VideoPlayerController.network(urlVideo)..initialize();
    ChewieController chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
    );
    chewieControllers.add(chewieController);
  }

  void createWebViewController() {
    WebViewController webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (progress) {},
        onPageStarted: (url) {},
        onPageFinished: (url) {},
        onWebResourceError: (error) {},
        onNavigationRequest: (request) {
          if (request.url.startsWith('https://www.youtube.com')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.parse(
          'https://webrtc.livestreaming.in.th/realpost/play.html?name=realpost001'));
    webViewControllers.add(webViewController);
  }

  Future<void> processFindDocIdPrivateChat(
      {required String uidLogin, required String uidFriend}) async {
    if (privateChatModels.isNotEmpty) {
      // docIdPrivateChats.clear();
      privateChatModels.clear();
    }

    await FirebaseFirestore.instance
        .collection('privatechat')
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        bool createNewPrivate = true;
        for (var element in value.docs) {
          PrivateChatModel privateChatModel =
              PrivateChatModel.fromMap(element.data());
          print(
              '##8feb $uidLogin, $uidFriend privateChatModel ---> ${privateChatModel.toMap()}');

          if ((privateChatModel.uidchats.contains(uidLogin)) &&
              (privateChatModel.uidchats.contains(uidFriend))) {
            createNewPrivate = false;
            docIdPrivateChats.add(element.id);

            print('##8feb docIdPrivateChat ---> ${docIdPrivateChats.last}');

            await FirebaseFirestore.instance
                .collection('privatechat')
                .doc(element.id)
                .collection('chat')
                .orderBy('timestamp', descending: true)
                .snapshots()
                .listen((event) {
              if (privateChatModels.isNotEmpty) {
                privateChatModels.clear();
              }
              for (var element2 in event.docs) {
                ChatModel model = ChatModel.fromMap(element2.data());
                privateChatModels.add(model);
              }
            });
          }
        }

        if (createNewPrivate) {
          AppService()
              .insertPrivateChat(uidLogin: uidLogin, uidFriend: uidFriend);
        }
      }
      load.value = false;
    });
  }

  Future<void> findUserModels() async {
    if (userModels.isNotEmpty) {
      userModels.clear();
    }
    var user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get()
        .then((value) {
      UserModel model = UserModel.fromMap(value.data()!);
      userModels.add(model);
    });
  }

  Future<void> readAllChat({required String docIdRoom}) async {
    if (chatModels.isNotEmpty) {
      chatModels.clear();
      addressMaps.clear();
    }

    FirebaseFirestore.instance
        .collection('room')
        .doc(docIdRoom)
        .collection('chat')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((event) async {
      load.value = false;
      if (event.docs.isNotEmpty) {
        if (chatModels.isNotEmpty) {
          chatModels.clear();
          addressMaps.clear();
        }

        for (var element in event.docs) {
          ChatModel model = ChatModel.fromMap(element.data());
          print('##8jan chatModel ==> ${model.toMap()}');
          chatModels.add(model);

          if (model.geoPoint!.latitude != 0) {
            String apiPath =
                'https://api.longdo.com/map/services/address?lon=${model.geoPoint!.longitude}&lat=${model.geoPoint!.latitude}&noelevation=1&key=cda17b2e1b8010bdfc353a0f83d59348';
            await Dio().get(apiPath).then((value) {
              print('##13dec value longDo ---> $value');
              AddressMapModel addressMapModel =
                  AddressMapModel.fromMap(value.data);
              String string =
                  '${addressMapModel.subdistrict} ${addressMapModel.district} ${addressMapModel.province} ${addressMapModel.postcode}';
              print('##13dec address ---> $string');
              addressMaps.add(string);
            });
          } else {
            addressMaps.add('');
          }
        }
      }
    });
  }

  Future<void> readAllStamp() async {
    if (stampModels.isNotEmpty) {
      stampModels.clear();
    }

    await FirebaseFirestore.instance.collection('stamp').get().then((value) {
      for (var element in value.docs) {
        StampModel model = StampModel.fromMap(element.data());
        stampModels.add(model);
      }
    });
  }

  Future<void> readAllRoom() async {
    if (roomModels.isNotEmpty) {
      roomModels.clear();
      docIdRooms.clear();
      listChatModels.clear();
      userModelAtRooms.clear();
    }
    await FirebaseFirestore.instance
        .collection('room')
        .orderBy('timestamp', descending: true)
        .get()
        .then((value) async {
      int indexPage = 0;
      var user = FirebaseAuth.instance.currentUser;
      var uidLogin = user!.uid;

      for (var element in value.docs) {
        RoomModel model = RoomModel.fromMap(element.data());
        roomModels.add(model);
        docIdRooms.add(element.id);

        if (uidLogin == model.uidCreate) {
          print('##3mar page ที่มี indexPage --> $indexPage');
          print('##3mar page ที่มี docIdRoom --> ${element.id}');
          docIdRoomClickHome.value = element.id;
          indexPageHome.value = indexPage;
        }

        UserModel? userModel =
            await AppService().findUserModel(uid: model.uidCreate);
        if (userModel != null) {
          userModelAtRooms.add(userModel);
        }

        var chatModels = <ChatModel>[];
        ChatModel? lateChatModel;
        var user = FirebaseAuth.instance.currentUser;
        bool check = true;

        FirebaseFirestore.instance
            .collection('room')
            .doc(element.id)
            .collection('chat')
            .orderBy('timestamp', descending: false)
            .snapshots()
            .listen((event) {
          if (event.docs.isEmpty) {
          } else {
            for (var element2 in event.docs) {
              ChatModel chatModel = ChatModel.fromMap(element2.data());
              chatModels.add(chatModel);

              if ((chatModel.uidChat == user!.uid) && check) {
                check = false;
                lateChatModel = chatModel;
              }
            }
          }
          listChatModels.add(chatModels);
          lastChatModelLogins.add(lateChatModel!);
        });
        indexPage++;
      }
    });
  }
}
