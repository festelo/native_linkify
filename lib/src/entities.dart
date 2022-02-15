abstract class LinkifyEntry {
  String get text;
}

class LinkifyText implements LinkifyEntry {
  LinkifyText(this.text);

  @override
  final String text;

  @override
  String toString() => text;
}

class LinkifyUrl implements LinkifyEntry {
  LinkifyUrl(this.url, this.text);

  final String url;

  @override
  final String text;

  @override
  String toString() => text;
}
