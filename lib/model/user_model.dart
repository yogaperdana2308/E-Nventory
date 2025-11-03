import 'dart:convert';

class UserModel {
  int? id;
  String username;
  String email;
  int nomorhp;
  String password;
  UserModel({
    this.id,
    required this.username,
    required this.email,
    required this.nomorhp,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
      'nomorhp': nomorhp,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int,
      username: map['username'] as String,
      email: map['email'] as String,
      nomorhp: map['nomorhp'] as int,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
