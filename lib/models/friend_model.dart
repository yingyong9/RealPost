import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class FriendModel {
  final List<String> uidFriends;
  FriendModel({
    required this.uidFriends,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uidFriends': uidFriends,
    };
  }

  factory FriendModel.fromMap(Map<String, dynamic> map) {
    return FriendModel(
      uidFriends: List<String>.from(map['uidFriends'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory FriendModel.fromJson(String source) => FriendModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
