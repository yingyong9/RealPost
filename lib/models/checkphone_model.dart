import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CheckPhoneModel {
  final String uid;
  CheckPhoneModel({
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
    };
  }

  factory CheckPhoneModel.fromMap(Map<String, dynamic> map) {
    return CheckPhoneModel(
      uid: (map['uid'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CheckPhoneModel.fromJson(String source) => CheckPhoneModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
