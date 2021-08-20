import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pacman/pacman.dart';

import 'barriers.dart';
import 'ghost.dart';
import 'pixel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static int numberOfSquares = numberInRow * 17;
  static int numberInRow = 11;
  int player = 166;
  int ghost = 20;
  bool mouthClosed = true;
  int score = 0;

  var barriers = <int>{
    // 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 22, 33, 44, 55, 66, 77, 99, 110, 121, 132, 143, 154, 165,
    // 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 175, 164, 153, 142, 131, 120, 109, 87, 76, 65, 54, 43,
    32, 21, 78, 79, 80, 100, 101, 102, 84, 85, 86, 106, 107, 108,
    24, 35, 46, 57, 30, 41, 52, 63, 81, 70, 59, 61, 72, 83, 26, 28,
    37, 38, 39, 123, 134, 145, 156, 129, 140, 151, 162, 103, 114, 125, 105,
    116, 127, 147, 148, 149, 158, 160
  };

  void getBarriers() {
    for (int i = 0; i < numberOfSquares; i++) {
      if (i < numberInRow || i >= numberOfSquares - numberInRow)
        barriers.add(i);
      if (i % numberInRow == 0 || i % numberInRow == numberInRow - 1)
        barriers.add(i);
    }
    barriers.remove(88);
    barriers.remove(98);
  }

  List<int> food = [];

  void getFood() {
    for (int i = 0; i < numberOfSquares; i++) {
      if (!barriers.contains(i)) {
        bool check = Random().nextBool();
        if (check == true) food.add(i);
      }
    }
  }

  String direction = "right";
  bool gameStarted = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBarriers();
    getFood();
  }

  void startGame() {
    moveGhost();
    gameStarted = true;
    Duration duration = Duration(milliseconds: 240);
    Timer.periodic(duration, (timer) {
      setState(() {
        mouthClosed = !mouthClosed;
      });
      if (food.contains(player)) {
        food.remove(player);
        score++;
      }

      if (player == ghost) {
        ghost = -1;
      }

      switch (direction) {
        case "right":
          moveRight();
          break;
        case "up":
          moveUp();
          break;
        case "left":
          moveLeft();
          break;
        case "down":
          moveDown();
          break;
      }
    });
  }

  String ghostDirection = "left"; // initial；
  Map<String, String> oppositeDirection = {
    "left": "right",
    "right": "left",
    "up": "down",
    "down": "up",
  };

  Map<int, int> loop = {
    88: 98,
    98: 88,
  };

  void moveGhost() {
    Duration ghostSpeed = Duration(milliseconds: 340);
    Timer.periodic(ghostSpeed, (timer) {
      List<String> possibleMove = [];
      if (ghost == 98 && ghostDirection == "right") possibleMove.add("right");
      if (ghost == 88 && ghostDirection == "left") possibleMove.add("left");
      if (!barriers.contains(ghost - 1) && ghostDirection != "right") {
        possibleMove.add("left");
        // ghostDirection = "left";
      }
      if (!barriers.contains(ghost - numberInRow) && ghostDirection != "down") {
        possibleMove.add("up");
        // ghostDirection = "up";
      }
      if (!barriers.contains(ghost + numberInRow) && ghostDirection != "up") {
        possibleMove.add("down");
        // ghostDirection = "down";
      }
      if (!barriers.contains(ghost + 1) && ghostDirection != "left") {
        possibleMove.add("right");
        // ghostDirection = "right";
      }
      if (possibleMove.length == 0)
        possibleMove.add(oppositeDirection[ghostDirection] ?? "left");

      int num = Random().nextInt(possibleMove.length);
      ghostDirection = possibleMove[num];
      switch (ghostDirection) {
        case "right":
          setState(() {
            if (ghost == 98)
              ghost = 88;
            else
              ghost++;
          });
          break;

        case "up":
          setState(() {
            ghost -= numberInRow;
          });
          break;

        case "left":
          setState(() {
            if (ghost == 88)
              ghost = 98;
            else
              ghost--;
          });
          break;

        case "down":
          setState(() {
            ghost += numberInRow;
          });
          break;
      }
    });
  }

  void moveRight() {
    setState(() {
      if (player == 98)
        player = 88;
      else if (!barriers.contains(player + 1)) {
        player += 1;
      }
    });
  }

  void moveUp() {
    setState(() {
      if (!barriers.contains(player - numberInRow)) {
        player -= numberInRow;
      }
    });
  }

  void moveLeft() {
    setState(() {
      if (player == 88)
        player = 98;
      else if (!barriers.contains(player - 1)) {
        player -= 1;
      }
    });
  }

  void moveDown() {
    setState(() {
      if (!barriers.contains(player + numberInRow)) {
        player += numberInRow;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Center(
              child: Container(
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (details.delta.dy > 0) {
                      direction = "down";
                    } else if (details.delta.dy < 0) {
                      direction = "up";
                    }
                  },
                  onHorizontalDragUpdate: (details) {
                    if (details.delta.dx > 0) {
                      direction = "right";
                    } else if (details.delta.dx < 0) {
                      direction = "left";
                    }
                  },
                  child: Container(
                    child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: numberOfSquares,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: numberInRow),
                        itemBuilder: (BuildContext context, int index) {
                          if (player == index) {
                            if (!mouthClosed) {
                              return Padding(
                                padding: EdgeInsets.all(4),
                                child: Container(
                                    decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.yellow,
                                )),
                              );
                            } else {
                              if (direction == "right") {
                                return PacmanDude();
                              } else if (direction == "up") {
                                return Transform.rotate(
                                    angle: 3 * pi / 2, child: PacmanDude());
                              } else if (direction == "left") {
                                return Transform.rotate(
                                    angle: pi, child: PacmanDude());
                              } else if (direction == "down") {
                                return Transform.rotate(
                                    angle: pi / 2, child: PacmanDude());
                              }
                            }
                          } else if (ghost == index) {
                            return Ghost();
                          } else if (barriers.contains(index)) {
                            return MyBarrier(
                              innerColor: Colors.blue[800],
                              outerColor: Colors.blue[900],
                              //child: Center(child: Text(index.toString(), style: TextStyle(fontSize: 10,color: Colors.white),)),
                            );
                          } else if (food.contains(index)) {
                            return MyPixel(
                              innerColor: Colors.yellow,
                              outerColor: Colors.black,
                              //child: Center(child: Text(index.toString(), style: TextStyle(fontSize: 10,color: Colors.white),)),
                            );
                          } else {
                            return MyPixel(
                              innerColor: Colors.black,
                              outerColor: Colors.black,
                              //child: Center(child: Text(index.toString(), style: TextStyle(fontSize: 10,color: Colors.white),)),
                            );
                          }
                          return MyPixel(
                            innerColor: Colors.black,
                            outerColor: Colors.black,
                            //child: Center(child: Text(index.toString(), style: TextStyle(fontSize: 10,color: Colors.white),)),
                          );
                        }),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Score: " + score.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: startGame,
                    child: Text(
                      "P L A Y",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
