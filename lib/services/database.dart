//listing database

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../models/buysell.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../models/categ.dart';
import '../models/users.dart';

import '../authentication/auth.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid = ''});

  bool isNumeric(String s) {
    if (s == "") {
      return false;
    }
    return double.tryParse(s) != null;
  }

  Stream<List<Listingbs>> get listings {
    return listingCollection.snapshots().map(_listingListFromSnapshot);
  }

//.................................

  final CollectionReference listingCollection = FirebaseFirestore.instance
      .collection('rooms'); //collection name is listings

  //listing list from snapshot
  List<Listingbs> _listingListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Listingbs.fromFirestore(doc);
    }).toList();
  }

  Future updateUserData(
    String roomno,
    List<dynamic> count,
    String phone,
    String date,
    String total,
    String uId,
  ) async {
    try {
      // Create a reference to the Firestore collection
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('rooms');

      // Create a new document with a unique ID
      DocumentReference docRef = collectionRef.doc(uid + roomno.toString());

      // Set the data you want to add to the document
      Map<String, dynamic> data = {
        'roomno': roomno,
        'count': count,
        'phone': phone,
        'date': date,
        'total': total,
        'uId': uId,
      };

      // Add the data to the document without overwriting old data
      await docRef.set(data, SetOptions(merge: true));

      print('Data added successfully!');
    } catch (e) {
      print('Error adding data: $e');
    }
  }

  Future updateUserData2({
    String? roomno,
    List<dynamic>? count,
    String? phone,
    String? date,
    String? total,
    String? uId,
  }) async {
    return await listingCollection3.doc(uid + roomno.toString()).set({
      'roomno': roomno,
      'phone': phone,
      'uid': uid,
      'count': count,
      'date': date,
      'total': total,
    });
  }

  Future<void> deleteListing(String roomno, String date) async {
    await listingCollection
        .where('roomno', isEqualTo: roomno) // add condition for name
        .where('date', isEqualTo: date) // add condition for date
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        document.reference
            .delete()
            .then((_) => print('Deleted'))
            .catchError((error) => print('Delete failed: $error'));
      });
    });
  }

  Future<List<Listingbs>> sortListingsByDate() {
    final User? uid = FirebaseAuth.instance.currentUser;
    final User user = uid!;

    return listingCollection
        .orderBy('date', descending: true)
        .where('uId', isEqualTo: user.uid)
        .get()
        .then((value) => _listingListFromSnapshot(value));
  }

  Future<List<Listingbs>> getSearchListing2(String search) async {
    final User? uid = FirebaseAuth.instance.currentUser;
    final User user = uid!;
    search = search.toLowerCase();
    return listingCollection
        .orderBy('date', descending: true)
        .where('roomno', isEqualTo: search)
        .where('uId', isEqualTo: user.uid)
        .get()
        .then((value) => _listingListFromSnapshot(value));
  }

//.................................

  final CollectionReference listingCollection3 = FirebaseFirestore.instance
      .collection('Users'); //collection name is listings

  List<Users> _listingListFromSnapshot3(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Users.fromFirestore(doc);
    }).toList();
  }

//get current user details  from firestore
  Future<Users?> getUserDetails() async {
    final snapshot =
        await listingCollection3.where('uid', isEqualTo: uid).get();
    List<Users> users = _listingListFromSnapshot3(snapshot);
    if (users.isNotEmpty) {
      return users[0];
    } else {
      print('no user found');
      return Users(
        uid,
        "",
        "",
        "",
        List<int>.filled(items.length, 0),
      );
    }
  }

  Future<List<dynamic>> getuserprice() async {
    return listingCollection3
        .where('uid', isEqualTo: uid)
        .get()
        .then((value) => _listingListFromSnapshot3(value)[0].price);
  }

  int gettotal(List<dynamic> count, List<dynamic> price) {
    int total = 0;
    print(count);

    for (int i = 0; i < count.length; i++) {
      int c = count[i];
      int p = price[i];
      total = total + (c * p);
    }
    return total;
  }

  Future updateUserData3({
    String? name,
    String? phone,
    String? uid,
    String? email,
    List<dynamic>? price,
  }) async {
    return await listingCollection3.doc(uid).set({
      'name': name,
      'phone': phone,
      'uid': uid,
      'price': price,
      'email': email,
    });
  }

  Future<void> deleteListing3(String email) async {
    await listingCollection3
        .where('email', isEqualTo: email) // add condition for date
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        document.reference
            .delete()
            .then((_) => print('Deleted'))
            .catchError((error) => print('Delete failed: $error'));
      });
    });
    // delete user
    // await FirebaseAuth.instance.currentUser!.delete();
    //
  }
}
