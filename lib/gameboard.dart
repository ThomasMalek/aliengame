import 'dart:math';

import 'package:flutter/material.dart';
import 'test.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameScreen extends StatefulWidget {
  String userID;
  String gameUID;
  Future<String> turnID;
  GameScreen({Key key, this.userID, this.gameUID}) : super(key: key);
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Firestore _firestore = Firestore.instance;
  double screenwidth;
  double screenheight;
  List players = [];
  List rounds = [];
  List votes = [];
  List scores = [];
  int turnIndex;
  int alienControl = 0;
  int humanControl = 0;
  String turnID;
  String leader = 'Loading....';
  var theTimer;
  Map myData = {};
  String myName = '';
  String myTeam = '';
  String voteID;
  List cityList = [];
  String cityName = 'Loading...';
  String cityImage = 'images/city1.png';
  int voteLength;
  int votesMade = 0;
  int votesYes = 0;
  int votesNo = 0;
  List citiesforDisplay;

  void initState() {
    autoUpdater();
    voteSystem(widget.gameUID, widget.userID);
    Future<String> turnID = widget.turnID;
    getMyData(widget.gameUID, widget.userID);
  }

  void getMyData(gameID, myID) async {
    final dataGet =
        await _firestore.document('games/$gameID/players/$myID').get();
    myData = dataGet.data;
    myName = myData['name'];
    if (myData['alien'] == true) {
      myTeam = 'Alien';
    } else {
      myTeam = 'Human';
    }
    setState(() {});
  }

  void dataSetup() async {
    players = await getPlayerLists(widget.gameUID);
    rounds = await getRoundsList(widget.gameUID);
    votes = await getVotesList(widget.gameUID);
    final votechecker = await voteStatus();
    final score = await pointsCheck(rounds);
    currentLeaderDisplay(widget.gameUID);
    currentRoundDisplay(widget.gameUID);
    setState(() {});
  }

  List<Widget> cityDisplayer() {
    List<Widget> widgetList = [];
    for (DocumentSnapshot city in rounds) {
      String current = city.data['cityName'];
      widgetList.add(Text('$current'));
    }
    return (widgetList);
  }

  void voteSystem(gameID, userID) async {
    voteID =
        await pushDoc('games/$gameID/vote', {'vote': null, 'voterID': userID});
  }

  void voteStatus() async {
    int counter = 0;
    voteLength = votes.length;
    for (DocumentSnapshot vote in votes) {
      if (vote.data['vote'] != null) {
        counter++;
      }
    }
    votesMade = counter;
    voteCounter(widget.gameUID);
    setState(() {});
  }

  void yesVote(gameID, voteID) async {
    final voteEntry =
        await addDoc('games/$gameID/vote', voteID, {'vote': true});
    setState(() {});
  }

  void noVote(gameID, voteID) async {
    final voteEntry =
        await addDoc('games/$gameID/vote', voteID, {'vote': false});
    setState(() {});
  }

  void resetVotes(gameID) async {
    for (DocumentSnapshot vote in votes) {
      String id = vote.documentID;
      final reset = await addDoc('games/$gameID/vote', id, {'vote': null});
    }
    setState(() {});
  }

  void voteCounter(gameID) async {
    int yesCount = 0;
    int noCount = 0;
    for (DocumentSnapshot vote in votes) {
      if (vote.data['vote'] == true) {
        yesCount++;
      } else if (vote.data['vote'] == false) {
        noCount++;
      } else {}
    }
    votesYes = yesCount;
    votesNo = noCount;
    setState(() {});
  }

  void pointsCheck(rounds) {
    int alienAmount = 0;
    int humanAmount = 0;
    for (DocumentSnapshot round in rounds) {
      if (round.data['teamControl'] == true) {
        alienAmount++;
      } else if (round.data['teamControl'] == false) {
        humanAmount++;
      }
    }
    alienControl = alienAmount;
    humanControl = humanAmount;
    setState(() {});
  }

  void autoUpdater() {
    const oneSec = const Duration(seconds: 1);
    theTimer = Timer.periodic(oneSec, (Timer t) => dataSetup());
  }

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

  Future giveChoice() async {
    final turncheck = await turnCheck(widget.gameUID, widget.userID);
    bool voteWait = true;
    List choices = choiceGeneration();
    if (turncheck == true) {
      if (votesMade == voteLength && votesYes > votesNo) {
        return (showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Choose General'),
                content: setupAlertDialoadContainer(choices),
              );
            }));
      } else if (votesMade == voteLength && votesNo >= votesYes) {
        final turnSwitcher = await turnChange(widget.gameUID);
        final voteReseter = await resetVotes(widget.gameUID);
      } else if (votesMade < voteLength) {
        print('Not Enough Votes');
      }
    }
  }

  Future<bool> voteStart() async {}

  void endRound(choice, game) async {
    String selection = choice;
    bool winner;
    if (choice == 'Alien') {
      winner = true;
    } else {
      winner = false;
    }
    for (DocumentSnapshot round in rounds) {
      if (round.data['Complete'] == true) {
        print('Round Completed');
      } else {
        String currentRound = round.documentID;
        final roundData = await addDoc('games/$game/rounds', currentRound,
            {'Complete': true, 'teamControl': winner});
        final turnSwitcher = await turnChange(widget.gameUID);
        final voteReseter = await resetVotes(widget.gameUID);
        break;
      }
    }
  }

  Widget setupAlertDialoadContainer(choices) {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: choices.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(choices[index]),
            onTap: () {
              Navigator.pop(context, endRound(choices[index], widget.gameUID));
            },
          );
        },
      ),
    );
  }

  void currentLeaderDisplay(gameID) async {
    final response =
        await _firestore.collection('games/$gameID/turn').getDocuments();
    final doclist = response.documents;
    final currentLeader = doclist[0].data['myTurn'];
    for (DocumentSnapshot player in players) {
      if (player.documentID == currentLeader) {
        leader = player.data['name'];
        setState(() {});
      }
    }
  }

  void currentRoundDisplay(gameID) async {
    for (DocumentSnapshot round in rounds) {
      Map data = round.data;
      if (data['Complete'] == false) {
        cityImage = data['cityimage'];
        cityName = data['cityName'];
        setState(() {});
        break;
      } else {}
    }
  }

  Future<bool> turnCheck(gameID, myID) async {
    final response =
        await _firestore.collection('games/$gameID/turn').getDocuments();
    final doclist = response.documents;
    final data = doclist[0].documentID;
    turnIndex = doclist[0]['index'];
    turnID = doclist[0]['myTurn'];
    if (myID == turnID) {
      return (true);
    } else {
      return (false);
    }
  }

  Future<bool> turnChange(gameID) async {
    final response =
        await _firestore.collection('games/$gameID/turn').getDocuments();
    final doclist = response.documents;
    final data = doclist[0].documentID;
    turnIndex = doclist[0].data['index'];
    int newTurnIndex = turnIndex + 1;
    if (turnIndex == players.length - 1) {
      newTurnIndex = 0;
    }
    final newLeader = (players[newTurnIndex].documentID);
    final indexChange = await addDoc('games/$gameID/turn', data,
        {'index': newTurnIndex, 'myTurn': newLeader});
  }

  List choiceGeneration() {
    List choiceList = [];
    List decision = [];
    Random random = new Random();
    int randomNumber1 = random.nextInt(16);
    int randomNumber2 = random.nextInt(16);
    int randomNumber3 = random.nextInt(16);
//    11 bad 6 good
    choiceList.add(randomNumber1);
    choiceList.add(randomNumber2);
    choiceList.add(randomNumber3);
    for (int choice in choiceList) {
      if (choice < 6) {
        decision.add('Human');
      } else {
        decision.add('Alien');
      }
    }
    return (decision);
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
                          Text('$cityName'),
                          Image(
                            width: 100.0,
                            image: AssetImage(
                              '$cityImage',
                            ),
                          )
                        ],
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: rounds.length,
                        itemBuilder: (context, int index) {
                          return new Card(
                            child: Container(
                              color: Colors.greenAccent,
                              child: ListTile(
                                title: Text(rounds[index]['cityName']),
                                subtitle: Column(
                                  children: <Widget>[
                                    Text('Population'),
                                    Text(rounds[index]['Population'])
                                  ],
                                ),
                                leading: CircleAvatar(
                                  radius: 20.0,
                                  backgroundColor: Colors.grey,
                                  backgroundImage:
                                      AssetImage(rounds[index]['cityimage']),
                                ),
                              ),
                            ),
                          );
                        },
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
                            Text('Current Leader: $leader'),
//                            Text('Current General:'), TODO FUTURE IMPLEMENTATION
                            Text('Cities In Alien Control: $alienControl'),
                            Text('Cities In Human Control: $humanControl')
                          ],
                        ),
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('You: $myName'),
                            Text('Team: $myTeam'),
                            Text('Votes: $votesMade / $voteLength')
                          ],
                        ),
                        color: Colors.grey,
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
                                yesVote(widget.gameUID, voteID);
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
                                noVote(widget.gameUID, voteID);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: FlatButton(
                          child: Text('Begin Battle'),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          color: Colors.white,
                          onPressed: () {
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
