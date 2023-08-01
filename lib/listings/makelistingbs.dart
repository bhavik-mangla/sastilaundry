//to input a listing

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sastilaundry/models/buysell.dart';
import '../models/categ.dart';
import '../providers/countprovider.dart';
import '/services/database.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/models/constantWidgets.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart'
    show Uint8List, defaultTargetPlatform, kIsWeb;
import 'package:provider/provider.dart';

class MakeListingBS extends StatefulWidget {
  const MakeListingBS({Key? key}) : super(key: key);

  @override
  State<MakeListingBS> createState() => _MakeListingBSState();
}

class _MakeListingBSState extends State<MakeListingBS> {
  final _formKey = GlobalKey<FormState>();
  String? roomno;
  List<int> count1 = List<int>.filled(items.length, 0);
  String? _currentPhone;
  String? cdate;
  String? total;
  bool _isButtonEnabled = true;
  int a = 2;
  void handleplatform() {
    if (defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows) {
      setState(() {
        a = 4;
      });
    }
  }

  void _handleButtonClick() {
    // Perform your button click logic here

    // Disable the button after the first click
    setState(() {
      _isButtonEnabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    handleplatform();
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final User? uid = FirebaseAuth.instance.currentUser;
    final User user = uid!;

    return ChangeNotifierProvider<CountProvider>(
      create: (context) => CountProvider(count1),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Make a Listing'),
          backgroundColor: Colors.red[900],
          elevation: 0.0,
          actions: [
            //reset text button
            Consumer<CountProvider>(
              builder: (context, countProvider, _) => TextButton.icon(
                onPressed: () {
                  countProvider.resetCount();
                  count1 = countProvider.count;
                },
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                label: const Text(
                  'Reset',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 2 / 7,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.red[900]!,
                        Colors.red[600]!,
                        Colors.red[400]!,
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 5.3),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 4.9 / 7,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      color: Colors.white),
                ),
                Positioned(
                  top: height / 4.9,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: height / 2.64),
                    child: GridView.count(
                      crossAxisCount: a,
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: items.map((item) {
                        return CustomCard(
                          imageUrl: item['imageUrl'],
                          item: item['name'],
                          itemno: item['itemno'],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Positioned(
                    top: height / 200 - height / 190,
                    left: width / 20,
                    bottom: 0,
                    right: width / 20,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Room Number',
                          ),
                          validator: (val) => (val!.isEmpty && isNumeric(val))
                              ? 'Please enter valid Room Number'
                              : null,
                          onChanged: (val) => setState(() => roomno = val),
                        ),
                        const SizedBox(height: 20.0),
                        //
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Phone Number',
                          ),
                          validator: (val) =>
                              val!.isEmpty && isNumeric(val) && val.length == 10
                                  ? 'Please enter a valid 10 digit phone number'
                                  : null,
                          onChanged: (val) =>
                              setState(() => _currentPhone = val),
                        ),
                        const SizedBox(height: 20.0),
                      ],
                    )),
                Positioned(
                  bottom: height / 100,
                  left: width / 2 - width / 2.5,
                  child: Container(
                    height: height * 0.06,
                    width: width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.red[900],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Consumer<CountProvider>(
                      builder: (context, countProvider, _) => TextButton(
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: _isButtonEnabled
                            ? () async {
                                _handleButtonClick();
                                cdate = DateTime.now().toString();

                                _currentPhone = _currentPhone ?? "0000000000";
                                count1 = countProvider.count;

                                List<dynamic> count = List.generate(
                                  count1!.length,
                                  (index) => count1![index],
                                );
                                var userd = DatabaseService(uid: user.uid)
                                    .getuserprice();
                                var ab;
                                try {
                                  ab = await userd;
                                } catch (e) {
                                  ab = List<dynamic>.filled(items.length, 0);
                                }

                                total = DatabaseService()
                                    .gettotal(count, ab)
                                    .toString();

                                if (_formKey.currentState!.validate()) {
                                  await DatabaseService(uid: user.uid)
                                      .updateUserData(
                                    roomno ?? "0",
                                    count,
                                    _currentPhone ?? "0000000000",
                                    cdate ?? '0',
                                    total ?? '0',
                                    user.uid.toString(),
                                  );
                                  //show Fluttertoast
                                  Fluttertoast.showToast(msg: "Room listed");
                                  Navigator.pop(context);
                                  Navigator.pushReplacementNamed(
                                      context, 'home');
                                }
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String imageUrl;
  final String item;
  final int itemno;

  CustomCard({
    required this.imageUrl,
    required this.item,
    required this.itemno,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      width: 160,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                item,
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
              Image.asset("assets/page1/" + imageUrl),
              Divider(),
              Consumer<CountProvider>(
                builder: (context, countProvider, _) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          countProvider.decrementCount(itemno);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white,
                          ),
                          child: Text(
                            " - ",
                            style: TextStyle(
                              fontSize: 28,
                              letterSpacing: 3,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        countProvider.count[itemno].toString(),
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      GestureDetector(
                        onTap: () {
                          countProvider.incrementCount(itemno);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white,
                          ),
                          child: Text(
                            " + ",
                            style: TextStyle(
                              fontSize: 28,
                              letterSpacing: 1,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//info page
//book a ride
//internships
bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}
