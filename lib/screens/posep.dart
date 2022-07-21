import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:body_detection/models/image_result.dart';
import 'package:body_detection/models/pose.dart';
import 'package:body_detection/models/body_mask.dart';
import 'package:body_detection/models/pose_landmark.dart';
import 'package:body_detection/models/pose_landmark_type.dart';
import 'package:body_detection/png_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:body_detection/body_detection.dart';

double dist = 0.0;

class PosePainter extends CustomPainter {
  PosePainter({
    required this.pose,
    required this.imageSize,
  });

  final Pose pose;
  final Size imageSize;
  final circlePaint = Paint()..color = const Color.fromRGBO(0, 255, 0, 0.8);
  final linePaint = Paint()
    ..color = const Color.fromRGBO(255, 0, 0, 0.8)
    ..strokeWidth = 2;

  @override
  void paint(Canvas canvas, Size size) {
    double xl = 0.0,
        xr = 0.0,
        yl = 0.0,
        yr = 0.0,
        sumx = 0.0,
        sumy = 0.0,
        disto = 0.0;

    final double hRatio =
        imageSize.width == 0 ? 1 : size.width / imageSize.width;
    final double vRatio =
        imageSize.height == 0 ? 1 : size.height / imageSize.height;

    offsetForPart(PoseLandmark part) =>
        Offset(part.position.x * hRatio, part.position.y * vRatio);

    for (final part in pose.landmarks) {
      if (part.type == PoseLandmarkType.leftShoulder) {
        // print(part.type);
        // print(part.position.x);
        // print(part.position.y);
        // print(part.position.z);
        xl = part.position.x * hRatio;
        yl = part.position.y * vRatio;
      } else if (part.type == PoseLandmarkType.rightShoulder) {
        xr = part.position.x * hRatio;
        yr = part.position.y * vRatio;
      }

      // Draw a circular indicator for the landmark.
      canvas.drawCircle(offsetForPart(part), 5, circlePaint);

      // Draw text label for the landmark.
      TextSpan span = TextSpan(
        text: part.type.toString().substring(16),
        style: const TextStyle(
          color: Color.fromRGBO(0, 128, 255, 1),
          fontSize: 10,
        ),
      );
      TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left);
      tp.textDirection = TextDirection.ltr;
      tp.layout();
      tp.paint(canvas, offsetForPart(part));
    }
    sumx = (xr - xl) * (xr - xl);
    // print(sumx);
    sumy = (yr - yl) * (yr - yl);
    // print(sumy);
    disto = sumx + sumy;
    // print(disto);
    dist = sqrt(disto);
    print(dist);
    // Disp(dist);

    // Draw connections between the landmarks.
    //   final landmarksByType = {for (final it in pose.landmarks) it.type: it};
    //   for (final connection in connections) {
    //     final point1 = offsetForPart(landmarksByType[connection[0]]!);
    //     final point2 = offsetForPart(landmarksByType[connection[1]]!);
    //     canvas.drawLine(point1, point2, linePaint);
    //   }
    // }
  }

  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
    throw UnimplementedError();
  }
}

class Disp extends StatelessWidget {
  var measurement;

  // const Disp({ Key? key }) : super(key: key);
  Disp(this.measurement);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("$measurement"),
    );
  }
}
