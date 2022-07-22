import 'dart:io';
import 'dart:math';

import 'package:body_detection/models/pose.dart';
import 'package:body_detection/models/pose_landmark_type.dart';
import 'package:body_detection/png_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:body_detection/body_detection.dart';

import 'posep.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

class MyApps extends StatefulWidget {
  const MyApps(
    this.posted,
  );
  final String posted;

  @override
  State<MyApps> createState() => _MyAppsState();
}

class _MyAppsState extends State<MyApps> {
  bool selected = false;
  double x_nose = 0.0,
      y_nose = 0.0,
      z_nose = 0.0,
      x_rankle28 = 0.0,
      y_rankle28 = 0.0,
      z_rankle28 = 0.0,
      x_rightshoulder12 = 0.0,
      y_rightshoulder12 = 0.0,
      z_rightshoulder12 = 0.0,
      x_righthip24 = 0.0,
      y_righthip24 = 0.0,
      z_righthip24 = 0.0,
      x_rightwrist16 = 0.0,
      y_rightwrist16 = 0.0,
      z_rightwrist16 = 0.0,
      x_leftshoulder11 = 0.0,
      y_leftshoulder11 = 0.0,
      z_leftshoulder11 = 0.0,
      shirtlength = 0.0,
      armlength = 0.0,
      shoulderlength = 0.0,
      pantlength = 0.0,
      //equations
// shirt length = [{dist(point12, point24)}*R]+K1
// Arm length = [{dist(point12, point16)}*R]+K2
// shoulder length = [{dist(point12, point11)}*R]+K3
// Pant length = [{dist(point24, point28)}*R]+K4
      user_height = 0.0;

  Image? _selectedImage;

  Pose? _detectedPose;
  Size _imageSize = Size.zero;
//Distance calculated using Euclidean distance formula
  double distance(
      double x1, double x2, double y1, double y2, double z1, double z2) {
    return (sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2) + pow(z1 - z2, 2)));
  }

//select image
  Future<void> _selectImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null || result.files.isEmpty) return;
    final path = result.files.single.path;
    if (path != null) {
      _resetState();
      setState(() {
        // _startImage = getUiImage(path, 716, 368) as Image?;
        _selectedImage = Image.file(File(path));
      });
      _detectImagePose();
    }
  }

//get Poselandmarks from image
  Future<void> _detectImagePose() async {
    PngImage? pngImage = await _selectedImage?.toPngImage();
    if (pngImage == null) return;
    setState(() {
      _imageSize = Size(pngImage.width.toDouble(), pngImage.height.toDouble());
    });
    final pose = await BodyDetection.detectPose(image: pngImage);
    _handlePose(pose);

    for (final part in pose!.landmarks) {
      if (part.type == PoseLandmarkType.nose) {
        x_nose = part.position.x;
        y_nose = part.position.y;
        z_nose = part.position.z;
      } else if (part.type == PoseLandmarkType.rightAnkle) {
        x_rankle28 = part.position.x;
        y_rankle28 = part.position.y;
        z_rankle28 = part.position.z;
      } else if (part.type == PoseLandmarkType.rightShoulder) {
        x_rightshoulder12 = part.position.x;
        y_rightshoulder12 = part.position.y;
        z_rightshoulder12 = part.position.z;
      } else if (part.type == PoseLandmarkType.leftShoulder) {
        x_leftshoulder11 = part.position.x;
        y_leftshoulder11 = part.position.y;
        z_leftshoulder11 = part.position.z;
      } else if (part.type == PoseLandmarkType.rightHip) {
        x_righthip24 = part.position.x;
        y_righthip24 = part.position.y;
        z_righthip24 = part.position.z;
      } else if (part.type == PoseLandmarkType.rightWrist) {
        x_rightwrist16 = part.position.x;
        y_rightwrist16 = part.position.y;
        z_rightwrist16 = part.position.z;
      }
    }

    selected = true;
  }

//Detected Pose
  void _handlePose(Pose? pose) {
    if (!mounted) return;

    setState(() {
      _detectedPose = pose;
    });
  }

