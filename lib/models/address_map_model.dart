import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AddressMapModel {
  final String geocode;
  final String country;
  final String province;
  final String district;
  final String subdistrict;
  final String postcode;
  final String road;
  AddressMapModel({
    required this.geocode,
    required this.country,
    required this.province,
    required this.district,
    required this.subdistrict,
    required this.postcode,
    required this.road,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'geocode': geocode,
      'country': country,
      'province': province,
      'district': district,
      'subdistrict': subdistrict,
      'postcode': postcode,
      'road': road,
    };
  }

  factory AddressMapModel.fromMap(Map<String, dynamic> map) {
    return AddressMapModel(
      geocode: (map['geocode'] ?? '') as String,
      country: (map['country'] ?? '') as String,
      province: (map['province'] ?? '') as String,
      district: (map['district'] ?? '') as String,
      subdistrict: (map['subdistrict'] ?? '') as String,
      postcode: (map['postcode'] ?? '') as String,
      road: (map['road'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressMapModel.fromJson(String source) => AddressMapModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
