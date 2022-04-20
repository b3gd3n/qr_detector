import 'package:barcode_detector/global_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ColorPalette extends ConsumerWidget {
  final pickerColor = Colors.deepOrange;
  const ColorPalette({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: SizedBox(
        height: 500,
        width: 500,
        child: BlockPicker(
          pickerColor: pickerColor,
          onColorChanged: (c) => ref.read(colorProvider.state).state = c,
        ),
      ),
    );
  }
}
//(c) => ref.read(colorProvider.state).state = c
