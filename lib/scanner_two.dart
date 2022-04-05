import 'package:barcode_detector/code_zone_entity.dart';
import 'package:barcode_detector/painter.dart';
import 'package:barcode_detector/painter_four.dart';
import 'package:barcode_detector/painter_three.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:riverpod/riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'code_zone_notifier.dart';
import 'content_page.dart';

final codeZoneProvider =
    StateNotifierProvider<CodeZoneNotifier, CodeZone>((ref) {
  return CodeZoneNotifier();
});

final contentProvider = StateProvider<String>((ref) {
  return '';
});

class ScannerTwo extends ConsumerStatefulWidget {
  const ScannerTwo({Key? key}) : super(key: key);

  @override
  _ScannerTwoState createState() => _ScannerTwoState();
}

class _ScannerTwoState extends ConsumerState<ScannerTwo>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Tween<Offset> topLeftAnimation;
  late Tween<Offset> topRightAnimation;
  late Tween<Offset> bottomRightAnimation;
  late Tween<Offset> bottomLeftAnimation;
  late MobileScannerController controllerCam;
  late CurvedAnimation curvedAnimation;
  late int counter;
  late String content;
  late Color areaColor;

  @override
  void initState() {
    super.initState();
    areaColor = Colors.blueAccent;
    content = '';
    counter = 0;
    controllerCam = MobileScannerController();
    controllerCam.facing = CameraFacing.back;
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    topLeftAnimation = Tween<Offset>(
        begin: const Offset(414 / 4, 736 / 4.5),
        end: const Offset(414 / 4, 736 / 4.5));
    topRightAnimation = Tween<Offset>(
        begin: const Offset(414 / 1.3, 736 / 4.5),
        end: const Offset(414 / 1.3, 736 / 4.5));
    bottomRightAnimation = Tween<Offset>(
        begin: const Offset(414 / 1.3, 736 / 2),
        end: const Offset(414 / 1.3, 736 / 2));
    bottomLeftAnimation = Tween<Offset>(
        begin: const Offset(414 / 4, 736 / 2),
        end: const Offset(414 / 4, 736 / 2));
    curvedAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
    );
    controller.stop();
  }

  Route _createRoute() {
    content = ref.watch(contentProvider.state).state;
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          Content(url: content),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.bounceInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  void _launchURL() async {
    content = ref.watch(contentProvider.state).state;
    if (!await launch(content)) throw 'Could not launch $content';
  }

  @override
  Widget build(BuildContext context) {
    print(counter);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    print('build width  $width');
    setState(() {
      topLeftAnimation = Tween<Offset>(
          begin: Offset(width / 8, height / 8),
          end: Offset(width / 8, height / 8));
      topRightAnimation = Tween<Offset>(
          begin: Offset(width / 1.15, height / 8),
          end: Offset(width / 1.15, height / 8));
      bottomRightAnimation = Tween<Offset>(
          begin: Offset(width / 1.15, height / 1.15),
          end: Offset(width / 1.15, height / 1.15));
      bottomLeftAnimation = Tween<Offset>(
          begin: Offset(width / 8, height / 1.15),
          end: Offset(width / 8, height / 1.15));
    });
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        areaColor = Colors.greenAccent;
        Future.delayed(
          const Duration(seconds: 1),
          () {

            if (counter == 0) {
              counter++;
              controller.stop();
              // Navigator.of(context).push(_createRoute());
              _launchURL();
              print('target00');
            }
          },
        );

      }
    });

    // controllerCam.barcodes.listen((event) {
    //   print('eeeeee $event');
    // });

    final CodeZone codeZone = ref.watch(codeZoneProvider);
    print('watch ${codeZone.topLeft.dx}');
    setState(() {
      topLeftAnimation.end =
          Offset((codeZone.topLeft.dx / 2.3) - 40, codeZone.topLeft.dy / 2);

      topRightAnimation.end =
          Offset((codeZone.topRight.dx / 2.1) - 40, codeZone.topRight.dy / 2);

      bottomRightAnimation.end = Offset(
          (codeZone.bottomRight.dx / 2.1) - 40, codeZone.bottomRight.dy / 1.9);

      bottomLeftAnimation.end = Offset(
          (codeZone.bottomLeft.dx / 2.3) - 40, codeZone.bottomLeft.dy / 1.9);
      // controller.forward();
    });
    // ref.listen<CodeZone>(codeZoneProvider, (CodeZone? previous, CodeZone next) {
    //   print('pree $previous');
    //   setState(() {
    //     final codeZoneNext = next;
    //     final codeZonePrev = previous as CodeZone;
    //     topLeftAnimation.begin = Offset(
    //         (codeZonePrev.topLeft.dx / 2.3) - 40, codeZonePrev.topLeft.dy / 2);
    //     topLeftAnimation.end = Offset(
    //         (codeZoneNext.topLeft.dx / 2.3) - 40, codeZoneNext.topLeft.dy / 2);
    //
    //     topRightAnimation.begin = Offset((codeZonePrev.topRight.dx / 2.1) - 40,
    //         codeZonePrev.topRight.dy / 2);
    //     topRightAnimation.end = Offset((codeZoneNext.topRight.dx / 2.1) - 40,
    //         codeZoneNext.topRight.dy / 2);
    //
    //     bottomRightAnimation.begin = Offset(
    //         (codeZonePrev.bottomRight.dx / 2.1) - 40,
    //         codeZonePrev.bottomRight.dy / 1.9);
    //     bottomRightAnimation.end = Offset(
    //         (codeZoneNext.bottomRight.dx / 2.1) - 40,
    //         codeZoneNext.bottomRight.dy / 1.9);
    //
    //     bottomLeftAnimation.begin = Offset(
    //         (codeZonePrev.bottomLeft.dx / 2.3) - 40,
    //         codeZonePrev.bottomLeft.dy / 1.9);
    //     bottomLeftAnimation.end = Offset((codeZoneNext.bottomLeft.dx / 2.3) - 40,
    //         codeZoneNext.bottomLeft.dy / 1.9);
    //
    //   });
    //   topLeftAnimation.evaluate(controller);
    // });

    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
              controller: controllerCam,
              // MobileScannerController(
              //   facing: CameraFacing.back,
              //   torchEnabled: false,
              // ),
              onDetect: (barcode, args) {
                ref.read(contentProvider.notifier).state = barcode.url!.url!;

                final codeZone = ref.read(codeZoneProvider.notifier);
                print('w - ${context.size?.width} h - ${context.size?.height}');
                codeZone.onChange(
                  topLeft: barcode.corners![0],
                  topRight: barcode.corners![1],
                  bottomRight: barcode.corners![2],
                  bottomLeft: barcode.corners![3],
                );
                controller.forward();
                // controller.reset();
                final String? code = barcode.rawValue;
                debugPrint('Barcode found! $code');
                debugPrint('${barcode.corners}');
              }),
          Stack(
            children: [
              AnimatedBuilder(
                  animation: controller,
                  builder: (BuildContext context, Widget? child) {
                    print('wig');
                    return CustomPaint(
                      child: Container(),
                      painter: OpenPainterFour(
                        context: context,
                        areaColor: areaColor,
                        offset: const Offset(0.0, 0.0),
                        offset1: topLeftAnimation.evaluate(controller),
                        offset2: topRightAnimation.evaluate(controller),
                        offset3: bottomRightAnimation.evaluate(controller),
                        offset4: bottomLeftAnimation.evaluate(controller),
                      ),
                    );
                  }),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 50),
              width: 200,
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey.withOpacity(0.5)),
              child: const Center(
                child: Text(
                  'Scan Code!',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // _showMyDialog();
          controllerCam.stop();
          controllerCam.start();
          // controller.forward();
        },
      ),
    );
  }

  Future<void> _showMyDialog(String data) async {
    return showCupertinoDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        final width = MediaQuery.of(context).size.width;
        final height = MediaQuery.of(context).size.height;
        return AlertDialog(
          title: const Text(''),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('$data'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Reset'),
              onPressed: () {
                // topLeftAnimation.end = Offset(width/4,
                //     height/4.5);
                // topRightAnimation.end =  Offset(width/1.3,
                //     height/4.5);
                // bottomLeftAnimation.end = Offset(width/4,
                //     height/2);
                // bottomRightAnimation.end = Offset(width/1.3,
                //     height/2);
                controller.reset();
                // controller.forward();
                controllerCam.stop();
                controllerCam.start();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class TargetArea extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addPolygon([
      Offset(0, size.height / 2),
      Offset(size.width / 2, 0),
      Offset(size.width, size.height / 2),
      Offset(size.width / 2, size.height)
    ], true);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
