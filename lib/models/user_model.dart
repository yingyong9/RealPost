import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String? displayName;
  final String? urlAvatar;
  final String? phoneNumber;
  final String? uidUser;
  final String? email;
  final String? password;

  UserModel({
    this.displayName,
    this.urlAvatar,
    this.phoneNumber,
    this.uidUser,
    this.email,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'displayName': displayName,
      'urlAvatar': urlAvatar,
      'phoneNumber': phoneNumber,
      'uidUser': uidUser,
      'email': email,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      displayName: map['displayName'] != null ? map['displayName'] as String : null,
      urlAvatar: map['urlAvatar'] != null ? map['urlAvatar'] as String : null,
      phoneNumber: map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      uidUser: map['uidUser'] != null ? map['uidUser'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
