import 'package:flutter/material.dart';
import 'gamepage.dart';
import 'test.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Aliens', initialRoute: '/', routes: {
      '/': (context) => MyHomePage(),
      '/game': (context) => GamePage(),
//      '/chooser': (context) => Chooser(),
    });
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String name = 'Player1';
  String avatar = 'www.google.com/imageurl.png';


  void initState() {
    //put in your initialization code here (NO UI BUILDS)
    print('Loading Home Page');
  }


  saveTestData() async {
    final resp = await pushDoc('players', {'name':name, 'avatar': avatar});
    print(resp);
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: <Widget>[
          Center(
            child: FlatButton(
              child: Text('Save Name'),
              color: Colors.blue,
              onPressed: () {saveTestData();},
            ),
          ),
        ],
      )),
    );
  }
}
