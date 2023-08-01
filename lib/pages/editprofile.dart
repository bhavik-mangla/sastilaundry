//edit profile

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show Uint8List, defaultTargetPlatform, kIsWeb;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:sastilaundry/providers/countprovider.dart';
import '../models/categ.dart';
import '/pages/profile.dart';
import '/services/database.dart';

class EditProfile extends StatefulWidget {
  EditProfile({
    required this.name,
    required this.phone,
    required this.price,
    Key? key,
  }) : super(key: key);

  final String name;
  final String phone;
  final List<int> price;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String? _name;
  String? _phone;
  List<int>? price1 = List<int>.filled(items.length, 0);
  int a = 2;
  bool _isButtonEnabled = true;
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
    DatabaseService db = DatabaseService(uid: _auth.currentUser!.uid);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider<PriceProvider>(
        create: (context) => PriceProvider(widget.price),
        child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: Text('Edit Profile'),
              backgroundColor: Colors.red[900],
              elevation: 0.0,
              actions: [
                //reset text button
                Consumer<PriceProvider>(
                  builder: (context, priceProvider, _) => TextButton.icon(
                    onPressed: () {
                      priceProvider.resetCount();
                      price1 = priceProvider.price;
                      print(price1);
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
                  children: [
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
                          children: items.map((item) {
                            return _customCard(
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
                              initialValue: widget.name,
                              decoration: const InputDecoration(
                                hintText: 'Name',
                              ),
                              validator: (val) =>
                                  (val!.isEmpty && isNumeric(val))
                                      ? 'Please enter valid Name'
                                      : null,
                              onChanged: (val) => setState(() => _name = val),
                            ),
                            const SizedBox(height: 20.0),
                            //
                            TextFormField(
                              initialValue: widget.phone,
                              decoration: const InputDecoration(
                                hintText: 'Phone Number',
                              ),
                              validator: (val) => val!.isEmpty &&
                                      isNumeric(val) &&
                                      val.length == 10
                                  ? 'Please enter a valid 10 digit phone number'
                                  : null,
                              onChanged: (val) => setState(() => _phone = val),
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
                        child: Consumer<PriceProvider>(
                          builder: (context, priceProvider, _) => TextButton(
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
                                    final user = _auth.currentUser;
                                    final uid = user!.uid;

                                    price1 = priceProvider.price;
                                    List<dynamic> price = List.generate(
                                      price1!.length,
                                      (index) => price1![index],
                                    );
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      try {
                                        await db.updateUserData3(
                                            name: _name ?? widget.name,
                                            phone: _phone ?? widget.phone,
                                            uid: uid,
                                            email: user.email,
                                            price: price);

                                        Fluttertoast.showToast(
                                            msg: "Profile Updated",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red[900],
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                        Navigator.pop(context);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Profile()));
                                      } catch (e) {
                                        print(e);
                                      }
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
            )));
  }
}

class _customCard extends StatelessWidget {
  final String imageUrl;
  final String item;

  final int itemno;

  const _customCard({
    required this.imageUrl,
    required this.item,
    required this.itemno,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    void dispose() {
      _controller.dispose();
    }

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
                item ?? '',
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
              Image.asset("assets/page1/" + imageUrl),
              Divider(),
              Consumer<PriceProvider>(
                builder: (context, priceProvider, _) {
                  _controller.text = priceProvider.price[itemno].toString();

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      //ruppee
                      Text(
                        '₹',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          style: TextStyle(fontSize: 20, color: Colors.black),
                          controller: _controller,
                          onChanged: (value) {
                            try {
                              priceProvider.price[itemno] =
                                  int.parse(_controller.text);
                            } catch (e) {
                              // Handle the parsing error
                              priceProvider.price[itemno] =
                                  0; // Set a default value
                            }
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.redAccent,
                                width: 2,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Colors.black), // Set the underline color
                            ),
                            border:
                                InputBorder.none, // Remove the default border
                            hintText: 'Price',
                            hintStyle: TextStyle(
                                color: Colors.black), // Set the hint text color
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

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}
