import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sastilaundry/models/users.dart';
import '../models/categ.dart';
import '/services/database.dart';
import '../authentication/auth.dart';
import 'editprofile.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.red[900],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: FutureBuilder<Users?>(
          future: DatabaseService(uid: user.uid).getUserDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error fetching user data'),
              );
            } else if (snapshot.hasData) {
              print("snapshot has data");
              return Stack(
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
                        top: MediaQuery.of(context).size.height / 7),
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
                    top: height / 60,
                    left: width / 20,
                    bottom: 0,
                    right: width / 20,
                    child: ListTile(
                      visualDensity: VisualDensity(horizontal: -4),
                      title: Text(
                        "Name - ${snapshot.data!.name ?? ''}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Phone No. - ${snapshot.data!.phone ?? ''}',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: height / 6.2,
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
                            count: snapshot.data!.price[items.indexOf(item)],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
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
                        onPressed: () {
                          List<int> p = snapshot.data!.price.cast<int>();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfile(
                                name: snapshot.data!.name,
                                phone: snapshot.data!.phone,
                                price: p,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "Update Prices",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
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
                  Text(
                    "₹$count",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
