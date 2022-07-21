import 'package:flutter/material.dart';
import '../models/textstyle.dart';
import 'home.dart';

class UserHeight extends StatefulWidget {
  const UserHeight({Key? key}) : super(key: key);

  @override
  State<UserHeight> createState() => _UserHeightState();
}

class _UserHeightState extends State<UserHeight> {
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Homes(myController: myController),
    );
  }
}

//enter userheight
class Homes extends StatelessWidget {
  const Homes({
    Key? key,
    required this.myController,
  }) : super(key: key);

  final TextEditingController myController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            decoration: textInputDecoration.copyWith(
              labelText: 'Enter Your Height',
            ),
            controller: myController,
          ),
          TextButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // <-- Radius
              )),
              onPressed: () {
                // print(myController.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyApps(myController.text),
                  ),
                );
              },
              child: Text("Submit"))
        ],
      ),
    );
  }
}
