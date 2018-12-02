import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_demo/english_words_list/english_words_saved.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class EnglishWordsList extends StatefulWidget {
  EnglishWordsList({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _EnglishWordsListState createState() => _EnglishWordsListState();
}

class _EnglishWordsListState extends State<EnglishWordsList> {
  final words = <WordPair>[];
  final _saved = Set<WordPair>();
  Database database;

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.list),
                onPressed: () {
                  _pushSavedFavoriteWords(context);
                })
          ],
        ),
        body: Center(
          child: _buildList(),
        ),
      ),
      onWillPop: () {
        closeSQLite();
        Navigator.pop(context);
        return new Future.value(false);
      },
    );
  }

  Widget _buildList() {
    initSQLiteData();
    return ListView.builder(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        itemBuilder: (context, i) {
          if (i.isOdd) {
            return Divider(height: 1);
          }
          final index = i ~/ 2;
          if (index >= words.length) {
            words.addAll(generateWordPairs().take(20));
          }
          return _buildItem(index, words[index]);
        });
  }

  Widget _buildItem(int index, WordPair pair) {
    var alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        stringLengthFormat("${index + 1}. ", pair.asPascalCase, 8),
        style: TextStyle(fontSize: 16.0),
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
            deleteSQLiteData(pair);
          } else {
            _saved.add(pair);
            insertSQLiteData(pair);
          }
        });
      },
    );
  }

  void _pushSavedFavoriteWords(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return EnglishWordsSavedList(
            title: "Saved Favorite Words",
            saved: _saved,
            database: database,
          );
        },
      ),
    );
  }

  String stringLengthFormat(String prefix, String content, int length) {
    String result = prefix;
    for (int i = 0; i < length - prefix.length; i++) {
      result += " ";
    }
    result += content;
    return result;
  }

  Future initSQLiteData() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    // open the database
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE English_Words_Saved (first TEXT, second TEXT)');
    });

    // Get the records
    List<Map> list =
        await database.rawQuery('SELECT * FROM English_Words_Saved');
    for (int i = 0; i < list.length; i++) {
      WordPair value = WordPair(list[i]["first"], list[i]["second"]);
      _saved.add(value);
    }
    print(_saved);
  }

  Future insertSQLiteData(WordPair pair) async {
    // Insert some records in a transaction
    await database.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO English_Words_Saved(first, second) VALUES(?, ?)',
          [pair.first, pair.second]);
    });
  }

  Future deleteSQLiteData(WordPair pair) async {
    // Delete a record
    await database.rawDelete(
        'DELETE FROM English_Words_Saved WHERE first = ? AND second = ?',
        [pair.first, pair.second]);
  }

  Future closeSQLite() async {
    // Close the database
    await database.close();
  }
}
