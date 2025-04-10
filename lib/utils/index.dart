import 'package:flutter/material.dart';

Color getTextColorFromBackgroundColor(String backgroundColor) {
  final color = Color(int.parse(backgroundColor));
  final luminance = color.computeLuminance();
  return luminance > 0.5 ? Colors.black : Colors.white;
}
