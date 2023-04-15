import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String? displayName;
  final String? urlAvatar;
  final String? phoneNumber;
  final String? uidUser;
  final String? email;
  final String? password;
  final String? token;
  final String? idReal;

  UserModel({
    this.displayName,
    this.urlAvatar,
    this.phoneNumber,
    this.uidUser,
    this.email,
    this.password,
    this.token,
    this.idReal,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'displayName': displayName,
      'urlAvatar': urlAvatar,
      'phoneNumber': phoneNumber,
      'uidUser': uidUser,
      'email': email,
      'password': password,
      'token': token,
      'idReal': idReal,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      displayName: map['displayName'] ?? '',
      urlAvatar: map['urlAvatar'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      uidUser: map['uidUser'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      token: map['token'] ?? '',
      idReal: map['idReal'] ?? '',
    );
  }

  // displayName: map['displayName'] ?? '',
  // urlAvatar: map['urlAvatar']?? '',
  // phoneNumber: map['phoneNumber'] ?? '',
  // uidUser: map['uidUser'] ?? '',
  // email: map['email']?? '',
  // password: map['password'] ?? '',
  // token: map['token']?? '',

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
