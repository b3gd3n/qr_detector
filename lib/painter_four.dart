import 'package:flutter/material.dart';

class OpenPainterFour extends CustomPainter {
  final BuildContext context;
  final Color areaColor;
  final Offset offset;
  final Offset offset1;
  final Offset offset2;
  final Offset offset3;
  final Offset offset4;

  OpenPainterFour({
    required this.context,
    required this.areaColor,
    required this.offset,
    required this.offset1,
    required this.offset2,
    required this.offset3,
    required this.offset4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = areaColor
      ..strokeWidth = 5
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawPath(
        Path()
          ..addPolygon([
            offset1,
            offset2,
            offset3,
            offset4,
          ], true),
        paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
