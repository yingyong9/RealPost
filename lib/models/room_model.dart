import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class RoomModel {
  final String uidCreate;
  final String room;
  RoomModel({
    required this.uidCreate,
    required this.room,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uidCreate': uidCreate,
      'room': room,
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      uidCreate: (map['uidCreate'] ?? '') as String,
      room: (map['room'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RoomModel.fromJson(String source) => RoomModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
