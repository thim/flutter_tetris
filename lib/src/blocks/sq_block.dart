import 'package:flutter/material.dart';

import '../colors.dart';
import 'block.dart';
import 'point.dart';

// --
// --
class SquareBlock extends Block {
  SquareBlock(int width) : super(width) {
    points.add(Point((width / 2 - 0).floor(), -1));
    points.add(Point((width / 2 + 1).floor(), -1));
    points.add(Point((width / 2 - 0).floor(), 0));
    points.add(Point((width / 2 + 1).floor(), 0));
    color = GameColor.colorE;
  }
}
