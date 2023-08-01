//listing model

import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final List<dynamic> price;

  Users(
    this.uid,
    this.name,
    this.email,
    this.phone,
    this.price,
  );

  factory Users.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Users(
      data['uid'] ?? '',
      data['name'] ?? '',
      data['email'] ?? '',
      data['phone'] ?? '',
      data['price'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'price': price,
    };
  }
}
