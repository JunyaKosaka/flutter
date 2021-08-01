import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //httpリクエスト用
import 'dart:async'; //非同期処理用
import 'dart:convert'; //httpレスポンスをJSON形式に変換用

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late Map data;
  late List userData;

  Future getData() async{
    http.Response response = await http.get("http://116.91.113.180:8080/v1/wallet/get_notice");
    String res = utf8.decode(response.bodyBytes);
    final data = jsonDecode(res);
    // data = json.decode(response.body); //json->Mapオブジェクトに格納
    setState(() { //状態が変化した場合によばれる
      userData = data["data"];
    }); //Map->Listに必要な情報だけ格納
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notice"),
      ),
      body: Container(
        width: double.infinity,
        child: ListView.builder(
          itemCount: userData.length,
          itemBuilder: (context, index) {
            return _buildListTile(index);
          },
        ),
      ),
    );
  }

  Widget _buildListTile(int index) {
    return Container(
      decoration: BoxDecoration(
          border: const Border(
              bottom: const BorderSide(
                color: const Color(0x1e333333),
                width: 1,
              )
          )
      ),
      height: 120,
      child: Column(
        children: [
          _buildTitleRow(index),
          _buildSummaryRow(index),
        ],
      ),
    );
  }

  Widget _buildTitleRow(int index) {
    return ListTile(
      title: Text(
        userData[index]["subject"].substring(0, 17),
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
      ),
      trailing: Text(userData[index]["addDate"], style: TextStyle(fontSize: 9),),
    );
  }

  Widget _buildSummaryRow(int index) {
    return ListTile(
      title: Text(userData[index]["summary"].substring(0, 40), style: TextStyle(fontSize: 12),),
      trailing: Text('詳細', style: TextStyle(fontSize: 8, color: Colors.blue),),
      onTap: () {
        _showDetail(index);
      },
    );
  }

  void _showDetail(int index) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Detail'),
            ),
            body: Container(
              padding: EdgeInsets.all(8),
              width: double.infinity,
              child: Column(
                children: [
                  Text(userData[index]["subject"], style: TextStyle(fontSize: 16),),
                  Text(userData[index]["details"].substring(0, 200)),
                ],
              ),
              ),
          );
        },
      ),
    );
  }
}
