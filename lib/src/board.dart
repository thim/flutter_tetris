import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tetris/src/board_presenter.dart';

import 'blocks/block.dart';
import 'colors.dart';
import 'constants.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({Key? key}) : super(key: key);

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  double swipeX = 0.0;
  double swipeY = 0.0;

  BoardPresenter presenter = BoardPresenter();

  @override
  void initState() {
    super.initState();
    RawKeyboard.instance.addListener(_onKey);
    gameStart();
  }

  void gameStart() {
    presenter.onUpdate = () => setState(() {});
    presenter.start();
  }

  void _onKey(RawKeyEvent event) {
    if (event is RawKeyUpEvent) {
      presenter.turboTimer = false;
      return;
    }

    final key = event.data.logicalKey;

    if (key == LogicalKeyboardKey.arrowUp) {
      presenter.rotate();
    } else if (key == LogicalKeyboardKey.arrowDown) {
      presenter.turboTimer = true;
      presenter.move(MoveDir.DOWN);
    } else if (key == LogicalKeyboardKey.arrowLeft) {
      presenter.move(MoveDir.LEFT);
    } else if (key == LogicalKeyboardKey.arrowRight) {
      presenter.move(MoveDir.RIGHT);
    } else if (key == LogicalKeyboardKey.space) {
      presenter.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    var currentTileSize = (screenWidth ~/ 12).toDouble();
    if (currentTileSize > tileSize) {
      currentTileSize = tileSize;
    }
    presenter.size = currentTileSize;

    return Scaffold(
      body: Center(
        child: Container(
          width: boardWidth,
          color: GameColor.background,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                  left: 0,
                  top: 10,
                  width: currentTileSize * columnsLength,
                  height: currentTileSize * 15,
                  child: GestureDetector(
                    onPanEnd: (details) {
                      swipeX = 0.0;
                      swipeY = 0.0;
                    },
                    onDoubleTap: () {
                      presenter.rotate();
                    },
                    onPanUpdate: (details) {
                      if (details.delta.dx > 0.3) {
                        swipeX += 0.5;
                      } else if (details.delta.dx < -0.3) {
                        swipeX -= 0.5;
                      } else if (details.delta.dy > 0.3) {
                        swipeY += 0.5;
                      } else if (details.delta.dy < -0.3) {
                        swipeY -= 0.5;
                      }

                      if (swipeX > 4) {
                        swipeX = 0.0;
                        presenter.move(MoveDir.RIGHT);
                      } else if (swipeX < -4) {
                        swipeX = 0.0;
                        presenter.move(MoveDir.LEFT);
                      } else if (swipeY > 4) {
                        swipeY = 0.0;
                        presenter.move(MoveDir.DOWN);
                      } else if (swipeY < -4) {
                        swipeY = 0.0;
                        presenter.rotate();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                          color: GameColor.board,
                          border: Border.all(
                            color: GameColor.color0,
                            width: 1.0,
                          )),
                    ),
                  )),


              ...presenter.listBlocks.map((e) => Positioned(
                  top: e.top(currentTileSize) +10,
                  left: e.left(currentTileSize),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                      color: GameColor.blockGroup,
                      //border: Border.all(color: GameColor.blockGroup, width: 1.0,)
                    ),
                    //color: GameColor.blockGroup,
                    height: currentTileSize,
                    width: currentTileSize,
                  ))),

              ...presenter.currentBlock.points.map((e) => Positioned(
                  top: e.top(currentTileSize) +10,
                  left: e.left(currentTileSize),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                        color: presenter.currentBlock.color ?? GameColor.block,
                        border: Border.all(
                          color: GameColor.color0,
                          width: 1.0,
                        )),
                    //color: currentBlock.color ?? GameColor.block,
                    height: currentTileSize,
                    width: currentTileSize,
                  ))),

              Positioned(
                left: currentTileSize * columnsLength + 10,
                top: 10,
                width: currentTileSize * 3 - 10,
                height: currentTileSize * 2,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                      color: GameColor.board,
                      border: Border.all(
                        color: GameColor.color0,
                        width: 1.0,
                      )),
                ),
              ),

              Positioned(
                  left: currentTileSize * columnsLength + 20,
                  top: 15,
                  width: currentTileSize * 3,
                  height: currentTileSize * 2,
                  child: Text(
                    'Next',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: GameColor.text),
                  )),
              ...presenter.nextBlock.translate(17, 2).map((e) => Positioned(
                  top: e.top(currentTileSize) / 2 + 20,
                  left: e.left(currentTileSize) / 2,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                        color: presenter.nextBlock.color ?? GameColor.block,
                        border: Border.all(
                          color: GameColor.color0,
                          width: 1.0,
                        )),
                    //color: presenter.nextBlock.color ?? GameColor.block,
                    height: currentTileSize / 2,
                    width: currentTileSize / 2,
                  ))),

              Positioned(
                left: currentTileSize * columnsLength + 10,
                top: 120,
                width: currentTileSize * 3 - 10,
                height: currentTileSize * 2,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                      color: GameColor.board,
                      border: Border.all(
                        color: GameColor.color0,
                        width: 1.0,
                      )),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  alignment: Alignment.center,
                  child: Text(
                    '${presenter.score} ♦',
                    style: Theme.of(context).textTheme.headline4?.copyWith(color: GameColor.text),
                  ),
                ),
              ),
              if (presenter.paused)
                Positioned(
                  top: 190,
                  right: 20,
                  child: Text(
                    'PAUSED',
                    style: Theme.of(context).textTheme.headline5?.copyWith(color: GameColor.text),
                  ),
                ),
              Positioned(
                top: 250,
                right: 45,
                child: FloatingActionButton(
                  onPressed: () {
                    presenter.pause();
                  },
                  tooltip: 'Pause',
                  child: const Icon(Icons.pause),
                ),
              ),
              Positioned(
                top: 350,
                right: 45,
                child: FloatingActionButton(
                  onPressed: () {
                    gameStart();
                  },
                  tooltip: 'Restart',
                  child: const Icon(Icons.games),
                ),
              ),
              Positioned(
                bottom: 50,
                left: 40,
                child: FloatingActionButton(
                  onPressed: () {
                    presenter.move(MoveDir.LEFT);
                  },
                  tooltip: 'Left',
                  child: const Icon(Icons.arrow_back),
                ),
              ),
              Positioned(
                bottom: 50,
                left: 180,
                child: FloatingActionButton(
                  onPressed: () {
                    presenter.move(MoveDir.RIGHT);
                  },
                  tooltip: 'Right',
                  child: const Icon(Icons.arrow_forward),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 110,
                child: FloatingActionButton(
                  onPressed: () {
                    presenter.move(MoveDir.DOWN);
                  },
                  tooltip: 'Down',
                  child: const Icon(Icons.arrow_downward),
                ),
              ),
              Positioned(
                bottom: 50,
                right: 40,
                child: FloatingActionButton(
                  onPressed: () {
                    presenter.rotate();
                  },
                  tooltip: 'Rotate',
                  child: const Icon(Icons.rotate_left),
                ),
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
