import 'package:aliens/gameboard.dart';
import 'package:flutter/material.dart';
import 'test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:math';

class WaitScreen extends StatefulWidget {
  String userID;
  WaitScreen({Key key, this.userID}) : super(key: key);
  @override
  _WaitScreenState createState() => _WaitScreenState();
}

class _WaitScreenState extends State<WaitScreen> {
  List players;
  String gameID;
  Map currentPlayer = {};
  var theTimer;
  List<Map> cityList = [
    {
      'cityimage': 'images/city1.png',
      'teamControl': 0,
      'cityName': 'Paris',
      'Population': '2.4 Million'
    },
    {
      'cityimage': 'images/city2.png',
      'teamControl': 0,
      'cityName': 'Chicago',
      'Population': '2.76 Million'
    },
    {
      'cityimage': 'images/city3.png',
      'teamControl': 0,
      'cityName': 'London',
      'Population': '8.982 Million'
    },
    {
      'cityimage': 'images/city4.png',
      'teamControl': 0,
      'cityName': 'New York',
      'Population': '8.39 Million'
    },
    {
      'cityimage': 'images/city5.png',
      'teamControl': 0,
      'cityName': 'Cairo',
      'Population': '9.5 Million'
    },
    {
      'cityimage': 'images/city6.png',
      'teamControl': 0,
      'cityName': 'Tokyo',
      'Population': '9.27 Million'
    },
    {
      'cityimage': 'images/city7.png',
      'teamControl': 0,
      'cityName': 'Mumbai',
      'Population': '12.44 Million'
    },
    {
      'cityimage': 'images/city8.png',
      'teamControl': 0,
      'cityName': 'Shanghai',
      'Population': '23.4 Million'
    },
    {
      'cityimage': 'images/city9.png',
      'teamControl': 0,
      'cityName': 'Bogota',
      'Population': '7.42 Million'
    },
    {
      'cityimage': 'images/city10.png',
      'teamControl': 0,
      'cityName': 'Moscow',
      'Population': '11.92 Million'
    },
    {
      'cityimage': 'images/city11.png',
      'teamControl': 0,
      'cityName': 'Istanbul',
      'Population': '15.52 Million'
    },
  ];

  void initState() {
    updatePlayers();
    autoUpdater();
    getPlayerInfo(widget.userID);
  }

  void autoUpdater() {
    const oneSec = const Duration(seconds: 1);
    theTimer = Timer.periodic(oneSec, (Timer t) => updatePlayers());
  }

  void getPlayerInfo(userID) async {
    Map player = await getCurrentPlayer(userID);
  }

  void dispose() {
    theTimer.cancel();
  }

  void updatePlayers() async {
    setState(() {});
    players = await getPlayerList();
    currentPlayer = await getCurrentPlayer(widget.userID);
    if (currentPlayer['newID'] != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameScreen(
            userID: currentPlayer['newID'],
            gameUID: gameID,
          ),
        ),
      );
    }
  }

  Future<String> createGame() async {
    final playerList = await getPlayerList();
    final gameUID = await pushDoc('games', {'name': 'Game'});
    gameID = gameUID;
    for (DocumentSnapshot player in playerList) {
      final newPlayerID = await pushDoc('games/$gameUID/players', player.data);
      final response = await addDoc('players', player.documentID,
          {'newID': newPlayerID, 'gameID': gameID});
      if (player.documentID == widget.userID) {
        widget.userID = newPlayerID;
      }
    }
    for (var city in cityList) {
      print(city);
      final newCity = await pushDoc('games/$gameUID/rounds', {
        'cityimage': city['cityimage'],
        'teamControl': city['teamcontrol'],
        'cityName': city['cityName'],
        'Population': city['Population']
      });
    }
//    DELETE PLAYERS COLLECTION HERE
//  except goes here to prevent data destruction
    return (gameUID);
  }

  Future<List> generateTeams(playerlist, gameUID) async {
    int teamNumber = playerlist.length;
    int aliens = 0;
    int humans = 0;
    final playerList = await getPlayerLists(gameUID);
    if (teamNumber >= 5 && teamNumber <= 10) {
      if (teamNumber.isEven == true) {
        aliens = (teamNumber / 2).round() - 1;
        humans = (teamNumber / 2).round() + 1;
      } else if (teamNumber.isOdd == true) {
        aliens = (teamNumber / 2).round() - 1;
        humans = (teamNumber / 2).round();
      }
      List shuffledList = shuffle(playerList);
      final setAlienLeader = await addDoc('games/$gameUID/players',
          shuffledList[0].documentID, {'alien': true, 'leader': true});
      shuffledList.removeAt(0);
      int counter = 0;
      while (counter < aliens - 2) {
        final setAlienLeader = await addDoc('games/$gameUID/players',
            shuffledList[0].documentID, {'alien': true, 'leader': false});
        shuffledList.removeAt(0);
        counter++;
      }
      counter = 0;
      while (counter < humans) {
        final setAlienLeader = await addDoc('games/$gameUID/players',
            shuffledList[0].documentID, {'alien': false, 'leader': false});
        shuffledList.removeAt(0);
        counter++;
      }
      for (DocumentSnapshot player in shuffledList) {
        String docID = player.documentID;
        final setAlienLeader = await addDoc(
            'games/$gameUID/players', docID, {'alien': true, 'leader': false});
      }
    }
  }

  void gameSetup() async {
    final availablePlayers = await getPlayerList();
    if (availablePlayers.length >= 5 && availablePlayers.length <= 10) {
      String gameID = await createGame();
      generateTeams(players, gameID);
//      Navigator.push(
//        context,
//        MaterialPageRoute(
//          builder: (context) => GameScreen(
//            userID: widget.userID,
//            gameUID: gameID,
//          ),
//        ),
//      );
    } else {
      print('Not Enough Players');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Hostile Takeover',
            style: TextStyle(fontFamily: 'Alien', fontSize: 35.0),
          ),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 25.0),
              child: Text(
                'Players',
                style: TextStyle(
                    fontSize: 45.0,
                    fontFamily: 'Alien',
                    color: Colors.greenAccent),
              ),
            ),
            players == null
                ? Container()
                : Expanded(
                    child: ListView.builder(
                      itemCount: players.length,
                      itemBuilder: (context, int index) {
                        return new Card(
                          child: ListTile(
                            title: Text(players[index]['name']),
                            leading: CircleAvatar(
                              radius: 20.0,
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  AssetImage(players[index]['avatar']),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Image(
                      image: AssetImage('images/alienface.png'),
                      width: 100.0,
                      height: 100.0,
                    ),
                  ),
                ),
                currentPlayer['origin'] == true
                    ? Container(
                        margin: EdgeInsets.only(bottom: 20.0),
                        child: FlatButton(
                          color: Colors.white,
                          child: Text('Begin the Invasion'),
                          onPressed: () {
                            gameSetup();
                          },
                        ),
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget getTextWidgets(List<String> strings) {
  return new Row(children: strings.map((item) => new Text(item)).toList());
}
