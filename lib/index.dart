import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:hear2learn/constants.dart';
import 'package:hear2learn/helpers/podcast.dart';
import 'package:hear2learn/models/podcast.dart';
import 'package:hear2learn/redux/state.dart';
import 'package:hear2learn/widgets/common/bottom_app_bar_player.dart';
import 'package:hear2learn/widgets/common/drawer.dart';
import 'package:hear2learn/widgets/home/list.dart';
import 'package:hear2learn/widgets/subscriptions/index.dart';
import 'package:redux/redux.dart';
import 'package:hear2learn/widgets/podcast/index.dart';
import 'package:hear2learn/services/feeds/podcast.dart';
import 'package:test/test.dart';

const String SCIENCE_GENRE_ID = '1315';
const String TECH_GENRE_ID = '1318';
const String COMEDY_GENRE_ID = '1303';
const String BUSINESS_GENRE_ID = '1321';

class Home extends StatelessWidget {
  static const String routeName = 'Home';

  final Future<List<Widget>> fallbackShowcases = getFallbackHomepageLists();
  final Future<List<Widget>> showcases = getHomepageLists();

  Home({
    Key key,
  }) : super(key: key);

  static Future<List<Widget>> getFallbackHomepageLists() async {
    return <Widget>[
      buildSubscriptionsPreview(),
    ];
  }

  static Future<List<Widget>> getHomepageLists() async {
    try {
      return <Widget>[
        buildSubscriptionsPreview(),
        buildHomepageList(const Icon(Icons.lightbulb_outline), 'Science',
            await searchPodcastsByGenre(SCIENCE_GENRE_ID)),
        buildHomepageList(const Icon(Icons.power_settings_new), 'Technology',
            await searchPodcastsByGenre(TECH_GENRE_ID)),
        buildHomepageList(const Icon(Icons.mood), 'Comedy',
            await searchPodcastsByGenre(COMEDY_GENRE_ID)),
        buildHomepageList(const Icon(Icons.attach_money), 'Business',
            await searchPodcastsByGenre(BUSINESS_GENRE_ID)),
      ];
    } catch (e) {
      return getFallbackHomepageLists();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Podcast'),
      ),
      body: FutureBuilder<List<Widget>>(
          future: Future.any<List<Widget>>(<Future<List<Widget>>>[
            showcases,
            Future<List<Widget>>.delayed(
                const Duration(seconds: 10), () => fallbackShowcases),
          ]),
          builder:
              (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
            if (!snapshot.hasData) {
              return Container(
                child: const Center(child: CircularProgressIndicator()),
              );
            }

            return ListView.builder(
              itemBuilder: (BuildContext context, int idx) {
                return snapshot.data[idx];
              },
              itemCount: snapshot.data.length,
              shrinkWrap: true,
            );
          }),
      bottomNavigationBar: const BottomAppBarPlayer(),
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _asyncAddPodcastUrl(context);
          },
          child: Icon(Icons.add)),
    );
  }

  Future<String> _asyncAddPodcastUrl(BuildContext context) async {
    String podcastUrl = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          true, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Podcast Feed Url'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Url', hintText: 'http://example.com/example'),
                onChanged: (value) {
                  podcastUrl = value;
                },
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
                child: Text('Add'),
                onPressed: () {
                  _getPodcast(context: context, url: podcastUrl);
                }),
          ],
        );
      },
    );
  }

  void _getPodcast({BuildContext context, String url}) async {
    final Podcast podcast = await getPodcastFromFeed(url: url);
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            PodcastPage(directToEpisodes: true, podcast: podcast),
        settings: const RouteSettings(name: PodcastPage.routeName),
      ),
    );
  }

  static Widget buildSubscriptionsPreview() {
    const int MAX_SHOWCASE_ITEMS = 12;
    return StoreConnector<AppState, List<Podcast>>(
      converter: (Store<AppState> store) => store.state.subscriptions,
      builder: (BuildContext context, List<Podcast> subscriptions) {
        return HomepageList(
          list: subscriptions,
          onMoreClick: subscriptions.length > MAX_SHOWCASE_ITEMS
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => SubscriptionsPage(),
                      settings: const RouteSettings(
                          name: SubscriptionsPage.routeName),
                    ),
                  );
                }
              : null,
          directToEpisodes: true,
          title: LIBRARY_LABEL,
          titleIcon: const Icon(Icons.collections_bookmark),
        );
      },
    );
  }

  static Widget buildHomepageList(
      Icon titleIcon, String title, List<Podcast> podcasts) {
    return HomepageList(
      list: podcasts,
      title: title,
      titleIcon: titleIcon,
    );
  }
}
