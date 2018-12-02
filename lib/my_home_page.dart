import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter_demo/english_words_list/english_words_list.dart';
import 'package:my_flutter_demo/my_story_game/my_story_game.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final itemList = <String>[
    "English Words List",
    "My Story Game",
    "Other More ..."
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: _buildList(),
          ),
        ),
        onWillPop: () {
          showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    content: new Text('退出App？'),
                    actions: <Widget>[
                      new FlatButton(
                          onPressed: () {
                            SystemNavigator.pop();
                          },
                          child: new Text('确定'))
                    ]);
              });
          return Future.value(false);
        });
  }

  Widget _buildList() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: (context, index) {
          if (index >= itemList.length) {
            return null;
          }
          return ListTile(
            title: Text(
              "${index + 1}. ${itemList[index]}",
              style: TextStyle(fontSize: 18.0),
            ),
            onTap: () {
              _onItemClick(context, index);
            },
          );
        });
  }

  _onItemClick(BuildContext context, int index) {
    switch (index) {
      case 0: // "English Words List"
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return Scaffold(
                body: EnglishWordsList(title: itemList[index]),
              );
            },
          ),
        );
        break;
      case 1: // "My Story Game"
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return Scaffold(
                body: MyStoryGame(title: itemList[index]),
              );
            },
          ),
        );
        break;
      default: // "Other More ..."
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(itemList[index] + "\n\n还没做"),
//            duration: Duration(milliseconds: 4000)),
          action: SnackBarAction(label: '哦', onPressed: () {}),
        ));
        break;
    }
  }
}
