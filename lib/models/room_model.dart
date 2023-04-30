import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class RoomModel {
  final String uidCreate;
  final String room;
  final Timestamp timestamp;
  final String? urlCamera;
  final List<String> urlRooms;
  final String? detail;
  final bool? safeProduct;
  final String? groupProduct;
  final String? singlePrice;
  final String? minPrice;
  final String? totalPrice;
  final String? amountGroup;
  final String? stock;
  final String? timeGroup;
  final GeoPoint? geoPoint;
  final bool? displayCart;

  RoomModel({
    required this.uidCreate,
    required this.room,
    required this.timestamp,
    this.urlCamera,
    required this.urlRooms,
    this.detail,
    this.safeProduct,
    this.groupProduct,
    this.singlePrice,
    this.minPrice,
    this.totalPrice,
    this.amountGroup,
    this.stock,
    this.timeGroup,
    this.geoPoint,
    this.displayCart,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uidCreate': uidCreate,
      'room': room,
      'timestamp': timestamp,
      'urlCamera': urlCamera,
      'urlRooms': urlRooms,
      'detail': detail,
      'safeProduct': safeProduct,
      'groupProduct': groupProduct,
      'singlePrice': singlePrice,
      'minPrice': minPrice,
      'totalPrice': totalPrice,
      'amountGroup': amountGroup,
      'stock': stock,
      'timeGroup': timeGroup,
      'geoPoint': geoPoint,
      'displayCart': displayCart,
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      uidCreate: (map['uidCreate'] ?? '') as String,
      room: (map['room'] ?? '') as String,
      timestamp: (map['timestamp']),
      urlCamera: (map['urlCamera'] ?? ''),
      urlRooms: List<String>.from(map['urlRooms'] ?? []),
      detail: map['detail'] ?? '',
      safeProduct: map['safeProduct'] ?? false,
      groupProduct: map['groupProduct'] ?? '',
      singlePrice: map['singlePrice'] ?? '',
      totalPrice: map['totalPrice'] ?? '',
      amountGroup: map['amountGroup'] ?? '',
      stock: map['stock'] ?? '',
      timeGroup: map['timeGroup'] ?? '',
      geoPoint: map['geoPoint'] ?? const GeoPoint(0, 0),
      displayCart: map['displayCart'] ?? false,
    );
  }

  // uidCreate: (map['uidCreate'] ?? '') as String,
  //     room: (map['room'] ?? '') as String,
  //     timestamp: (map['timestamp']),
  //     urlCamera: (map['urlCamera'] ?? ''),
  //     urlRooms: List<String>.from(map['urlRooms'] ?? []),
  //     detail: map['detail'] ?? '',
  //     safeProduct: map['safeProduct'] ?? false,
  //     groupProduct: map['groupProduct'] ?? '',
  //     singlePrice: map['singlePrice'] ?? '',
  //     totalPrice: map['totalPrice'] ?? '',
  //     amountGroup: map['amountGroup'] ?? '',
  //     stock: map['stock'] ?? '',
  //     timeGroup: map['timeGroup'] ?? '',
  //     geoPoint: map['geoPoint'] ?? const GeoPoint(0, 0),
  //     displayCart: map['displayCart'] ?? false,

  String toJson() => json.encode(toMap());

  factory RoomModel.fromJson(String source) =>
      RoomModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
