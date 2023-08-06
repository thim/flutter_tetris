import 'dart:math';

import 'package:flutter/material.dart';

import 'i_block.dart';
import 'j_block.dart';
import 'l_block.dart';
import 'point.dart';
import 's_block.dart';
import 'sq_block.dart';
import 't_block.dart';
import 'z_block.dart';

enum MoveDir { LEFT, RIGHT, DOWN }

const boardBottom = 0;

final random = Random();

abstract class Block {
  List<Point> points = [];
  Point? rotationCenter;
  Color? color;
  int boardWidth;

  Block(this.boardWidth);

  void move(MoveDir dir) {
    switch (dir) {
      case MoveDir.LEFT:
        if (canMoveToSide(-1)) {
          for (var p in points) {
            p.x -= 1;
          }
        }
        break;
      case MoveDir.RIGHT:
        if (canMoveToSide(1)) {
          for (var p in points) {
            p.x += 1;
          }
        }

        break;
      case MoveDir.DOWN:
        if(canMoveToDown(1)) {
          for (var p in points) {
            p.y += 1;
          }
        }
        break;
    }
  }

  List<Point> translate(int x, int y) => points.map<Point>((e) => Point(e.x + x, e.y + y)).toList();

  bool canMoveToSide(int moveAmt) {
    bool retVal = true;

    for (var point in points) {
      if (point.x + moveAmt < 0 || point.x + moveAmt >= boardWidth) {
        retVal = false;
      }
    }

    return retVal;
  }

  bool canMoveToDown(int moveAmt) {
    bool retVal = true;

    for (var point in points) {
      if (point.y + moveAmt > 14) {
        retVal = false;
      }
    }

    return retVal;
  }

  bool allPointsInside() {
    bool retVal = true;

    for (var point in points) {
      if (point.x < 0 || point.x >= boardWidth) {
        retVal = false;
      }
    }

    return retVal;
  }

  void rotateRight() {
    if (rotationCenter == null) return;
    for (var point in points) {
      int x = point.x;
      point.x = (rotationCenter?.x ?? 0) - point.y + (rotationCenter?.y ?? 0);
      point.y = (rotationCenter?.y ?? 0) + x - (rotationCenter?.x ?? 0);
    }

    if (allPointsInside() == false) {
      rotateLeft();
    }
  }

  void rotateLeft() {
    if (rotationCenter == null) return;

    for (var point in points) {
      int x = point.x;
      point.x = (rotationCenter?.x ?? 0) + point.y - (rotationCenter?.y ?? 0);
      point.y = (rotationCenter?.y ?? 0) - x + (rotationCenter?.x ?? 0);
    }

    if (allPointsInside() == false) {
      rotateRight();
    }
  }

  bool isAtTop() {
    int lowestPoint = 0;

    for (var point in points) {
      if (point.y > lowestPoint) {
        lowestPoint = point.y;
      }
    }

    if (lowestPoint <= 0) {
      return true;
    }

    return false;
  }

  bool isAtBottom() {
    int lowestPoint = 0;

    for (var point in points) {
      if (point.y > lowestPoint) {
        lowestPoint = point.y;
      }
    }

    if (lowestPoint >= boardBottom - 1) {
      return true;
    }

    return false;
  }

  factory Block.random(int boardWidth) {
    switch (random.nextInt(7)) {
      case 0:
        return IBlock(boardWidth);
      case 1:
        return JBlock(boardWidth);
      case 2:
        return LBlock(boardWidth);
      case 3:
        return SBlock(boardWidth);
      case 4:
        return SquareBlock(boardWidth);
      case 5:
        return TBlock(boardWidth);
      case 6:
      default:
        return ZBlock(boardWidth);
    }
  }
}
