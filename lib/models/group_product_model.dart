import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class GroupProductModel {
  final String nameGroup;
  GroupProductModel({
    required this.nameGroup,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nameGroup': nameGroup,
    };
  }

  factory GroupProductModel.fromMap(Map<String, dynamic> map) {
    return GroupProductModel(
      nameGroup: (map['nameGroup'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupProductModel.fromJson(String source) => GroupProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
