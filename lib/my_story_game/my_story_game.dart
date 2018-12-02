import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_demo/english_words_list/english_words_list.dart';

class MyStoryGame extends StatefulWidget {
  MyStoryGame({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyStoryGameState createState() => _MyStoryGameState();
}

class _MyStoryGameState extends State<MyStoryGame> {
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
      case 0:
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
      default:
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(itemList[index] + "\n\n还没做"),
//            duration: Duration(milliseconds: 4000)),
          action: SnackBarAction(label: '哦', onPressed: () {}),
        ));
        break;
    }
  }
}
