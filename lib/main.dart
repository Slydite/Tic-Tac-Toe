import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

//enum DifficultySelector { childp, normal, difficult, destruction, pvp }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool oTurn = true;
  List<String> marker = ['', '', '', '', '', '', '', '', ''];
  int oScore = 0;
  int xScore = 0;
  int drawScore = 0;
  int filledBoxes = 0;
  void _tapped(int index) {
    final player = AudioCache();
    setState(() {
      if (oTurn && marker[index] == '') {
        marker[index] = 'O';
        filledBoxes++;
        player.play('o.mp3');
      } else if (!oTurn && marker[index] == '') {
        marker[index] = 'X';
        filledBoxes++;
        player.play('x.mp3');
        //player.play('x1.mp3');
      }

      oTurn = !oTurn;
      _checkWinner();
    });
  }

  void _checkWinner() {
    // Checking rows
    if (marker[0] == marker[1] && marker[0] == marker[2] && marker[0] != '') {
      _showWinDialog(marker[0]);
    } else if (marker[3] == marker[4] &&
        marker[3] == marker[5] &&
        marker[3] != '') {
      _showWinDialog(marker[3]);
    } else if (marker[6] == marker[7] &&
        marker[6] == marker[8] &&
        marker[6] != '') {
      _showWinDialog(marker[6]);
    }

    // Checking Column
    else if (marker[0] == marker[3] &&
        marker[0] == marker[6] &&
        marker[0] != '') {
      _showWinDialog(marker[0]);
    } else if (marker[1] == marker[4] &&
        marker[1] == marker[7] &&
        marker[1] != '') {
      _showWinDialog(marker[1]);
    } else if (marker[2] == marker[5] &&
        marker[2] == marker[8] &&
        marker[2] != '') {
      _showWinDialog(marker[2]);
    }

    // Checking Diagonal
    else if (marker[0] == marker[4] &&
        marker[0] == marker[8] &&
        marker[0] != '') {
      _showWinDialog(marker[0]);
    } else if (marker[2] == marker[4] &&
        marker[2] == marker[6] &&
        marker[2] != '') {
      _showWinDialog(marker[2]);
    } else if (filledBoxes == 9) {
      _showDrawDialog();
    }
  }

  void _showWinDialog(String winner) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.blue,
            title: Text(
              winner + " is the Winner!",
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              FlatButton(
                child:
                    Text("Play Again", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  _clearBoard();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });

    if (winner == 'O') {
      oScore++;
    } else if (winner == 'X') {
      xScore++;
    }
  }

  void _showDrawDialog() {
    drawScore++;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.blue,
            title: Text("Draw", style: TextStyle(color: Colors.white)),
            actions: [
              FlatButton(
                child:
                    Text("Play Again", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  _clearBoard();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _clearBoard() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        marker[i] = '';
      }
    });

    filledBoxes = 0;
  }

  void _clearScoreBoard() {
    setState(() {
      xScore = 0;
      oScore = 0;
      drawScore = 0;
      for (int i = 0; i < 9; i++) {
        marker[i] = '';
      }
    });
    filledBoxes = 0;
  }

  @override
  Widget build(BuildContext context) {
    //DifficultySelector selection = DifficultySelector.pvp;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(255, 235, 59, 4),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.height,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
              Widget>[
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                      onPressed: _clearScoreBoard,
                      icon: Icon(Icons.refresh, color: Colors.black, size: 40))
                  /* PopupMenuButton<DifficultySelector>(
                      shape: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      icon: const Icon(Icons.settings_outlined,
                          color: Colors.black),
                      color: Colors.blue,
                      iconSize: 35,
                      onSelected: (DifficultySelector result) {
                        setState(() {
                          selection = result;
                          print(selection);
                        });
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<DifficultySelector>>[
                            PopupMenuItem<DifficultySelector>(
                              value: DifficultySelector.pvp,
                              child: Text(
                                'PvP',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const PopupMenuItem<DifficultySelector>(
                              value: DifficultySelector.childp,
                              child: Text(
                                'Child\'s Play',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const PopupMenuItem<DifficultySelector>(
                              value: DifficultySelector.normal,
                              child: Text(
                                'Normal',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const PopupMenuItem<DifficultySelector>(
                              value: DifficultySelector.difficult,
                              child: Text(
                                'Difficult',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const PopupMenuItem<DifficultySelector>(
                              value: DifficultySelector.destruction,
                              child: Text(
                                'Impossible',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
               */
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  'X Wins',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[700],
                                  ),
                                ),
                                Text(
                                  xScore.toString(),
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[700],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        VerticalDivider(
                          color: Colors.black,
                          thickness: 2,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  'Draws',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  drawScore.toString(),
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        VerticalDivider(
                          color: Colors.black,
                          thickness: 2,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  'O Wins',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[600],
                                  ),
                                ),
                                Text(
                                  oScore.toString(),
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[600],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Flexible(
                    child: GridView.builder(
                        padding: EdgeInsets.all(1),
                        shrinkWrap: true,
                        itemCount: 9,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              _tapped(index);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                      color: Colors.black, width: 2)),
                              child: Center(
                                child: Text(marker[index],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 60,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
//TODO: Change difficulty selector's popup menu to drop down if not too much work
//TODO: Fix colour scheme
