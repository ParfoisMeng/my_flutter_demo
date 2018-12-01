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
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        itemBuilder: (context, i) {
          if (i.isOdd) {
            return new Divider(height: 1);
          }
          final index = i ~/ 2;
          if (index >= words.length) {
            words.addAll(generateWordPairs().take(20));
          }
          return new ListTile(
            title: new Text(
              stringLengthFormat(
                  "${index + 1}. ", words[index].asPascalCase, 8),
              style: const TextStyle(fontSize: 16.0),
            ),
          );
        });
  }

  stringLengthFormat(String prefix, String content, int length) {
    String result = prefix;
    for (int i = 0; i < length - prefix.length; i++) {
      result += " ";
    }
    result += content;
    return result;
  }
}
