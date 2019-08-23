import 'package:flutter/material.dart';

class PodcastHomePage extends StatefulWidget {
  PodcastHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PodcastHomePageState createState() => new _PodcastHomePageState();
}

class _PodcastHomePageState extends State<PodcastHomePage> {

}
class Tabs{
  final String title;
  final IconData icon;
  const Tabs({this.title, this.icon});
}

class List<Tabs> choices = const <Tabs>[
  const Tabs(title:"Library",icon: Icons.library_music),
  const Tabs(title:"Find", icon: Icons.search)
];

