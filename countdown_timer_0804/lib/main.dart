import 'package:flutter/material.dart';
import 'countDownTimer.dart';//1:別ファイル

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: countDownTimer(key: null,),//2:別ファイルのクラス参照
    );
  }
}