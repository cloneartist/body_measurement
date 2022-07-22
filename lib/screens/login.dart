import 'package:body_measurement/screens/signup.dart';
import 'package:body_measurement/screens/userheight.dart';
// import 'package:body_measurement/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:body_measurement/models/textstyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;

  final auth = FirebaseAuth.instance;
  late UserCredential user;
  late String email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const Spacer(
                  flex: 1,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "RightFit",
                  style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                ),
                const Spacer(flex: 1),
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
                        user = await auth.signInWithEmailAndPassword(
                            email: email, password: password);

                        // await signin(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UserHeight()));
                      } on FirebaseAuthException catch (e) {
                        String error = e.message.toString();
                        final loginerror = SnackBar(content: Text(error));
                        ScaffoldMessenger.of(context).showSnackBar(loginerror);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUp()));
                      }
                    }
                  },
                  label: const Text(
                    "Login",
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
                              builder: (context) => const SignUp()));
                      setState(() {});
                    },
                    child: const Text(
                      "New User? Sign Up",
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
    );
  }
}
