import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _width = 200;
  double _height = 200;
  Color _color = Colors.lightBlue;

  void _updateState() {
    setState(() {
      _width = 400;
      _height = 400;
      _color = Colors.pink;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animation',
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  _updateState();
                },
                child: Text('Animate'),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 100),
                curve: Curves.bounceOut,
                width: _width,
                height: _height,
                color: _color,
                child: Center(
                  child: Text(
                    'Animation',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
