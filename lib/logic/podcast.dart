class Episode {
  final String title;
  final String description;
  final String originalLink;
  final String guid;
  final String pubData;
  final String duration;
  final String episodeNum;
  final String fileUrl;
  final String fileType;
  Episode(
      this.title,
      this.description,
      this.originalLink,
      this.guid,
      this.pubData,
      this.duration,
      this.episodeNum,
      this.fileUrl,
      this.fileType);

  @override
  String toString() {
    return "$title [$originalLink, $pubData]: $description";
  }
}

class Podcast {
  final String title;
  final String description;
  final String link;
  final String image;
  final String author;
  final String type;
  final String rssUrl;
  final Iterable<Episode> episodes;
  Podcast(this.title, this.description, this.link, this.image, this.author,
      this.type, this.rssUrl, this.episodes);

  @override
  String toString() {
    return "$title [$link]: (${episodes.length} episodes)";
  }
}
