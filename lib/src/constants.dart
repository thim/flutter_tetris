import 'dart:math';

import 'blocks/point.dart';

const double tileSize = 50;
const int columnsLength = 9;
const double boardWidth = 600.0;

const int time = 200;
const double vel = 4.0;

extension PointExtension on Point {
  double top(double size) => y * size;

  double left(double size) => x * size;

  Rectangle toRect(double tileSize) => Rectangle(x * tileSize, y * tileSize, tileSize, tileSize);

  Rectangle toRectShiftY(int shift, double tileSize) => Rectangle(x * tileSize, y * tileSize + shift, tileSize, tileSize);
}
