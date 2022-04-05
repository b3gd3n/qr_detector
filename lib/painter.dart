import 'package:flutter/material.dart';

class OpenPainter extends CustomPainter {
  final Offset topLeft;
  final Offset topRight;
  final Offset bottomRight;
  final Offset bottomLeft;

  OpenPainter({
    required this.topLeft,
    required this.topRight,
    required this.bottomRight,
    required this.bottomLeft,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Color(0xff638965)
      ..style = PaintingStyle.fill;
    //a rectangle
    // canvas.drawRect(offset & Size(10, 10), paint1);
    canvas.drawPath(
        Path()
          ..addPolygon([
           topLeft,
            topRight,
            bottomRight,
            bottomLeft,
          ], true),
        paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
