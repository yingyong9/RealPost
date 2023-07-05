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
  final bool? checkInOwnerChat;
  final List<String> urlMultiImages;
  final int? up;
  final int? down;
  final int amountComment;
  final int amountGraph;
  final String? price;
  final String? amount;
  final String? phone;
  final String? line;
  final List<String>? answers;
  final List<String>? avatars;
  final List<String>? names;
  final List<String>? imageSingle;
  final String? topComment;

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
    this.checkInOwnerChat,
    required this.urlMultiImages,
    this.up,
    this.down,
    required this.amountComment,
    required this.amountGraph,
    this.price,
    this.amount,
    this.phone,
    this.line,
    this.answers,
    this.avatars,
    this.names,
    this.imageSingle,
    this.topComment,
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
      'checkInOwnerChat': checkInOwnerChat,
      'urlMultiImages': urlMultiImages,
      'up': up,
      'down': down,
      'amountComment': amountComment,
      'amountGraph': amountGraph,
      'price': price,
      'amount': amount,
      'phone': phone,
      'line': line,
      'answers': answers,
      'avatars': avatars,
      'names': names,
      'imageSingle': imageSingle,
      'topComment': topComment,
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
      traffic: map['traffic'] ?? 0,
      checkInOwnerChat: map['checkInOwnerChat'] ?? false,
      urlMultiImages: List<String>.from(map['urlMultiImages'] ?? []),
      up: (map['up'] ?? 0) as int,
      down: (map['down'] ?? 0) as int,
      amountComment: (map['amountComment'] ?? 0) as int,
      amountGraph: (map['amountGraph'] ?? 0) as int,
      price: (map['price'] ?? '') as String,
      amount: (map['amount'] ?? '') as String,
      phone: (map['phone'] ?? '') as String,
      line: (map['line'] ?? '') as String,
      answers: List<String>.from(map['answers'] ?? []),
      avatars: List<String>.from(map['avatars'] ?? []),
      names: List<String>.from(map['names'] ?? []),
      imageSingle: List<String>.from(map['names'] ?? []),
      topComment: (map['topComment'] ?? '') as String,
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
  //     traffic: map['traffic'] ?? 0,
  //     checkInOwnerChat: map['checkInOwnerChat'] ?? false,
  //     urlMultiImages: List<String>.from(map['urlMultiImages'] ?? []),
  //     up: (map['up'] ?? 0) as int,
  // down: (map['down'] ?? 0) as int,
  //     amountComment: (map['amountComment'] ?? 0) as int,
  //     amountGraph: (map['amountGraph'] ?? 0) as int,
  //     price: (map['price'] ?? '') as String,
  //     amount: (map['amount'] ?? '') as String,
  //     phone: (map['phone'] ?? '') as String,
  //     line: (map['line'] ?? '') as String,
  //     answers: List<String>.from(map['answers'] ?? []),
  //     avatars: List<String>.from(map['avatars'] ?? []),
  //     names: List<String>.from(map['names'] ?? []),
  //     imageSingle: List<String>.from(map['names'] ?? []),

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
