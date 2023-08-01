import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sastilaundry/listings/makelistingbs.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import '../listings/editlistingbs.dart';
import '../services/database.dart';
import 'categ.dart';

launchWhatsapp(String phone) async {
  var whatsapp = phone.toString();
  var cc = '+91'.toString();
  var message = Uri.encodeComponent(
      'Anna your clothes are ready. Please come and collect them TODAY itself before 9:30p.m.');
  var androidUrl = "whatsapp://send?phone=$cc$whatsapp&text=$message";
  var iosUrl = "https://wa.me/$cc$whatsapp?text=$message";

  try {
    if (kIsWeb) {
      await launch(iosUrl);
    } else if (Platform.isAndroid) {
      await launch(androidUrl);
    } else if (Platform.isIOS) {
      await launch(iosUrl);
    }
  } on Exception {
    Fluttertoast.showToast(msg: "Whatsapp not installed");
  }
}

class ProductTilebs extends StatefulWidget {
  ProductTilebs({
    required this.roomno,
    required this.date,
    required this.count,
    required this.uid,
    required this.phone,
    required this.total,
    required this.onTap,
    Key? key,
  }) : super(key: key);
  final String roomno;
  final String date;
  final List<dynamic> count;
  final String uid;
  final String phone;
  final String total;
  final Function onTap;

  @override
  State<ProductTilebs> createState() => _ProductTilebsState();
}

class _ProductTilebsState extends State<ProductTilebs> {
  @override
  Widget build(BuildContext context) {
    final User? uid = FirebaseAuth.instance.currentUser;
    final User user = uid!;

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    int disc = 0;

    final dateTime = DateTime.parse(widget.date);
    String formattedDate =
        DateFormat("MMMM d'\$suffix' h:mma").format(dateTime);
    String suffix;
    if (dateTime.day >= 11 && dateTime.day <= 13) {
      suffix = "th";
    } else {
      switch (dateTime.day % 10) {
        case 1:
          suffix = "st";
          break;
        case 2:
          suffix = "nd";
          break;
        case 3:
          suffix = "rd";
          break;
        default:
          suffix = "th";
          break;
      }
    }

    // Replace the 'suffix' placeholder in the formatted string
    formattedDate = formattedDate.replaceAll('\$suffix', suffix);

    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.red[900]!, width: 2),
              color: Colors.black),
          child: Column(
            children: <Widget>[
              //Listtile
              ListTile(
                title: Text(
                  "Room " + widget.roomno,
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  formattedDate,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                trailing: Text(
                  "₹" + widget.total,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductTileBigbs extends StatefulWidget {
  ProductTileBigbs({
    required this.roomno,
    required this.date,
    required this.count,
    required this.uid,
    required this.phone,
    required this.total,
    required this.onTap,
    Key? key,
  }) : super(key: key);
  final String roomno;
  final String date;
  final List<int> count;
  final String uid;
  final String phone;
  final String total;
  final Function onTap;

  @override
  State<ProductTileBigbs> createState() => _ProductTileBigbsState();
}

class _ProductTileBigbsState extends State<ProductTileBigbs> {
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

  @override
  Widget build(BuildContext context) {
    handleplatform();
    final User? uid = FirebaseAuth.instance.currentUser;
    final User user = uid!;

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final dateTime = DateTime.parse(widget.date);
    String formattedDate =
        DateFormat("MMMM d'\$suffix' h:mma").format(dateTime);
    String suffix;
    if (dateTime.day >= 11 && dateTime.day <= 13) {
      suffix = "th";
    } else {
      switch (dateTime.day % 10) {
        case 1:
          suffix = "st";
          break;
        case 2:
          suffix = "nd";
          break;
        case 3:
          suffix = "rd";
          break;
        default:
          suffix = "th";
          break;
      }
    }

    // Replace the 'suffix' placeholder in the formatted string
    formattedDate = formattedDate.replaceAll('\$suffix', suffix);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Item Details'),
        backgroundColor: Colors.red[900],
        elevation: 0.0,
        actions: [
          //edit icon
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditListingBS(
                            roomno: widget.roomno,
                            count: widget.count,
                            uid: widget.uid,
                            phone: widget.phone,
                          )));
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: Stack(
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
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 5.1),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Colors.white),
          ),
          Positioned(
            top: height / 100,
            left: width / 20,
            bottom: 0,
            right: width / 20,
            child: ListTile(
              visualDensity: VisualDensity(horizontal: -4),
              title: Text(
                "Room no. - " + widget.roomno,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Date - ' + formattedDate,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_active,
                    ),
                    onPressed: () {
                      launchWhatsapp(widget.phone);
                    },
                  ),
                  if (widget.uid == user.uid ||
                      user.uid == "7hdHrNgG7bX72kFbBnypVsTPRSn1" ||
                      user.uid == "admin")
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        //are you sure you want to delete prompt
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Delete Listing"),
                              content: const Text(
                                  "Are you sure you want to delete this listing?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    DatabaseService(uid: user.uid)
                                        .deleteListing(
                                            widget.roomno, widget.date);

                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    Fluttertoast.showToast(
                                        msg: "Item deleted, Please refresh ");
                                  },
                                  child: const Text("Delete"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            top: height / 4.7,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.only(bottom: height / 2.64),
              child: GridView.count(
                crossAxisCount: a,
                children: items
                    .where((item) => widget.count[item['itemno']] != 0)
                    .map((item) => _customCard(
                          imageUrl: item['imageUrl'],
                          item: item['name'],
                          count: widget.count[item['itemno']],
                        ))
                    .toList(),
              ),
            ),
          ),
          //total price container

          //Submit Button
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
              child: TextButton(
                onPressed: () {},
                child: Text(
                  "Total Price - ₹" + widget.total,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _onOpen(LinkableElement link) async {
  var url = link.url;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class ImageHeroWidget extends StatelessWidget {
  final String image;
  final double width;
  final double height;

  const ImageHeroWidget({
    required this.image,
    this.width = 0.0,
    this.height = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: image,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: FadeInImage(
          placeholder: const AssetImage('assets/cash/img.png'),
          image: NetworkImage(image ?? ''),
          imageErrorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/cash/img_1.png',
              width: width != 0.0 ? width : null,
              height: height != 0.0 ? height : null,
            );
          },
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _customCard extends StatelessWidget {
  final String imageUrl;
  final String item;

  final int count;

  const _customCard({
    required this.imageUrl,
    required this.item,
    required this.count,
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
                item ?? '',
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
              Image.asset("assets/page1/" + imageUrl),
              Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("$count",
                      style: TextStyle(fontSize: 20, color: Colors.black)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
