import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SalseGroupModel {
  final Map<String, dynamic> map;
  final Timestamp timestamp;
  SalseGroupModel({
    required this.map,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'map': map,
      'timestamp': timestamp,
    };
  }

  factory SalseGroupModel.fromMap(Map<String, dynamic> map) {
    return SalseGroupModel(
      map: Map<String, dynamic>.from(map['map'] ?? {}),
      timestamp: (map['timestamp'] ),
    );
  }

  // map: Map<String, dynamic>.from(map['map'] ?? {}),

  String toJson() => json.encode(toMap());

  factory SalseGroupModel.fromJson(String source) =>
      SalseGroupModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
