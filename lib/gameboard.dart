import 'package:flutter/material.dart';
import 'test.dart';

class GameScreen extends StatefulWidget {
  String userID;
  String gameUID;
  GameScreen({Key key, this.userID, this.gameUID}) : super(key: key);
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double screenwidth;
  double screenheight;

  void initState() {
    print(widget.userID);
    print(widget.gameUID);
  }

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
                          children: <Widget>[Text('Missions Until Skirmish:')],
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
                        color: Colors.orange,
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
