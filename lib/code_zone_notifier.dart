import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'code_zone_entity.dart';

class CodeZoneNotifier extends StateNotifier<CodeZone> {
  CodeZoneNotifier()
      : super(const CodeZone(
          topLeft: Offset(0, 0),
          topRight: Offset(0, 0),
          bottomRight: Offset(0, 0),
          bottomLeft: Offset(0, 0),
        ));

  void onChange({
    required Offset topLeft,
    required Offset topRight,
    required Offset bottomRight,
    required Offset bottomLeft,
  }) {
    state = state.copyWith(
      topLeft: topLeft,
      topRight: topRight,
      bottomRight: bottomRight,
      bottomLeft: bottomLeft,
    );
  }

  // Offset _topLeft = const Offset(0, 0);
  //
  // Offset get topLeft => _topLeft;
  //
  // set topLeft(Offset value) {
  //   _topLeft = value;
  // }
  //
  // Offset _topRight = const Offset(0, 0);
  //
  // Offset get topRight => _topRight;
  //
  // set topRight(Offset value) {
  //   _topRight = value;
  // }
  //
  // Offset _bottomRight = const Offset(0, 0);
  //
  // Offset get bottomRight => _bottomRight;
  //
  // set bottomRight(Offset value) {
  //   _bottomRight = value;
  // }
  //
  // Offset _bottomLeft = const Offset(0, 0);
  //
  // Offset get bottomLeft => _bottomLeft;
  //
  // set bottomLeft(Offset value) {
  //   _bottomLeft = value;
  // }
}
