import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class RoomModel {
  final String uidCreate;
  final String room;

  final Timestamp timestamp;
  final String? urlCamera;
  final List<String> urlRooms;

  RoomModel({
    required this.uidCreate,
    required this.room,
    required this.timestamp,
    this.urlCamera,
    required this.urlRooms,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uidCreate': uidCreate,
      'room': room,
      'timestamp': timestamp,
      'urlCamera': urlCamera,
      'urlRooms': urlRooms,
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      uidCreate: (map['uidCreate'] ?? '') as String,
      room: (map['room'] ?? '') as String,
      timestamp: (map['timestamp']),
      urlCamera: (map['urlCamera'] ?? ''),
      urlRooms: List<String>.from(map['urlRooms'] ?? []),
    );
  }

  // timestamp: (map['timestamp']),
  // urlCamera: (map['urlCamera'] ?? ''),
  // urlRooms: List<String>.from(map['urlRooms'] ?? []),

  String toJson() => json.encode(toMap());

  factory RoomModel.fromJson(String source) =>
      RoomModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
