//listing model

import 'package:cloud_firestore/cloud_firestore.dart';

class Listingbs {
  final String roomno;
  final List<dynamic> count;
  final String phone;
  final String date;
  final String total;
  final String uId;

  Listingbs(
    this.roomno,
    this.count,
    this.phone,
    this.date,
    this.total,
    this.uId,
  );

  //get all listings from database

  factory Listingbs.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Listingbs(
      data['roomno'] ?? '',
      data['count'] ?? '',
      data['phone'] ?? '',
      data['date'] ?? '',
      data['total'] ?? '',
      data['uId'] ?? '',
    );
  }

  //initialize listing

  Map<String, dynamic> toMap() {
    return {
      'roomno': roomno,
      'count': count,
      'phone': phone,
      'date': date,
      'total': total,
      'uId': uId,
    };
  }

//add one listing to array of listings
}
