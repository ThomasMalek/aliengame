import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width: 50.0,
                height: 50.0,
                color: Colors.grey,
              ),
              Container(
                width: 50.0,
                height: 50.0,
                color: Colors.grey,
              ),
            ],
          )
        ],
      )),
    );
  }
}
