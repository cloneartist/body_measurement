import 'dart:math';

import 'package:body_detection/models/pose.dart';
import 'package:body_detection/models/pose_landmark.dart';
import 'package:body_detection/models/pose_landmark_type.dart';
import 'package:flutter/material.dart';

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
    final double hRatio =
        imageSize.width == 0 ? 1 : size.width / imageSize.width;
    final double vRatio =
        imageSize.height == 0 ? 1 : size.height / imageSize.height;

    offsetForPart(PoseLandmark part) =>
        Offset(part.position.x * hRatio, part.position.y * vRatio);

    for (final part in pose.landmarks) {
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
