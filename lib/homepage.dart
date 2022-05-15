import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internship_assignment/location_page.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  String name = '';
  int mobileno = 0;
  String email = '';
  int age = 0;
  void getDetails() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();
    var snapshot = snap.data() as Map<String, dynamic>;
    setState(() {
      name = snapshot['name'];
      mobileno = snapshot['mobileno'];
      age = snapshot['age'];
      email = snapshot['email'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    final TabController tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage'),
        centerTitle: true,
        bottom: TabBar(
          labelPadding: EdgeInsets.symmetric(vertical: 15),
          controller: tabController,
          tabs: [
            Text('Personal Details'),
            Text('Location'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Personal details:'),
                Text('Name:\t${name}'),
                Text('Mobile number:\t${mobileno}'),
                Text('Email:\t${email}'),
                Text('Age:\t${age}'),
                ElevatedButton(
                  onPressed: () async {
                    bool? anonymous = _auth.currentUser?.isAnonymous;
                    if (anonymous!) {
                      setState(() {
                        name = 'Anonymous'.toUpperCase();
                        mobileno = 0000000000;
                        email = 'Anonymous'.toUpperCase();
                        age = 0;
                      });
                    } else {
                      getDetails();
                    }
                  },
                  child: Text('Get Details'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _auth.signOut();
                  },
                  child: Text('Sign out'),
                ),
              ],
            ),
          ),
          LocationPage(),
        ],
      ),
    );
  }
}
