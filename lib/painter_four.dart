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
    // var paint2 = Paint()
    // ..color = Colors.blueAccent.withOpacity(0.2)
    //   ..blendMode = BlendMode.saturation
    // ..style = PaintingStyle.fill;
    // //a rectangle
    // canvas.drawRect(offset & Size(1000, 1000), paint2);
    print('x - ${MediaQuery.of(context).size.width / 2}, y - ${MediaQuery.of(context).size.height / 2}');
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    canvas.drawPath(
        Path()
          ..addPolygon([
            (offset1 == Offset(0, 0))
                ? Offset(width/4,
                    height/4.5)
                : offset1,
            // Offset(100, 100),
            (offset2 == Offset(0, 0))
                ? Offset(width/1.3,
                height/4.5)
                : offset2,
            // Offset(200, 100),
            (offset3 == Offset(0, 0))
                ? Offset(width/1.3,
                height/2)
                : offset3,
            // Offset(200, 200),
            (offset4 == Offset(0, 0))
                ? Offset(width/4,
                height/2)
                : offset4,
            // Offset(100, 200),
          ], true),
        paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
