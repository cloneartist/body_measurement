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
// import 'package:permission_handler/permission_handler.dart';

import 'posep.dart';

// void main() {
//   runApp(const MyApps());
// }
FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

class MyApps extends StatefulWidget {
  // const MyApps({Key? key}) : super(key: key);
  const MyApps(
    this.posted,
    //  this.title
  );
  final String posted;
  // final String title;

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
// shirt length = [{dist(point12, point24)}*R]+K1
// Arm length = [{dist(point12, point16)}*R]+K2
// shoulder length = [{dist(point12, point11)}*R]+K3
// Pant length = [{dist(point24, point28)}*R]+K4
      user_height = 0.0;

  Image? _selectedImage;

  Pose? _detectedPose;
  Size _imageSize = Size.zero;

  double distance(
      double x1, double x2, double y1, double y2, double z1, double z2) {
    return (sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2) + pow(z1 - z2, 2)));

    // return 0;
  }
//Future Implementation
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

  Future<void> _detectImagePose() async {
    PngImage? pngImage = await _selectedImage?.toPngImage();
    if (pngImage == null) return;
    setState(() {
      _imageSize = Size(pngImage.width.toDouble(), pngImage.height.toDouble());
    });
    final pose = await BodyDetection.detectPose(image: pngImage);
    _handlePose(pose);
    // final double hRatio =
    //     imageSize.width == 0 ? 1 : size.width / imageSize.width;
    // final double vRatio =
    //     imageSize.height == 0 ? 1 : size.height / imageSize.height;

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

  void _handlePose(Pose? pose) {
    // Ignore if navigated out of the page.
    if (!mounted) return;

    setState(() {
      _detectedPose = pose;
    });
  }

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
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Body Measurement'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _imageDetectionView,
              // Text("$widget"),
              OutlinedButton(
                onPressed: _selectImage,
                child: const Text('Select image'),
              ),

              OutlinedButton(
                onPressed: () {
                  user_height = double.tryParse(widget.posted)!;
                  // double? parsedValue2 =
                  dist = user_height /
                      distance(x_nose, x_rankle28, y_nose, y_rankle28, z_nose,
                          z_rankle28);

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
                  pantlength = distance(x_righthip24, x_rankle28, y_righthip24,
                          y_rankle28, z_righthip24, z_rankle28) *
                      dist;
                  // (sqrt(pow(x_nose - x_rankle, 2) +
                  //     pow(y_nose - y_rankle, 2) +
                  //     pow(z_nose - z_rankle, 2)));
                  // print("haha");
                  // print(dist);
                  // sumx = (xr - xl) * (xr - xl);
                  // print(sumx);
                  // sumy = (yr - yl) * (yr - yl);
                  // print(sumy);

                  // disto = sumx + sumy;
                  // print(disto);
                  // dist = sqrt(disto);
                  // print("lala");
                  // print(dist);
                  // Displ();

                  setState(() {
                    dist = dist;
                    shirtlength = shirtlength / 2.54;
                    armlength = armlength / 2.54;
                    shoulderlength = shoulderlength / 2.54;
                    pantlength = pantlength / 2.54;
                    // print(widget.posted);
                  });
                  // final double hRatio =
                  //     _imageSize.width == 0 ? 1 : size.width / imageSize.width;
                  // final double vRatio = imageSize.height == 0
                  //     ? 1
                  //     : size.height / imageSize.height;
                  add();
                }
                //  _detectImagePose,
                ,
                child: const Text('Calculate '),
              ),

              // OutlinedButton(
              //   onPressed: _detectImageBodyMask,
              //   child: const Text('Detect body mask'),
              // ),
              OutlinedButton(
                onPressed: _resetState,
                child: const Text('Clear'),
              ),
              // Disp(0)

              Text("DistancePP:" "$dist"),
              Text("Shirt Length:" "$shirtlength"),
              Text("Arm Length:" "$armlength"),
              Text("Shoulder Length:" "$shoulderlength"),
              Text("Pant Length:" "$pantlength"),
            ],
          ),
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   items: const <BottomNavigationBarItem>[
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.image),
        //       label: 'Image',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.camera),
        //       label: 'Camera',
        //     ),
        //   ],
        //   currentIndex: _selectedTabIndex,
        //   onTap: _onTabSelectTapped,
        // ),
        // body: _selectedTab,
      ),
    );
  }

  // Future<void> _detectImageBodyMask() async {
  //   PngImage? pngImage = await _selectedImage?.toPngImage();
  //   if (pngImage == null) return;
  //   setState(() {
  //     _imageSize = Size(pngImage.width.toDouble(), pngImage.height.toDouble());
  //   });
  //   final mask = await BodyDetection.detectBodyMask(image: pngImage);
  //   _handleBodyMask(mask);
  // }

  // Future<void> _startCameraStream() async {
  //   // final request = await Permission.camera.request();
  //   bool request = true;
  //   if (request) {
  //     await BodyDetection.startCameraStream(
  //       onFrameAvailable: _handleCameraImage,
  //       onPoseAvailable: (pose) {
  //         if (!_isDetectingPose) return;
  //         _handlePose(pose);
  //       },
  //       onMaskAvailable: (mask) {
  //         if (!_isDetectingBodyMask) return;
  //         _handleBodyMask(mask);
  //       },
  //     );
  //   }
  // }

  // Future<void> _stopCameraStream() async {
  //   await BodyDetection.stopCameraStream();

  //   setState(() {
  //     _cameraImage = null;
  //     _imageSize = Size.zero;
  //   });
  // }

  // void _handleCameraImage(ImageResult result) {
  //   // Ignore callback if navigated out of the page.
  //   if (!mounted) return;

  //   // To avoid a memory leak issue.
  //   // https://github.com/flutter/flutter/issues/60160
  //   PaintingBinding.instance?.imageCache?.clear();
  //   PaintingBinding.instance?.imageCache?.clearLiveImages();

  //   final image = Image.memory(
  //     result.bytes,
  //     gaplessPlayback: true,
  //     fit: BoxFit.contain,
  //   );

  //   setState(() {
  //     _cameraImage = image;
  //     _imageSize = result.size;
  //   });
  // }

  // void _handleBodyMask(BodyMask? mask) {
  //   // Ignore if navigated out of the page.
  //   if (!mounted) return;

  //   if (mask == null) {
  //     setState(() {
  //       _maskImage = null;
  //     });
  //     return;
  //   }

  //   final bytes = mask.buffer
  //       .expand(
  //         (it) => [0, 0, 0, (it * 255).toInt()],
  //       )
  //       .toList();
  //   ui.decodeImageFromPixels(Uint8List.fromList(bytes), mask.width, mask.height,
  //       ui.PixelFormat.rgba8888, (image) {
  //     setState(() {
  //       _maskImage = image;
  //     });
  //   });
  // }

  // Future<void> _toggleDetectBodyMask() async {
  //   if (_isDetectingBodyMask) {
  //     await BodyDetection.disableBodyMaskDetection();
  //   } else {
  //     await BodyDetection.enableBodyMaskDetection();
  //   }

  //   setState(() {
  //     _isDetectingBodyMask = !_isDetectingBodyMask;
  //     _maskImage = null;
  //   });
  // }

  // void _onTabEnter(int index) {
  //   // Camera tab
  //   if (index == 1) {
  //     _startCameraStream();
  //   }
  // }

  // void _onTabExit(int index) {
  //   // Camera tab
  //   if (index == 1) {
  //     _stopCameraStream();
  //   }
  // }

  // void _onTabSelectTapped(int index) {
  //   _onTabExit(_selectedTabIndex);
  //   _onTabEnter(index);

  //   setState(() {
  //     _selectedTabIndex = index;
  //   });
  // }

  // Widget? get _selectedTab => _selectedTabIndex == 0
  //     ? _imageDetectionView
  //     : _selectedTabIndex == 1
  //         ? _cameraDetectionView
  //         : null;

  // Widget get _cameraDetectionView => SingleChildScrollView(
  //       child: Center(
  //         child: Column(
  //           children: [
  //             // ClipRect(
  //             //   child: CustomPaint(
  //             //     child: _cameraImage,
  //             //     foregroundPainter: PoseMaskPainter(
  //             //       pose: _detectedPose,
  //             //       mask: _maskImage,
  //             //       imageSize: _imageSize,
  //             //     ),
  //             //   ),
  //             // ),
  //             // OutlinedButton(
  //             //   onPressed: _toggleDetectPose,
  //             //   child: _isDetectingPose
  //             //       ? const Text('Turn off pose detection')
  //             //       : const Text('Turn on pose detection'),
  //             // ),
  //             // OutlinedButton(
  //             //   onPressed: _toggleDetectBodyMask,
  //             //   child: _isDetectingBodyMask
  //             //       ? const Text('Turn off body mask detection')
  //             //       : const Text('Turn on body mask detection'),
  //             // ),
  //           ],
  //         ),
  //       ),
  //     );

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
