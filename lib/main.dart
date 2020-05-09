import 'package:flutter/material.dart';
import 'waitscreen.dart';
import 'test.dart';
import 'gamefull.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Aliens', initialRoute: '/', routes: {
      '/': (context) => MyHomePage(),
      '/waitscreen': (context) => WaitScreen(),
      '/gamefull': (context) => GameFull(),
    });
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String name = 'Player';
  int playeramount;
  String userID;

  void initState() {}

  saveTestData() async {
    List players = await getPlayerList();
    var resp;
    String avatarpic = avatarGenerator();
    String avatarpicfinal = 'images/avatar$avatarpic.png';
    if (players.length == 0) {
      resp = await pushDoc(
          'players', {'name': name, 'avatar': avatarpicfinal, 'origin': true});
    } else {
      resp = await pushDoc(
          'players', {'name': name, 'avatar': avatarpicfinal, 'origin': false});
    }
    userID = resp;
  }

  String avatarGenerator() {
    Random rnd = new Random();
    int min = 1;
    int max = 40;
    String avatarnumber = (min + rnd.nextInt(max - min)).toString();
    return (avatarnumber);
  }

  void loginCheck() {
    checkPlayers();
    if (playeramount > 10) {
      Navigator.pushNamed(context, '/gamefull');
    } else {
      saveTestData();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WaitScreen(userID: userID),
        ),
      );
    }
  }

  void checkPlayers() async {
    playeramount = await playerCount();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(
            'Hostile Takeover',
            style: TextStyle(fontFamily: 'Alien', fontSize: 35.0),
          ),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Image(
                  image: AssetImage('images/alienface.png'),
                  width: 150.0,
                  height: 150.0,
                ),
              ),
              SizedBox(
                height: 45.0,
              ),
              Container(
                width: 300.0,
                child: TextField(
                  showCursor: false,
                  style: TextStyle(
                      color: Colors.greenAccent,
                      fontFamily: 'Alien',
                      fontSize: 35.0),
                  onChanged: (text) {
                    name = text;
                  },
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      hintStyle: TextStyle(
                          color: Colors.greenAccent,
                          fontFamily: 'Alien',
                          fontSize: 35.0),
                      border: OutlineInputBorder(),
                      hintText: 'Enter Your Name'),
                ),
              ),
              SizedBox(
                height: 45.0,
              ),
              FlatButton(
                  child: Text(
                    'Enlist',
                    style: TextStyle(fontFamily: 'Alien', fontSize: 40.0),
                  ),
                  color: Colors.green,
                  onPressed: () {
                    if (playeramount == null) {
                      checkPlayers();
                      loginCheck();
                    } else {
                      loginCheck();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
