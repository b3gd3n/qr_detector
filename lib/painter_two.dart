import 'package:flutter/material.dart';

class OpenPainterTwo extends CustomPainter {
  final Offset offset;

  OpenPainterTwo({required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Color(0xff638965)
      ..style = PaintingStyle.fill;
    //a rectangle
    canvas.drawRect(offset & Size(10, 10), paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}