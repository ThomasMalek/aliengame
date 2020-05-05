import 'package:flutter/material.dart';
import 'gamepage.dart';

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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: <Widget>[],
      )),
    );
  }
}
