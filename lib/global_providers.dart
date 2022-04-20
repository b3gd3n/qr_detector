import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final colorProvider = StateProvider<Color>((ref) {
  return Color.fromRGBO(30, 144, 255, 1);
});