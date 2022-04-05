import 'package:flutter/material.dart';

class OpenPainterThree extends CustomPainter {
  final Offset offset;


  OpenPainterThree({
    required this.offset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // var paint1 = Paint()
    //   ..color = Colors.blueAccent.withOpacity(0.2)
    //   ..strokeWidth = 10
    //   ..strokeJoin = StrokeJoin.round
    //   ..strokeCap = StrokeCap.round
    //   ..style = PaintingStyle.stroke;
    var paint2 = Paint()
    ..color = Colors.grey.withOpacity(0.5)
      ..blendMode = BlendMode.srcOut
    ..style = PaintingStyle.fill;
    //a rectangle
    canvas.drawRect(offset & Size(1000, 1000), paint2);
  //   canvas.drawPath(
  //       Path()
  //         ..addPolygon([
  //           offset1,
  //           // Offset(100, 100),
  //           offset2,
  //           // Offset(200, 100),
  //           offset3,
  //           // Offset(200, 200),
  //           offset4,
  //           // Offset(100, 200),
  //         ], true),
  //       paint1);
  // }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
   return true;
  }
}
