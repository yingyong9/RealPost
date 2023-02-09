import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class StampModel {
  final String url;
  StampModel({
    required this.url,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
    };
  }

  factory StampModel.fromMap(Map<String, dynamic> map) {
    return StampModel(
      url: (map['url'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory StampModel.fromJson(String source) => StampModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
