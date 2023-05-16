// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String message;
  final Timestamp timestamp;
  final String uidChat;
  final String disPlayName;
  final String urlAvatar;
  final String urlRealPost;
  final String? article;
  final String? link;
  final GeoPoint? geoPoint;
  final List<String> albums;
  final String? urlBigImage;
  final bool? readed;
  final int? favorit;
  final int? traffic;

  ChatModel({
    required this.message,
    required this.timestamp,
    required this.uidChat,
    required this.disPlayName,
    required this.urlAvatar,
    required this.urlRealPost,
    this.article,
    this.link,
    this.geoPoint,
    required this.albums,
    this.urlBigImage,
    this.readed,
    this.favorit,
    this.traffic,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'timestamp': timestamp,
      'uidChat': uidChat,
      'disPlayName': disPlayName,
      'urlAvatar': urlAvatar,
      'urlRealPost': urlRealPost,
      'article': article,
      'link': link,
      'geoPoint': geoPoint,
      'albums': albums,
      'urlBigImage': urlBigImage,
      'readed': readed,
      'favorit': favorit,
      'traffic': traffic,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      message: (map['message'] ?? '') as String,
      timestamp: (map['timestamp']),
      uidChat: (map['uidChat'] ?? '') as String,
      disPlayName: (map['disPlayName'] ?? '') as String,
      urlAvatar: (map['urlAvatar'] ?? '') as String,
      urlRealPost: (map['urlRealPost'] ?? '') as String,
      article: map['article'] != null ? map['article'] as String : null,
      link: map['link'] != null ? map['link'] as String : null,
      geoPoint: map['geoPoint'] ?? const GeoPoint(0, 0),
      albums: List<String>.from(map['albums'] ?? []),
      urlBigImage:
          map['urlBigImage'] != null ? map['urlBigImage'] as String : null,
      readed: map['readed'] ?? false,
      favorit: map['favorit'] ?? 0,
      traffic: map['traffic']?? 0,
    );
  }

  // message: (map['message'] ?? '') as String,
  //     timestamp: (map['timestamp']),
  //     uidChat: (map['uidChat'] ?? '') as String,
  //     disPlayName: (map['disPlayName'] ?? '') as String,
  //     urlAvatar: (map['urlAvatar'] ?? '') as String,
  //     urlRealPost: (map['urlRealPost'] ?? '') as String,
  //     article: map['article'] != null ? map['article'] as String : null,
  //     link: map['link'] != null ? map['link'] as String : null,
  //     geoPoint: map['geoPoint'] ?? const GeoPoint(0, 0),
  //     albums: List<String>.from(map['albums'] ?? []),
  //     urlBigImage:
  //         map['urlBigImage'] != null ? map['urlBigImage'] as String : null,
  //     readed: map['readed'] ?? false,
  //     favorit: map['favorit'] ?? 0,

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
