import 'package:flutter/material.dart';
import 'dart:async';//3:timerのためのインポート

class countDownTimer extends StatefulWidget {//4:StatefulWidgetが必要？
  countDownTimer({ Key? key}) : super(key: key);

  @override
  _countDownTimerState createState() => _countDownTimerState();//5:実装クラスに渡している
}

class _countDownTimerState extends State<countDownTimer> {
  static const int START = 4;
  int _start = START;
  bool _flag = false;

  void _startTimer() {
    _flag = true;
    _start = START;
    Timer.periodic(
      Duration(seconds: 1),
          (Timer timer) => setState(
            () {
          if (_start < 2) {
            _flag = false;
            timer.cancel();
          } else {
            _start--;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CountDown"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _flag ? '$_start' : '',
              style: TextStyle(fontSize: 200, fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startTimer,
        tooltip: 'Start',
        child: Icon(Icons.arrow_right, size: 50,),
      ),
    );
  }
}
