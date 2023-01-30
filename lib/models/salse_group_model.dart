import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SalseGroupModel {
  final Map<String, dynamic> map;
  SalseGroupModel({
    required this.map,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'map': map,
    };
  }

  factory SalseGroupModel.fromMap(Map<String, dynamic> map) {
    return SalseGroupModel(
      map: Map<String, dynamic>.from(map['map'] ?? {}),
    );
  }

  String toJson() => json.encode(toMap());

  factory SalseGroupModel.fromJson(String source) => SalseGroupModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