//Clear image and measurements
  void _resetState() {
    setState(() {
      _detectedPose = null;
      _imageSize = Size.zero;
      selected = false;
      dist = 0;
      shirtlength = 0;
      shoulderlength = 0;
      armlength = 0;
      pantlength = 0;
      x_nose = 0.0;
      y_nose = 0.0;
      z_nose = 0.0;
      x_rankle28 = 0.0;
      y_rankle28 = 0.0;
      z_rankle28 = 0.0;
      x_rightshoulder12 = 0.0;
      y_rightshoulder12 = 0.0;
      z_rightshoulder12 = 0.0;
      x_righthip24 = 0.0;
      y_righthip24 = 0.0;
      z_righthip24 = 0.0;
      x_rightwrist16 = 0.0;
      y_rightwrist16 = 0.0;
      z_rightwrist16 = 0.0;
      x_leftshoulder11 = 0.0;
      y_leftshoulder11 = 0.0;
      z_leftshoulder11 = 0.0;

      //equations
    });
  }

//Data added to Database
  void add() async {
    CollectionReference ref = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("measurements");

    var data = {
      "DistancePerPixel": dist,
      "ShirtLength": shirtlength,
      "ArmLength": armlength,
      "ShoulderLength": shoulderlength,
      "PantLength": pantlength
    };
    ref.add(data);
  }

  //Future Implementation of ondevice image manipulation
  // Future<ui.Image> getUiImage(
  //     String imageAssetPath, int height, int width) async {
  //   final ByteData assetImageByteData = await rootBundle.load(imageAssetPath);
  //   final codec = await ui.instantiateImageCodec(
  //     assetImageByteData.buffer.asUint8List(),
  //     targetHeight: height,
  //     targetWidth: width,
  //   );
  //   final image = (await codec.getNextFrame()).image;
  //   return image;
  // }
//image display with marked points
  Widget get _imageDetectionView => SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              selected
                  ? GestureDetector(
                      child: ClipRect(
                        child: CustomPaint(
                          child: _selectedImage,
                          foregroundPainter: PosePainter(
                            pose: _detectedPose!,
                            // mask: _maskImage!,
                            imageSize: _imageSize,
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      );
//buttons and measurements ui
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: const Text(
              'Right Fit',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _imageDetectionView,
                // Text("$widget"),
                OutlinedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // <-- Radius
                  )),
                  onPressed: _selectImage,
                  child: const Text('Select image'),
                ),
                //calculate button
                OutlinedButton(
                  onPressed: () {
                    user_height = double.tryParse(widget.posted)!;

                    dist = user_height /
                        distance(x_nose, x_rankle28, y_nose, y_rankle28, z_nose,
                            z_rankle28);
                    //distance calculation
                    shirtlength = distance(
                            x_rightshoulder12,
                            x_righthip24,
                            y_rightshoulder12,
                            y_righthip24,
                            z_rightshoulder12,
                            z_righthip24) *
                        dist;
                    armlength = distance(
                            x_rightshoulder12,
                            x_rightwrist16,
                            y_rightshoulder12,
                            y_rightwrist16,
                            z_rightshoulder12,
                            z_rightwrist16) *
                        dist;
                    shoulderlength = distance(
                                x_rightshoulder12,
                                x_leftshoulder11,
                                y_rightshoulder12,
                                y_leftshoulder11,
                                z_rightshoulder12,
                                z_leftshoulder11) *
                            dist +
                        1.5;
                    pantlength = distance(
                            x_righthip24,
                            x_rankle28,
                            y_righthip24,
                            y_rankle28,
                            z_righthip24,
                            z_rankle28) *
                        dist;

                    setState(() {
                      dist = dist;
                      shirtlength = shirtlength / 2.54;
                      armlength = armlength / 2.54;
                      shoulderlength = shoulderlength / 2.54;
                      pantlength = pantlength / 2.54;
                      // print(widget.posted);
                    });

                    add(); //add to database called
                  }
                  //  _detectImagePose,
                  ,
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // <-- Radius
                  )),
                  child: const Text('Calculate '),
                ),

                OutlinedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // <-- Radius
                  )),
                  onPressed: _resetState,
                  child: const Text('Clear'),
                ),
                // Disp(0)
                //Measurements displayed
                // Text("DistancePerPixel:" "$dist"),
                Text("Shirt Length:" "$shirtlength"),
                Text("Arm Length:" "$armlength"),
                Text("Shoulder Length:" "$shoulderlength"),
                Text("Pant Length:" "$pantlength"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
