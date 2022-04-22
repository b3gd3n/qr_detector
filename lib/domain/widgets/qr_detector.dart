import 'package:barcode_detector/code_zone_entity.dart';
import 'package:barcode_detector/domain/painters/path_painter.dart';
import 'package:barcode_detector/domain/world_to_screen_coords.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../code_zone_notifier.dart';

// Provider tracking the CodeZone state
final codeZoneProvider =
    StateNotifierProvider<CodeZoneNotifier, CodeZone>((ref) {
  return CodeZoneNotifier();
});

// Provider tracking the state of the read content
final contentProvider = StateProvider<String>((ref) {
  return '';
});

class QrDetector extends ConsumerStatefulWidget {
  Color? areaColor;
  Color? triggeredColor;
  Curve? triggeredCurve;
  final double height;
  final double width;

  QrDetector({
    Key? key,
    this.areaColor,
    this.triggeredColor,
    this.triggeredCurve,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  _QrDetectorState createState() => _QrDetectorState();
}

class _QrDetectorState extends ConsumerState<QrDetector>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Tween<Offset> topLeftAnimation;
  late Tween<Offset> topRightAnimation;
  late Tween<Offset> bottomRightAnimation;
  late Tween<Offset> bottomLeftAnimation;
  late MobileScannerController controllerCam;
  late CurvedAnimation curvedAnimation;
  late String content;
  late Color areaColor;

  @override
  void initState() {
    super.initState();
    // Content initialization
    content = '';
    // Camera controller initialization
    controllerCam = MobileScannerController();
    controllerCam.facing = CameraFacing.back;

    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _setDefaultArea();

    curvedAnimation = CurvedAnimation(
      parent: controller,
      curve: widget.triggeredCurve ?? Curves.bounceOut,
    );
    controller.stop();

    // Controller listener,
    // at the end of the animation
    // calls the open link method
    // reset controller
    // sets the default scan zone
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        areaColor = widget.triggeredColor ?? Colors.greenAccent;
        Future.delayed(
          const Duration(seconds: 1),
          () {
            _launchURL();
            controller.reset();
            _setDefaultArea();
          },
        );
      }
    });
  }

  // Setting the color and coordinates of the default zone
  void _setDefaultArea() {
    areaColor = widget.areaColor ?? Colors.blueAccent;
    topLeftAnimation = Tween<Offset>(
        begin: Offset(widget.width / 8, widget.height / 8),
        end: Offset(widget.width / 8, widget.height / 8));
    topRightAnimation = Tween<Offset>(
        begin: Offset(widget.width / 1.15, widget.height / 8),
        end: Offset(widget.width / 1.15, widget.height / 8));
    bottomRightAnimation = Tween<Offset>(
        begin: Offset(widget.width / 1.15, widget.height / 1.15),
        end: Offset(widget.width / 1.15, widget.height / 1.15));
    bottomLeftAnimation = Tween<Offset>(
        begin: Offset(widget.width / 8, widget.height / 1.15),
        end: Offset(widget.width / 8, widget.height / 1.15));
  }

  // The method opens a link obtained from the content
  void _launchURL() async {
    content = ref.watch(contentProvider.state).state;
    if (!await launch(content)) throw 'Could not launch $content';
  }

  // The method updates the actual coordinates of the scan area
  void _getActualCords() {
    final CodeZone codeZone = ref.watch(codeZoneProvider);
    setState(() {
      // Transferring the result of the coordinate transformation method to an array
      final List<Offset> areaCorners = worldToScreenCoords(
        corners: [
          Offset(codeZone.topLeft.dx, codeZone.topLeft.dy),
          Offset(codeZone.topRight.dx, codeZone.topRight.dy),
          Offset(codeZone.bottomRight.dx, codeZone.bottomRight.dy),
          Offset(codeZone.bottomLeft.dx, codeZone.bottomLeft.dy),
        ],
      );
      topLeftAnimation.end = areaCorners[0];

      topRightAnimation.end = areaCorners[1];

      bottomRightAnimation.end = areaCorners[2];

      bottomLeftAnimation.end = areaCorners[3];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
              controller: controllerCam,
              onDetect: (barcode, args) {
                // Reading a link on detection
                ref.read(contentProvider.notifier).state = barcode.url!.url!;
                _getActualCords();
                // Reading corner coordinates during detection
                final codeZone = ref.read(codeZoneProvider.notifier);
                codeZone.onChange(
                  topLeft: barcode.corners![0],
                  topRight: barcode.corners![1],
                  bottomRight: barcode.corners![2],
                  bottomLeft: barcode.corners![3],
                );
                controller.forward();
              }),
          Stack(
            children: [
              AnimatedBuilder(
                  animation: controller,
                  builder: (BuildContext context, Widget? child) {
                    return CustomPaint(
                      child: Container(),
                      painter: PathPainter(
                        context: context,
                        areaColor: areaColor,
                        offset: const Offset(0.0, 0.0),
                        offset1: topLeftAnimation.evaluate(curvedAnimation),
                        offset2: topRightAnimation.evaluate(curvedAnimation),
                        offset3: bottomRightAnimation.evaluate(curvedAnimation),
                        offset4: bottomLeftAnimation.evaluate(curvedAnimation),
                      ),
                    );
                  }),
            ],
          ),
          //  Just label
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
          ),
          // ColorPalette()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controllerCam.stop();
          controllerCam.start();
        },
      ),
    );
  }
}
