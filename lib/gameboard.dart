import 'package:flutter/material.dart';
import 'test.dart';

class GameScreen extends StatefulWidget {
  String userID;
  GameScreen({Key key, this.userID}) : super(key: key);
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double screenwidth;
  double screenheight;
  void initState() {
    print(widget.userID);
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
          color: Colors.black,
          width: screenwidth,
//          height: screenheight,
          child: Column(
            children: <Widget>[Row()],
          ),
        ),
      ),
    );
  }
}
