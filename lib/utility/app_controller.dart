import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:realpost/models/chat_model.dart';
import 'package:realpost/models/room_model.dart';
import 'package:realpost/models/stamp_model.dart';
import 'package:realpost/models/user_model.dart';

class AppController extends GetxController {
  RxList<RoomModel> roomModels = <RoomModel>[].obs;
  RxList<String> docIdRooms = <String>[].obs;
  RxList<StampModel> stampModels = <StampModel>[].obs;
  RxList<String> emojiAddRoomChooses = <String>[].obs;
  RxList<ChatModel> chatModels = <ChatModel>[].obs;
  RxBool load = true.obs;
  RxList<UserModel> userModels = <UserModel>[].obs;
  RxList<File> fileAvatars = <File>[].obs;
  RxList<String> urlAvatarChooses = <String>[].obs;

  Future<void> findUserModels() async {
    userModels.clear();
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
    }

    FirebaseFirestore.instance
        .collection('room')
        .doc(docIdRoom)
        .collection('chat')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((event) {
      load.value = false;

      if (event.docs.isNotEmpty) {
        if (chatModels.isNotEmpty) {
          chatModels.clear();
        }

        for (var element in event.docs) {
          ChatModel model = ChatModel.fromMap(element.data());
          chatModels.add(model);
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
    }
    await FirebaseFirestore.instance
        .collection('room')
        .orderBy('timestamp', descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        RoomModel model = RoomModel.fromMap(element.data());
        roomModels.add(model);
        docIdRooms.add(element.id);
      }
    });
  }
}
