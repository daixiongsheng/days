import 'dart:ui';

import 'package:flutter/material.dart';

import '../logger/logger.dart';

/// Construct a color from a string [color]
/// [color] is one of "#abc","#abcf","#aabbcc","#aabbccff"
Color parseColor(String color) {
  if (color.startsWith("#")) {
    color = color.substring(1);
  }
  String alpha = "ff";
  switch (color.length) {
    case 3:
      color =
          '${color[0]}${color[0]}${color[1]}${color[1]}${color[2]}${color[2]}';
      break;
    case 4:
      alpha = '${color[3]}${color[3]}';
      color =
          '${color[0]}${color[0]}${color[1]}${color[1]}${color[2]}${color[2]}';
      break;
    case 6:
      break;
    case 8:
      alpha = '${color[6]}${color[7]}';
      alpha = color.substring(6);
      color = color.substring(0, 6);
      break;
    default:
      logger
          .e('argument [color] is one of "#abc","#abcf","#aabbcc","#aabbccff"');
  }
  return Color(int.parse(color, radix: 16))
      .withAlpha(int.parse(alpha, radix: 16));
}

extension ToHex on Color {
  String toHex() {
    return '#${[
      red,
      green,
      blue,
      alpha
    ].map((e) => e.toRadixString(16)).join('')}';
  }
}
