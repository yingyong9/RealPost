import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PrivateChatModel {
  final List<String> uidchats;
  PrivateChatModel({
    required this.uidchats,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uidchats': uidchats,
    };
  }

  factory PrivateChatModel.fromMap(Map<String, dynamic> map) {
    return PrivateChatModel(
      uidchats: List<String>.from(map['uidchats'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory PrivateChatModel.fromJson(String source) => PrivateChatModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
