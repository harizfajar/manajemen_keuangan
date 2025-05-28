import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String password;
  final String confirmPassword;
  final String email;
  final Timestamp createdAt;

  UserModel({
    this.id = "",
    this.name = "",
    this.password = "",
    this.confirmPassword = "",
    this.email = "",
    Timestamp? createdAt,
  }) : createdAt = createdAt ?? Timestamp.now();

  UserModel copyWith({
    String? id,
    String? name,
    String? password,
    String? confirmPassword,
    String? email,
    Timestamp? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'],
      email: data['email'],
      createdAt: data['createdAt'],
    );
  }
}
