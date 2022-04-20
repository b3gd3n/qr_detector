import 'package:barcode_detector/domain/widgets/qr_detector.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print((MediaQuery.of(context).size.height));
    return Container(
      child: QrDetector(
        areaColor: Colors.amber,
        triggeredColor: Colors.deepOrange,
        triggeredCurve: Curves.fastOutSlowIn,
        height: (MediaQuery.of(context).size.height),
        width: (MediaQuery.of(context).size.width),
        // Curves.ease - slow trigger animation
        // Curves.bounceOut - drop animation
        // Curves.easeInCirc - speeding up trigger animation
        // Curves.elasticOut - fast elastic trigger
      ),
    );
  }
}
