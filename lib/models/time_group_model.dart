import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class TimeGroupModel {
  final String id;
  final String times;
  TimeGroupModel({
    required this.id,
    required this.times,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'times': times,
    };
  }

  factory TimeGroupModel.fromMap(Map<String, dynamic> map) {
    return TimeGroupModel(
      id: (map['id'] ?? '') as String,
      times: (map['times'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeGroupModel.fromJson(String source) => TimeGroupModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
