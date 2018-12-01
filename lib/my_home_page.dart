import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_demo/english_words_list.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final itemList = <String>["English Words List", "Other More ..."];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _buildList(),
      ),
    );
  }

  Widget _buildList() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, index) {
          if (index >= itemList.length) {
            return null;
          }
          return new ListTile(
            title: new Text(
              "${index + 1}. ${itemList[index]}",
              style: const TextStyle(fontSize: 18.0),
            ),
            onTap: () {
              _onItemClick(context, index);
            },
          );
        });
  }

  _onItemClick(BuildContext context, int index) {
//    Scaffold.of(context).showSnackBar(new SnackBar(
//        content: new Text(itemList[index]),
//        duration: Duration(milliseconds: 1000)));
    if (index == 0) {
      Navigator.of(context).push(
        new MaterialPageRoute(
          builder: (context) {
            return new Scaffold(
              body: EnglishWordsList(title: itemList[index]),
            );
          },
        ),
      );
    }
  }
}
