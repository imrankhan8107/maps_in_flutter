import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'homepage.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  Future<String> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return 'Yes';
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      switch (e.code) {
        case "invalid-email":
          return 'Invalid Email.\nPlease Enter correct email.';
        case "wrong-password":
          return 'Wrong Password,\nPlease enter correct password';
        case "user-not-found":
          return 'User Not Found,\nPlease Sign Up';
        default:
          return 'Invalid information';
      }
    }
    return 'NO';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log In'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.symmetric(vertical: 30),
          child: ListView(
            children: [
              TextFormField(
                controller: _email,
                decoration: InputDecoration(
                    hintText: 'Enter email',
                    labelText: 'EMAIL',
                    border: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 8)),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _password,
                decoration: InputDecoration(
                    hintText: 'Enter Password',
                    labelText: 'PASSWORD',
                    border: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 8)),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
                    String login = await signIn(_email.text, _password.text);
                    if (login == 'Yes') {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    } else {
                      Fluttertoast.showToast(msg: login);
                    }
                  } else {
                    Fluttertoast.showToast(msg: 'Fields cannot be empty');
                  }
                },
                child: Text('Log In'),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Don't have an account? Sign Up"),
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  _auth.signInAnonymously();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Text('Continue without signing in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
