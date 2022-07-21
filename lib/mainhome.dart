import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:body_detection/models/image_result.dart';
import 'package:body_detection/models/pose.dart';
import 'package:body_detection/models/body_mask.dart';
import 'package:body_detection/models/pose_landmark.dart';
import 'package:body_detection/models/pose_landmark_type.dart';
import 'package:body_detection/png_image.dart';
import 'package:body_measurement/results.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:body_detection/body_detection.dart';
// import 'package:permission_handler/permission_handler.dart';

import 'posep.dart';

// void main() {
//   runApp(const MyApps());
// }

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
  int _selectedTabIndex = 0;
  double x_nose = 0.0,
      y_nose = 0.0,
      z_nose = 0.0,
      x_rankle = 0.0,
      y_rankle = 0.0,
      z_rankle = 0.0,
      user_height = 0.0;
  bool _isDetectingPose = false;
  bool _isDetectingBodyMask = false;

  Image? _selectedImage;

  Pose? _detectedPose;
  ui.Image? _maskImage;
  Image? _cameraImage;
  Size _imageSize = Size.zero;

  Future<void> _selectImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null || result.files.isEmpty) return;
    final path = result.files.single.path;
    if (path != null) {
      _resetState();
      setState(() {
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

    offsetForPart(PoseLandmark part) =>
        Offset(part.position.x, part.position.y);
    for (final part in pose!.landmarks) {
      if (part.type == PoseLandmarkType.leftShoulder) {
        // print(part.type);
        // print(part.position.x);
        // print(part.position.y);
        // print(part.position.z);
        x_nose = part.position.x;
        y_nose = part.position.y;
        z_nose = part.position.z;
      } else if (part.type == PoseLandmarkType.rightShoulder) {
        x_rankle = part.position.x;
        y_rankle = part.position.y;
        z_rankle = part.position.z;
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

  Future<void> _toggleDetectPose() async {
    if (_isDetectingPose) {
      await BodyDetection.disablePoseDetection();
    } else {
      await BodyDetection.enablePoseDetection();
    }

    setState(() {
      _isDetectingPose = !_isDetectingPose;
      _detectedPose = null;
    });
  }

  void _resetState() {
    setState(() {
      _maskImage = null;
      _detectedPose = null;
      _imageSize = Size.zero;
      selected = false;
      dist = 0;
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
        body: Column(
          children: [
            _imageDetectionView,
            // Text("$widget"),
            OutlinedButton(
              onPressed: _selectImage,
              child: const Text('Select image'),
            ),

            OutlinedButton(
              onPressed: () {
                // dist = sqrt(pow(x_nose - x_rankle, 2) + pow(y_nose - y_rankle, 2)
                // + pow(zr - zl, 2)
                // );
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
                  print(widget.posted);
                });
                // final double hRatio =
                //     _imageSize.width == 0 ? 1 : size.width / imageSize.width;
                // final double vRatio = imageSize.height == 0
                //     ? 1
                //     : size.height / imageSize.height;
              }
              //  _detectImagePose,
              ,
              child: const Text('Detect pose'),
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

            Text("Distance:" + "$dist"),
          ],
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
