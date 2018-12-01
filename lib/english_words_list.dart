import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EnglishWordsList extends StatefulWidget {
  EnglishWordsList({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _EnglishWordsListState createState() => _EnglishWordsListState();
}

class _EnglishWordsListState extends State<EnglishWordsList> {
  final words = <WordPair>[];
  final _saved = Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.list), onPressed: _pushSavedFavoriteWords),
        ],
      ),
      body: Center(
        child: _buildList(),
      ),
    );
  }

  Widget _buildList() {
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
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSavedFavoriteWords() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return new ListTile(
                title: new Text(pair.asPascalCase),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Saved Favorite Words'),
            ),
            body: new ListView(children: divided),
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
}
