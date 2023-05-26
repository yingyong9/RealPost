import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class StatDataModel {
  final String docIdChat;
  final int amountGraph;
  final int amountComment;
  final int amountUp;
  StatDataModel({
    required this.docIdChat,
    required this.amountGraph,
    required this.amountComment,
    required this.amountUp,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docIdChat': docIdChat,
      'amountGraph': amountGraph,
      'amountComment': amountComment,
      'amountUp': amountUp,
    };
  }

  factory StatDataModel.fromMap(Map<String, dynamic> map) {
    return StatDataModel(
      docIdChat: (map['docIdChat'] ?? '') as String,
      amountGraph: (map['amountGraph'] ?? 0) as int,
      amountComment: (map['amountComment'] ?? 0) as int,
      amountUp: (map['amountUp'] ?? 0) as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory StatDataModel.fromJson(String source) => StatDataModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
