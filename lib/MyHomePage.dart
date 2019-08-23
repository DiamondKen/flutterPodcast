import 'package:flutter/material.dart';
import 'package:rss_reader/logic/podcast.dart';
import 'logic/feed_reader.dart';

class PodcastPage extends StatefulWidget {
  PodcastPage({Key key}) : super(key: key);

  _PodcastPageState createState() => _PodcastPageState(key);
}

class _PodcastPageState extends State<PodcastPage> {
  Podcast podcast;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        
      ],
    )
    );
  }
}

class PodcastHomePage extends StatefulWidget {
  PodcastHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PodcastHomePageState createState() => _PodcastHomePageState();
}

class _PodcastHomePageState extends State<PodcastHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PodcastPage(),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
