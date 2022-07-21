import 'package:body_measurement/screens/userheight.dart';
import 'package:flutter/material.dart';
import 'package:body_measurement/models/textstyle.dart';
import 'package:body_measurement/screens/home.dart';
import 'package:body_measurement/screens/login.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;

  final _auth = FirebaseAuth.instance;

  late String email, password, name;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.all(22.0),
                  //   child: Container(
                  //     child: Image.asset(
                  //       'assets/images/new.png',
                  //       fit: BoxFit.contain,
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  Flexible(
                    child: Text(
                      "Welcome To\n RightFit",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(flex: 1),
                  TextFormField(
                    validator: (val) =>
                        val!.isEmpty || val.isEmpty ? 'Enter your name' : null,
                    decoration: textInputDecoration.copyWith(
                      labelText: 'Enter Your Name',
                    ),
                    onChanged: (value) {
                      name = value;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    validator: (val) => val!.isEmpty ||
                            !(val.contains('@') || !(val.contains('.com')))
                        ? 'Enter a valid email address'
                        : null,
                    decoration: textInputDecoration.copyWith(
                      labelText: 'Enter Your Email Address',
                    ),
                    onChanged: (value) {
                      email = value;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    obscureText: true,
                    validator: (val) => val!.isEmpty || val.length < 6
                        ? 'Enter a password greater than 6 characters'
                        : null,
                    decoration: textInputDecoration.copyWith(
                      labelText: 'Enter Your Password',
                    ),
                    onChanged: (value) {
                      password = value;
                    },
                  ),
                  const SizedBox(height: 40.0),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    ),
                    icon: const Icon(
                      Icons.login,
                      color: Colors.white,
                      size: 25,
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        setState(() {});
                        try {
                          UserCredential res =
                              await _auth.createUserWithEmailAndPassword(
                                  email: email, password: password);

                          User? user = res.user;
                          user!.updateDisplayName(name);

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const UserHeight()));
                        } on FirebaseAuthException catch (e) {
                          String error = e.message.toString();

                          final loginerror = SnackBar(content: Text(error));
                          ScaffoldMessenger.of(context)
                              .showSnackBar(loginerror);
                        }
                      }
                    },
                    label: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()));
                      },
                      child: const Text(
                        "Existing User? Login",
                        style: TextStyle(color: Colors.black),
                      )),
                  const Spacer(
                    flex: 1,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
