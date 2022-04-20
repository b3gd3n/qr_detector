import 'package:barcode_detector/code_zone_entity.dart';
import 'package:barcode_detector/domain/painters/path_painter.dart';
import 'package:barcode_detector/domain/widgets/color_palette.dart';
import 'package:barcode_detector/domain/world_to_screen_coords.dart';
import 'package:barcode_detector/global_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:riverpod/riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../code_zone_notifier.dart';
import '../../content_page.dart';

final codeZoneProvider =
    StateNotifierProvider<CodeZoneNotifier, CodeZone>((ref) {
  return CodeZoneNotifier();
});

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
  _ScannerTwoState createState() => _ScannerTwoState();
}

class _ScannerTwoState extends ConsumerState<QrDetector>
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

    content = '';
    counter = 0;
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

  void _launchURL() async {
    content = ref.watch(contentProvider.state).state;
    if (!await launch(content)) throw 'Could not launch $content';
  }

  void _getActualCords() {
    final CodeZone codeZone = ref.watch(codeZoneProvider);
    setState(() {
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
                ref.read(contentProvider.notifier).state = barcode.url!.url!;
                _getActualCords();
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
