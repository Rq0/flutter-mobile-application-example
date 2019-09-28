import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(          // Add the 3 lines from here...
        primaryColor: Colors.black,
      ),
      home: buildUserPageWidget(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _saved = Set<WordPair>();   // Add this line.
  final TextStyle _biggerFont = TextStyle(fontSize: 18.0);

  Widget _buildSuggestions() {
    return ListView.builder(
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }
  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {      // Add 9 lines from here...
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
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
                (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final List<Widget> divided = ListTile
              .divideTiles(
            context: context,
            tiles: tiles,
          )
              .toList();

          return Scaffold(         // Add 6 lines from here...
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );                       // ... to here.
        },
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[      // Add 3 lines from here...
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}


Widget buildUserPageWidget() {
  EventList<Event> _markedDateMap;
  DateTime dd = DateTime.now();

  Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: new Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );

  return FutureBuilder(
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      EventList<Event> _markedDateMap = new EventList<Event>(events: {
        new DateTime(2019, 1, 24): [
          new Event(
            date: new DateTime(2019, 9, 24),
            title: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
                'sed eiusmod tempor incidunt ut labore et dolore magna aliqua.'
                ' \n\nUt enim ad minim veniam,'
                ' quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat.'
                ' \n\nQuis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. '
                'Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
            icon: _eventIcon,
          )
        ]
      });
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CalendarCarousel<Event>(
                height: 420,
                markedDatesMap: _markedDateMap,
                markedDateIconMaxShown: 1,
                markedDateShowIcon: true,
                markedDateIconBuilder: (event) {
                  return event.icon;
                },
                onDayPressed: (DateTime date, List<Event> events) {
                  _markedDateMap.add(date,
                      new Event(
                    date: date,
                    title: 'Event 5',
                    icon: _eventIcon,
                  ));
                },
                thisMonthDayBorderColor: Colors.grey[350],
                todayButtonColor: Colors.black.withOpacity(0.5),
                daysHaveCircularBorder: null,
              ),
              RaisedButton(
                  onPressed: () {
                  },
                  textColor: Colors.white,
                  color: Colors.red,
                  child: Text("DELETE USER")),
            ],
          ),
        ),
      );
    },
  );
}
