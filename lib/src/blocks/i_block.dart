import '../colors.dart';
import 'block.dart';
import 'point.dart';

// ----
class IBlock extends Block {
  IBlock(int width) : super(width) {
    points.add(Point((width / 2 - 2).floor(), -1));
    points.add(Point((width / 2 - 1).floor(), -1));
    points.add(Point((width / 2 - 0).floor(), -1));
    points.add(Point((width / 2 + 1).floor(), -1));
    rotationCenter = points[1];
    color = GameColor.colorA;
  }
}
