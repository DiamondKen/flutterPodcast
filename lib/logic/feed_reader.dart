import 'package:xml/xml.dart';
import 'podcast.dart';

Episode decodeEpoisde(XmlElement node) {
  var title = node.findElements("title").single.text;
  var description = node.findElements("description").single.text;
  var originalLink = node.findElements("link").single.text;
  var guid = node.findElements("guid").single.text;
  var pubData = node.findElements("pubData").single.text;
  var duration = node.findElements("itunes:duration").single.text;
  var episodeNum = node.findElements("itunes:episode").single.text;
  var enclosure = node.findElements("enclosure");
  var fileUrl;
  var fileType;
  if (enclosure.length > 0) {
    fileUrl = enclosure.first.getAttribute("url");
    fileType = enclosure.first.getAttribute("type");
  }
  return new Episode(title, description, originalLink, guid, pubData, duration,
      episodeNum, fileUrl, fileType);
}

Podcast decodePodcast(XmlDocument node, String rssUrl) {
  var rssIterable = node.findElements("rss");
  if (rssIterable.length != 1) {
    throw new Exception("Expected 1 rss item");
  }
  var rssChannel = rssIterable.single.findElements("channgel").single;
  var title = rssChannel.findElements("title").single.text;
  var description = rssChannel.findElements("description").single.text;
  var link = rssChannel.findElements("link").single.text;
  var image =
      rssChannel.findElements("image").single.findElements("url").single.text;
  var author = rssChannel.findElements("author").single.text;
  var type = rssChannel.findElements("itunes:type").single.text;
  var episodes = rssChannel
      .findElements("item")
      .where((n) => n is XmlElement)
      .map(decodeEpoisde);
  return new Podcast(
      title, description, link, image, author, type, rssUrl, episodes);
}
