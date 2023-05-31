// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class AnswerModel {
  final String answer;
  final String avatarAnswer;
  final String nameAnswer;
  final String uidAnswer;
  final Timestamp timestamp;
  AnswerModel({
    required this.answer,
    required this.avatarAnswer,
    required this.nameAnswer,
    required this.uidAnswer,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'answer': answer,
      'avatarAnswer': avatarAnswer,
      'nameAnswer': nameAnswer,
      'uidAnswer': uidAnswer,
      'timestamp': timestamp,
    };
  }

  factory AnswerModel.fromMap(Map<String, dynamic> map) {
    return AnswerModel(
      answer: (map['answer'] ?? '') as String,
      avatarAnswer: (map['avatarAnswer'] ?? '') as String,
      nameAnswer: (map['nameAnswer'] ?? '') as String,
      uidAnswer: (map['uidAnswer'] ?? '') as String,
      timestamp: (map['timestamp']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AnswerModel.fromJson(String source) => AnswerModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
