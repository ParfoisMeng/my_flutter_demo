import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class EnglishWordsSavedList extends StatefulWidget {
  EnglishWordsSavedList({Key key, this.title, this.saved, this.database})
      : super(key: key);

  final String title;
  final Set<WordPair> saved;
  final Database database;

  @override
  _EnglishWordsSavedListState createState() => _EnglishWordsSavedListState();
}

class _EnglishWordsSavedListState extends State<EnglishWordsSavedList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView(children: _buildItem(context)),
    );
  }

  List<Widget> _buildItem(BuildContext context) {
    return ListTile.divideTiles(
      context: context,
      tiles: widget.saved.map(
        (pair) {
          return _buildItem2(context, pair);
        },
      ),
    ).toList();
  }

  Widget _buildItem2(BuildContext context, WordPair pair) {
    return Builder(builder: (BuildContext context) {
      return Center(
          child: ListTile(
        title: Text(pair.asPascalCase),
        trailing: Icon(Icons.close, color: Colors.red),
        onTap: () {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("确定要移除此单词吗？"),
            action: SnackBarAction(
              label: '确定！',
              onPressed: () {
                setState(() {
                  widget.saved.remove(pair);
                  deleteSQLiteData(pair);
                });
              },
            ),
          ));
        },
      ));
    });
  }

  Future deleteSQLiteData(WordPair pair) async {
    // Delete a record
    await widget.database.rawDelete(
        'DELETE FROM English_Words_Saved WHERE first = ? AND second = ?',
        [pair.first, pair.second]);
  }
}
