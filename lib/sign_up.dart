import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internship_assignment/homepage.dart';
import 'package:internship_assignment/login_page.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _mobileno = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _age = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: Center(
          child: ListView(
            children: [
              TextFormField(
                controller: _name,
                decoration: InputDecoration(
                    hintText: 'Enter Name',
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 8)),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _age,
                decoration: InputDecoration(
                    hintText: 'Enter Age',
                    labelText: 'Age',
                    border: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 8)),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _mobileno,
                decoration: InputDecoration(
                    hintText: 'Enter Mobile No',
                    labelText: 'Mobile No',
                    border: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 8)),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _email,
                decoration: InputDecoration(
                    hintText: 'Enter Email',
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 8)),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _password,
                decoration: InputDecoration(
                    hintText: 'Enter Password',
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 8)),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_email.text.isNotEmpty &&
                      _password.text.isNotEmpty &&
                      _name.text.isNotEmpty &&
                      _age.text.isNotEmpty &&
                      _mobileno.text.isNotEmpty) {
                    _auth.createUserWithEmailAndPassword(
                        email: _email.text, password: _password.text);
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(_auth.currentUser!.uid)
                        .set({
                      'name': _name.text,
                      'age': int.parse(_age.text),
                      'email': _email.text,
                      'mobileno': int.parse(_mobileno.text),
                      'uid': _auth.currentUser!.uid,
                    });
                    Fluttertoast.showToast(msg: 'Sign up successful');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  } else {
                    Fluttertoast.showToast(msg: 'Fields cannot be empty');
                  }
                },
                child: Text('Sign Up'),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LogIn()));
                  },
                  child: Text('Already hanve an account? Sign In')),
            ],
          ),
        ),
      ),
    );
  }
}
