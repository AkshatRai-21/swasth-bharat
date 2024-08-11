import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class User {
  final String id;
  final String name;
  final int? age;
  final String? gender;
  final String email;
  final String password;
  final String token;
  final String type;
  final List<dynamic>? favourites;
  User({
    required this.id,
    required this.name,
    this.age,
    this.gender,
    required this.email,
    required this.password,
    required this.token,
    required this.type,
    this.favourites,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'email': email,
      'password': password,
      'token': token,
      'type': type,
      'favourites': favourites,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] as String,
      name: map['name'] as String,
      age: map['age'] != null ? map['age'] as int : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      email: map['email'] as String,
      password: map['password'] as String,
      token: map['token'] as String,
      type: map['type'] != null ? map['type'] as String : "user",
      favourites: map['favourites'] != null
          ? List<dynamic>.from((map['favourites'] as List<dynamic>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
