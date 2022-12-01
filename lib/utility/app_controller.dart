import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:realpost/models/room_model.dart';
import 'package:realpost/models/stamp_model.dart';

class AppController extends GetxController {
  RxList<RoomModel> roomModels = <RoomModel>[].obs;
  RxList<String> docIdRooms = <String>[].obs;
  RxList<StampModel> stampModels = <StampModel>[].obs;
  RxList<String> emojiAddRoomChooses = <String>[].obs;

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
