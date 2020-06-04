import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class StartupNamesApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      theme: ThemeData(primaryColor: Colors.blueGrey),
      home: Scaffold(
          appBar: AppBar(title: Text("Welcome to Flutter")),
          body: Center(
            child: RandomWords(),
          )),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();

  Widget _buildRow(WordPair pair) {
    bool alreadySaved = _saved.contains(pair);
    return NameDisplay(
        pair: pair,
        saved: alreadySaved,
        onTap: () => {
              setState(() {
                if (alreadySaved) {
                  _saved.remove(pair);
                } else {
                  _saved.add(pair);
                }
              })
            });
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider();
          /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      final Iterable<NameInteractive> tiles = _saved.map(
        (WordPair pair) {
          return NameInteractive(
              pair: pair,
              saved: true,
              onTap: () => {
                    setState(() {
                      if (_saved.contains(pair)) {
                        _saved.remove(pair);
                      } else {
                        _saved.add(pair);
                      }
                    })
                  });
        },
      );
      final List<Widget> divided =
          ListTile.divideTiles(tiles: tiles, context: context).toList();

      return Scaffold(
        appBar: AppBar(
          title: Text("Saved Suggestions"),
        ),
        body: ListView(
          children: divided,
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}

class NameDisplay extends StatelessWidget {
  final WordPair pair;
  final bool saved;
  final VoidCallback onTap;

  NameDisplay({this.pair, this.saved, this.onTap});

  @override
  Widget build(BuildContext context) {
    final _biggerFont = const TextStyle(fontSize: 18.0);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        saved ? Icons.favorite : Icons.favorite_border,
        color: saved ? Colors.red : null,
      ),
      onTap: onTap,
    );
  }
}

class NameInteractive extends StatefulWidget {
  final WordPair pair;
  final bool saved;
  final VoidCallback onTap;

  NameInteractive({this.pair, this.saved, this.onTap});

  @override
  State<StatefulWidget> createState() {
    return _NameInteractiveState(pair: pair, saved: saved, callback: onTap);
  }
}

class _NameInteractiveState extends State<NameInteractive> {
  final WordPair pair;
  final VoidCallback callback;

  bool saved;

  _NameInteractiveState({this.pair, this.saved, this.callback});

  void _save() {
    setState(() {
      if (saved) {
        saved = false;
      } else {
        saved = true;
      }
      callback();
    });
  }

  @override
  Widget build(BuildContext context) {
    final _biggerFont = const TextStyle(fontSize: 18.0);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        saved ? Icons.favorite : Icons.favorite_border,
        color: saved ? Colors.red : null,
      ),
      onTap: _save,
    );
  }
}
