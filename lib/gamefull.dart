import 'package:flutter/material.dart';

class GameFull extends StatefulWidget {
  @override
  _GameFullState createState() => _GameFullState();
}

void initState() {
  //put in your initialization code here (NO UI BUILDS)
  print('Loading Home Page');
}

class _GameFullState extends State<GameFull> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: <Widget>[
          Container(
            child: Text('The Game is Full.'),
          )
        ],
      )),
    );
  }
}
