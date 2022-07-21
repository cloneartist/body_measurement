import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:body_detection/models/image_result.dart';
import 'package:body_detection/models/pose.dart';
import 'package:body_detection/models/body_mask.dart';
import 'package:body_detection/models/pose_landmark.dart';
import 'package:body_detection/models/pose_landmark_type.dart';
import 'package:body_detection/png_image.dart';
import 'package:body_measurement/mainhome.dart';
import 'package:body_measurement/results.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:body_detection/body_detection.dart';
// import 'package:permission_handler/permission_handler.dart';

import 'posep.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
      home: homes(myController: myController),
    );
  }
}

class homes extends StatelessWidget {
  const homes({
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
            controller: myController,
          ),
          TextButton(
              onPressed: () {
                print(myController.text);
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

// class Displ extends StatefulWidget {
//   const Displ({Key? key}) : super(key: key);

//   @override
//   State<Displ> createState() => _DisplState();
// }

// class _DisplState extends State<Displ> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: TextButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => twk(dist),
//                 ),
//               );
//             },
//             child: Text("measure")),
//       ),
//     );
//   }
// }
