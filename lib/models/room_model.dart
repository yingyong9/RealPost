import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class RoomModel {
  final String uidCreate;
  final String room;
  final String urlRoom;
  final Timestamp timestamp;

  RoomModel({
    required this.uidCreate,
    required this.room,
    required this.urlRoom,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uidCreate': uidCreate,
      'room': room,
      'urlRoom': urlRoom,
      'timestamp': timestamp,
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      uidCreate: (map['uidCreate'] ?? '') as String,
      room: (map['room'] ?? '') as String,
      urlRoom: (map['urlRoom'] ?? '') as String,
      timestamp: (map['timestamp']),
    );
  }

  String toJson() => json.encode(toMap());

  factory RoomModel.fromJson(String source) =>
      RoomModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
