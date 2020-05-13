import 'package:flutter/material.dart';
import 'test.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameScreen extends StatefulWidget {
  String userID;
  String gameUID;
  Future<String> turnID;
  GameScreen({Key key, this.userID, this.gameUID, this.turnID})
      : super(key: key);
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Firestore _firestore = Firestore.instance;
  double screenwidth;
  double screenheight;
  List players = [];
  List rounds = [];
  var theTimer;

  void initState() {
    autoUpdater();
  }

  void dataSetup() async {
    players = await getPlayerLists(widget.gameUID);
    rounds = await getRoundsList(widget.gameUID);
  }

  void autoUpdater() {
    const oneSec = const Duration(seconds: 1);
    theTimer = Timer.periodic(oneSec, (Timer t) => dataSetup());
  }

  void round() async {}

  void screendata() {}

  List<Widget> cityDisplay(list) {
    List<Widget> display = [];
    String item;
    for (item in list) {
      display.add(Image(
        image: AssetImage('$item'),
        height: 20.0,
        width: 20.0,
      ));
    }
    return (display);
  }

  Future giveChoice() {
    if (turnCheck(widget.gameUID, widget.userID) == true) {
      return (showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Choose General'),
              content: setupAlertDialoadContainer(),
            );
          }));
    }
  }

  Widget setupAlertDialoadContainer() {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: players.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(players[index]['name']),
          );
        },
      ),
    );
  }

  Future<bool> turnCheck(gameID, myID) async {
    final check = await getCurrentPlayer(myID);
    Future<String> turnID = widget.turnID;
    final response =
        await _firestore.collection('games/$gameID/$turnID').getDocuments();
    final json = response.documents;
    final index = json[0]['index'];
    final myturnID = json[0]['myTurn'];
    if (check == myturnID) {
      return (true);
    } else {
      return (false);
    }
  }

  @override
  Widget build(BuildContext context) {
    screenwidth = MediaQuery.of(context).size.width;
    screenheight = MediaQuery.of(context).size.height;
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
        body: Container(
          color: Colors.blueGrey,
          width: screenwidth,
//          height: screenheight,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('PARIS'),
                          Image(
                            width: 100.0,
                            image: AssetImage(
                              'images/city1.png',
                            ),
                          )
                        ],
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text('Cities'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Current Leader:'),
                            Text('Current General:'),
                            Text('Cities In Alien Control:'),
                            Text('Cities In Human Control:')
                          ],
                        ),
                        color: Colors.red,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Missions Until Skirmish:$players')
                          ],
                        ),
                        color: Colors.blue,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: FlatButton(
                              child: Text('Yes'),
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              onPressed: () {
                                print('Hello');
                              },
                            ),
                          ),
                          Container(
                            child: FlatButton(
                              child: Text('No'),
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              onPressed: () {
                                print('Hello');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: FlatButton(
                          child: Text('Choose General'),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          color: Colors.white,
                          onPressed: () {
                            print(widget.userID);
                            print(widget.gameUID);
                            giveChoice();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
