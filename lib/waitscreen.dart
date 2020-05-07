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
  var theTimer;

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
    players = await getPlayerList();
    setState(() {});
  }

  void createGame() async {
    final playerList = await getPlayerList();
    final gameUID = await pushDoc('games', {'name': 'Game1'});
    for (DocumentSnapshot player in playerList) {
      final newPlayerID = await pushDoc('games/$gameUID/players', player.data);
      if (player.documentID == widget.userID) {
        widget.userID = newPlayerID;
      }
    }

//    DELETE PLAYERS COLLECTION HERE
//  except goes here to prevent data destruction
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
                Container(
                  margin: EdgeInsets.only(bottom: 20.0),
                  child: FlatButton(
                    color: Colors.white,
                    child: Text('Begin the Invasion'),
                    onPressed: () {
                      createGame();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameScreen(),
                        ),
                      );
                    },
                  ),
                ),
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
