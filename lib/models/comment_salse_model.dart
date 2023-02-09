// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class CommentSalseModel {
  final String amountSalse;
  final String name;
  final Timestamp timeComment;
  final String totalPrice;
  final String uid;
  final String urlAvatar;
  final bool single;
  CommentSalseModel({
    required this.amountSalse,
    required this.name,
    required this.timeComment,
    required this.totalPrice,
    required this.uid,
    required this.urlAvatar,
    required this.single,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'amountSalse': amountSalse,
      'name': name,
      'timeComment': timeComment,
      'totalPrice': totalPrice,
      'uid': uid,
      'urlAvatar': urlAvatar,
      'single': single,
    };
  }

  factory CommentSalseModel.fromMap(Map<String, dynamic> map) {
    return CommentSalseModel(
      amountSalse: (map['amountSalse'] ?? '') as String,
      name: (map['name'] ?? '') as String,
      timeComment: (map['timeComment'] ),
      totalPrice: (map['totalPrice'] ?? '') as String,
      uid: (map['uid'] ?? '') as String,
      urlAvatar: (map['urlAvatar'] ?? '') as String,
      single: (map['single'] ?? true) as bool,
    );
  }

  // timeComment: (map['timeComment'] ),

  String toJson() => json.encode(toMap());

  factory CommentSalseModel.fromJson(String source) =>
      CommentSalseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
