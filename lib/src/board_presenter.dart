import 'dart:async';
import 'dart:math';

import 'blocks/block.dart';
import 'blocks/point.dart';
import 'constants.dart';

enum GameState { play, idle, pause, end }

class BoardPresenter {
  int score = 0;
  bool turboTimer = false;
  bool paused = false;
  var size = tileSize;

  final List<Point> listBlocks = [];
  Block currentBlock = Block.random(columnsLength);
  Block nextBlock = Block.random(columnsLength);

  Timer? timer;

  void Function()? onUpdate;

  void newBlock() {
    currentBlock = nextBlock;
    nextBlock = Block.random(columnsLength);
  }

  void start() {
    paused = false;
    newBlock();
    listBlocks.clear();

    timer?.cancel();
    timer = Timer.periodic(const Duration(milliseconds: time), (timer) {
      final state = gameLoop(timer.tick);
      if (state == GameState.play) {
        onUpdate?.call();
      } else if (state == GameState.end) {
        timer.cancel();
      }
    });
  }

  bool canMove({double xDiff = 0,double yDiff = 0}) {
    if (paused) return false;
    for (var current in currentBlock.points) {
      for (var element in listBlocks) {
        final newCurrent = Rectangle(current.left(size) + xDiff, current.top(size) + yDiff, size, size);
        final inter = element.toRect(size).intersection(newCurrent);
        if ((inter?.height ?? 0) >= 2 && (inter?.width ?? 0) > 0) {
          return false;
        }
      }
    }

    return true;
  }

  void verify(Iterable<Point> list) {
    final lines = list.map((e) => e.y).toSet();
    final List<int> linesToRemove = [];
    for (var line in lines) {
      final blocks = listBlocks.where((element) => element.y == line);
      if (blocks.length == columnsLength) {
        linesToRemove.add(line);
      }
    }
    linesToRemove.sort();

    listBlocks.removeWhere((element) => linesToRemove.contains(element.y));

    for (var y in linesToRemove) {
      for (var block in listBlocks) {
        if (block.y < y) {
          block.y += 1;
        }
      }
    }

    score += linesToRemove.length + (linesToRemove.length ~/ 2);
  }
  
  void dump(){
    final dump = List.generate(15,(index) => <String>['-','-','-','-','-','-','-','-','-']);
    for (var block in listBlocks) {
      dump[block.y][block.x] = '#';
    }
    for (var line in dump) {
      print(line);
    }

  }

  GameState gameLoop(int tick) {
    if ((!turboTimer && tick % 4 != 0)) {
      return GameState.idle;
    }
    if (paused) {
      return GameState.pause;
    }

    var overlaps = false;
    for (var element2 in currentBlock.points) {
      for (var element in listBlocks) {
        final inter = element.toRect(size).intersection(element2.toRectShiftY(1, size));
        if (((inter?.height ?? 0) >= 0 && (inter?.width ?? 0) > 0)) {
          overlaps = true;
          break;
        }
      }
      if (overlaps || (element2.top(size) ~/ size) >= 14) {
        overlaps = true;
        break;
      }
    }

    if (overlaps) {
      final normalize = currentBlock.points.map((e) => Point(e.left(size) ~/ size, e.top(size) ~/ size));
      listBlocks.addAll(normalize);

      verify(normalize);

      if (currentBlock.isAtTop()) {
        return GameState.end;
      }

      newBlock();
    } else {
      currentBlock.move(MoveDir.DOWN);
    }

    return GameState.play;
  }

  void move(MoveDir dir) {
    var xDiff = 0.0;
    var yDiff = 0.0;
    switch (dir) {
      case MoveDir.LEFT:
        xDiff = -1.0;
        break;
      case MoveDir.RIGHT:
        xDiff = 1.0;
        break;
      case MoveDir.DOWN:
        yDiff = 2.0;
        break;
    }

    if (canMove(xDiff: xDiff, yDiff: yDiff)) {
      currentBlock.move(dir);
      onUpdate?.call();
    }
  }

  void rotate() {
    if (!paused) {
      currentBlock.rotateRight();
      onUpdate?.call();
    }
  }

  void pause() {
    paused = !paused;
    onUpdate?.call();
  }
}
