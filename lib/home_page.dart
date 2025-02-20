import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import "package:flutter_application_2_pacman/constains.dart";
import "package:flutter_application_2_pacman/ghost1.dart";
import "package:flutter_application_2_pacman/ghost2.dart";
import "package:flutter_application_2_pacman/ghost3.dart";
import "package:flutter_application_2_pacman/path.dart";
import "package:flutter_application_2_pacman/pixel.dart";
import "package:flutter_application_2_pacman/player.dart"; 
void main() => runApp(const MyApp());


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static int numberInRow = 11;
  int numberOfSquares = numberInRow * 16;
  int player = numberInRow * 14 + 1;
  int ghost = numberInRow * 2 - 2;
  int ghost2 = numberInRow * 9 - 1;
  int ghost3 = numberInRow * 11 - 2;
  List<int> food = [];
  bool preGame = true;
  bool mouthClosed = false;
  int score = 0;
  bool paused = false;
  String direction = 'right';
  String ghostLast = 'left';
  String ghostLast2 = 'up';
  String ghostLast3 = 'down';

  //Función para iniciar el juego y configurar los temporizadores
  void startGame() {
    if (preGame) {
      preGame = false;
      getFood();
      //Función para detectar la colisión de un fantasma
      Timer.periodic(Duration(milliseconds: 10), (timer) {
        if (player == ghost || player == ghost2 || player == ghost3) {
          setState(() {
            player = -1;
          });
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Center(child: Text('¡Game over!')),
                  content: Text('Your Score:  $score'),
                  actions: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          player = numberInRow * 14 + 1;
                          ghost = numberInRow * 2 - 2;
                          ghost2 = numberInRow * 9 - 1;
                          ghost3 = numberInRow * 11 - 2;
                          paused = false;
                          preGame = false;
                          mouthClosed = false;
                          direction = 'right';
                          food.clear();
                          getFood();
                          score = 0;
                          Navigator.pop(context);
                        });
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFF0D47A1),
                              Color(0xFF1976D2),
                              Color(0xFF42A5F5),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child: const Text('Play Again'),
                      ),
                    )
                  ],
                );
              });
        }
      });
      //Temporizador para mover a los fantasmas
      Timer.periodic(Duration(milliseconds: 190), (timer) {
        if (!paused) {
          moveGhost();
          moveGhost2();
          moveGhost3();
        }
      });
      //Temporizador para mover el pacman y consumir comida
      Timer.periodic(Duration(milliseconds: 170), (timer) {
        setState(() {
          mouthClosed = !mouthClosed;
        });
        if (food.contains(player)) {
          setState(() {
            food.remove(player);
          });
          score += 10;
        }
        switch (direction) {
          case 'left':
            if (!paused) moveLeft();
            break;
          case 'right':
            if (!paused) moveRight();
            break;
          case 'up':
            if (!paused) moveUp();
            break;
          case 'down':
            if (!paused) moveDown();
            break;
        }
      });
    }
  }

  @override
  void initState() {
    getFood();
    super.initState();
  }
  //Función para consumir la comida
  void getFood() {
    for (int i = 0; i < numberOfSquares; i++) {
      if (!Constains.barriers.contains(i)) {
        food.add(i);
      }
    }
  }

  void restart() {
    startGame();
  }
  //Funciones para mover al pacman
  void moveLeft() {
    if (!Constains.barriers.contains(player - 1)) {
      setState(() {
        player--;
      });
    }
  }

  void moveRight() {
    if (!Constains.barriers.contains(player + 1)) {
      setState(() {
        player++;
      });
    }
  }

  void moveUp() {
    if (!Constains.barriers.contains(player - numberInRow)) {
      setState(() {
        player -= numberInRow;
      });
    }
  }

  void moveDown() {
    if (!Constains.barriers.contains(player + numberInRow)) {
      setState(() {
        player += numberInRow;
      });
    }
  }
  //Función para mover a los fantasmsas
  void moveGhost() {
    switch (ghostLast) {
      case "left":
        if (!Constains.barriers.contains(ghost - 1)) {
          setState(() {
            ghost--;
          });
        } else {
          if (!Constains.barriers.contains(ghost + numberInRow)) {
            setState(() {
              ghost += numberInRow;
              ghostLast = "down";
            });
          } else if (!Constains.barriers.contains(ghost + 1)) {
            setState(() {
              ghost++;
              ghostLast = "right";
            });
          } else if (!Constains.barriers.contains(ghost - numberInRow)) {
            setState(() {
              ghost -= numberInRow;
              ghostLast = "up";
            });
          }
        }
        break;
      case "right":
        if (!Constains.barriers.contains(ghost + 1)) {
          setState(() {
            ghost++;
          });
        } else {
          if (!Constains.barriers.contains(ghost - numberInRow)) {
            setState(() {
              ghost -= numberInRow;
              ghostLast = "up";
            });
          } else if (!Constains.barriers.contains(ghost + numberInRow)) {
            setState(() {
              ghost += numberInRow;
              ghostLast = "down";
            });
          } else if (!Constains.barriers.contains(ghost - 1)) {
            setState(() {
              ghost--;
              ghostLast = "left";
            });
          }
        }
        break;
      case "up":
        if (!Constains.barriers.contains(ghost - numberInRow)) {
          setState(() {
            ghost -= numberInRow;
            ghostLast = "up";
          });
        } else {
          if (!Constains.barriers.contains(ghost + 1)) {
            setState(() {
              ghost++;
              ghostLast = "right";
            });
          } else if (!Constains.barriers.contains(ghost - 1)) {
            setState(() {
              ghost--;
              ghostLast = "left";
            });
          } else if (!Constains.barriers.contains(ghost + numberInRow)) {
            setState(() {
              ghost += numberInRow;
              ghostLast = "down";
            });
          }
        }
        break;
      case "down":
        if (!Constains.barriers.contains(ghost + numberInRow)) {
          setState(() {
            ghost += numberInRow;
            ghostLast = "down";
          });
        } else {
          if (!Constains.barriers.contains(ghost - 1)) {
            setState(() {
              ghost--;
              ghostLast = "left";
            });
          } else if (!Constains.barriers.contains(ghost + 1)) {
            setState(() {
              ghost++;
              ghostLast = "right";
            });
          } else if (!Constains.barriers.contains(ghost - numberInRow)) {
            setState(() {
              ghost -= numberInRow;
              ghostLast = "up";
            });
          }
        }
        break;
    }
  }

  void moveGhost2() {
    switch (ghostLast2) {
      case "left":
        if (!Constains.barriers.contains(ghost2 - 1)) {
          setState(() {
            ghost2--;
          });
        } else {
          if (!Constains.barriers.contains(ghost2 + numberInRow)) {
            setState(() {
              ghost2 += numberInRow;
              ghostLast2 = "down";
            });
          } else if (!Constains.barriers.contains(ghost2 + 1)) {
            setState(() {
              ghost2++;
              ghostLast2 = "right";
            });
          } else if (!Constains.barriers.contains(ghost2 - numberInRow)) {
            setState(() {
              ghost2 -= numberInRow;
              ghostLast2 = "up";
            });
          }
        }
        break;
      case "right":
        if (!Constains.barriers.contains(ghost2 + 1)) {
          setState(() {
            ghost2++;
          });
        } else {
          if (!Constains.barriers.contains(ghost2 - numberInRow)) {
            setState(() {
              ghost2 -= numberInRow;
              ghostLast2 = "up";
            });
          } else if (!Constains.barriers.contains(ghost2 + numberInRow)) {
            setState(() {
              ghost2 += numberInRow;
              ghostLast2 = "down";
            });
          } else if (!Constains.barriers.contains(ghost2 - 1)) {
            setState(() {
              ghost2--;
              ghostLast2 = "left";
            });
          }
        }
        break;
      case "up":
        if (!Constains.barriers.contains(ghost2 - numberInRow)) {
          setState(() {
            ghost2 -= numberInRow;
            ghostLast2 = "up";
          });
        } else {
          if (!Constains.barriers.contains(ghost2 + 1)) {
            setState(() {
              ghost2++;
              ghostLast2 = "right";
            });
          } else if (!Constains.barriers.contains(ghost2 - 1)) {
            setState(() {
              ghost2--;
              ghostLast2 = "left";
            });
          } else if (!Constains.barriers.contains(ghost2 + numberInRow)) {
            setState(() {
              ghost2 += numberInRow;
              ghostLast2 = "down";
            });
          }
        }
        break;
      case "down":
        if (!Constains.barriers.contains(ghost2 + numberInRow)) {
          setState(() {
            ghost2 += numberInRow;
            ghostLast2 = "down";
          });
        } else {
          if (!Constains.barriers.contains(ghost2 - 1)) {
            setState(() {
              ghost2--;
              ghostLast2 = "left";
            });
          } else if (!Constains.barriers.contains(ghost2 + 1)) {
            setState(() {
              ghost2++;
              ghostLast2 = "right";
            });
          } else if (!Constains.barriers.contains(ghost2 - numberInRow)) {
            setState(() {
              ghost2 -= numberInRow;
              ghostLast2 = "up";
            });
          }
        }
        break;
    }
  }

  void moveGhost3() {
    switch (ghostLast) {
      case "left":
        if (!Constains.barriers.contains(ghost3 - 1)) {
          setState(() {
            ghost3--;
          });
        } else {
          if (!Constains.barriers.contains(ghost3 + numberInRow)) {
            setState(() {
              ghost3 += numberInRow;
              ghostLast3 = "down";
            });
          } else if (!Constains.barriers.contains(ghost3 + 1)) {
            setState(() {
              ghost3++;
              ghostLast3 = "right";
            });
          } else if (!Constains.barriers.contains(ghost3 - numberInRow)) {
            setState(() {
              ghost3 -= numberInRow;
              ghostLast3 = "up";
            });
          }
        }
        break;
      case "right":
        if (!Constains.barriers.contains(ghost3 + 1)) {
          setState(() {
            ghost3++;
          });
        } else {
          if (!Constains.barriers.contains(ghost3 - numberInRow)) {
            setState(() {
              ghost3 -= numberInRow;
              ghostLast3 = "up";
            });
          } else if (!Constains.barriers.contains(ghost3 - 1)) {
            setState(() {
              ghost3--;
              ghostLast3 = "left";
            });
          } else if (!Constains.barriers.contains(ghost3 + numberInRow)) {
            setState(() {
              ghost3 += numberInRow;
              ghostLast3 = "down";
            });
          }
        }
        break;
      case "up":
        if (!Constains.barriers.contains(ghost3 - numberInRow)) {
          setState(() {
            ghost3 -= numberInRow;
            ghostLast3 = "up";
          });
        } else {
          if (!Constains.barriers.contains(ghost3 + 1)) {
            setState(() {
              ghost3++;
              ghostLast3 = "right";
            });
          } else if (!Constains.barriers.contains(ghost3 - 1)) {
            setState(() {
              ghost3--;
              ghostLast3 = "left";
            });
          } else if (!Constains.barriers.contains(ghost3 + numberInRow)) {
            setState(() {
              ghost3 += numberInRow;
              ghostLast3 = "down";
            });
          }
        }
        break;
      case "down":
        if (!Constains.barriers.contains(ghost3 + numberInRow)) {
          setState(() {
            ghost3 += numberInRow;
            ghostLast3 = "down";
          });
        } else {
          if (!Constains.barriers.contains(ghost3 - 1)) {
            setState(() {
              ghost3--;
              ghostLast3 = "left";
            });
          } else if (!Constains.barriers.contains(ghost3 + 1)) {
            setState(() {
              ghost3++;
              ghostLast3 = "right";
            });
          } else if (!Constains.barriers.contains(ghost3 - numberInRow)) {
            setState(() {
              ghost3 -= numberInRow;
              ghostLast3 = "up";
            });
          }
        }
        break;
    }
  }
  //Lo que resta del código es para darle formato a la pantalla de incio y configurar algunos aspectos de la lógica
  //tales como los giros del pacman y el movimiento de los fantasmas, pero es más que nada para 
  // darle color y personalidad a los widgets, icons, etc. 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
              flex: (MediaQuery.of(context).size.height * 0.0139).toInt(),
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 0) {
                    direction = 'down';
                  } else if (details.delta.dy < 0) {
                    direction = 'up';
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (details.delta.dx > 0) {
                    direction = 'right';
                  } else if (details.delta.dx < 0) {
                    direction = 'left';
                  }
                },
                child: GridView.builder(
                  padding:
                      (MediaQuery.of(context).size.height * 0.0139).toInt() > 10
                          ? const EdgeInsets.only(top: 80)
                          : const EdgeInsets.only(top: 20),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: numberOfSquares,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: numberInRow,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    if (mouthClosed && player == index) {
                      return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.yellow, shape: BoxShape.circle),
                          ));
                    } else if (player == index) {
                      switch (direction) {
                        case 'left':
                          return Transform.rotate(
                            angle: pi,
                            child: const Player(),
                          );
                        case 'right':
                          return const Player();
                        case 'up':
                          return Transform.rotate(
                            angle: 3 * pi / 2,
                            child: const Player(),
                          );
                        case 'down':
                          return Transform.rotate(
                            angle: pi / 2,
                            child: const Player(),
                          );
                        default:
                          return const Player();
                      }
                    } else if (ghost == index) {
                      return const MyGhost();
                    } else if (ghost2 == index) {
                      return const MyGhost2();
                    } else if (ghost3 == index) {
                      return const MyGhost3();
                    } else if (Constains.barriers.contains(index)) {
                      return Pixel(
                        innerColor: Colors.blue[900],
                        outerColor: Colors.blue[800],
                      );
                    } else if (preGame || food.contains(index)) {
                      return MyPath(
                        innerColor: Colors.yellow,
                        outerColor: Colors.black,
                      );
                    } else {
                      return const Pixel(
                        innerColor: Colors.black,
                        outerColor: Colors.black,
                      );
                    }
                  },
                ),
              ),
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Score: $score',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                GestureDetector(
                    onTap: startGame,
                    child: Text(
                      "P L A Y",
                      style: TextStyle(color: Colors.white, fontSize: 23),
                    )),
                if (!paused)
                  GestureDetector(
                      child: const Icon(
                        Icons.pause,
                        color: Colors.white,
                      ),
                      onTap: () {
                        if (!paused) {
                          paused = true;
                        } else {
                          paused = false;
                        }
                        const Icon(Icons.play_arrow, color: Colors.white);
                      }),
                if (paused)
                  GestureDetector(
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                      ),
                      onTap: () => {
                            if (paused)
                              {
                                paused = false,
                              }
                            else
                              {
                                paused = true,
                              }
                          })
              ],
            ))
          ],
        ));
  }
}