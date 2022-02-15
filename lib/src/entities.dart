/// Base class for linkify entries.
abstract class LinkifyEntry {
  String get text;
}

/// [LinkifyText] is a [LinkifyEntry] which contains pure text.
///
/// If an instance of this class was returned as a result of parsing, links in
/// the [text were not found
class LinkifyText implements LinkifyEntry {
  LinkifyText(this.text);

  @override
  final String text;

  @override
  String toString() => text;
}

/// [LinkifyUrl] is a [LinkifyEntry] which contains a link.
///
/// The class can be returned as a result of parsing and supposed to contain
/// information about one link.
/// [url] is parsed link (e.g. https://google.com, tel:+79996335234 or mailto:mail@gmail.com)
/// [text] is text phrase in which the link were found (e.g. google.com, +79996335234 or mail@gmail.com)
class LinkifyUrl implements LinkifyEntry {
  LinkifyUrl(this.url, this.text);

  final String url;

  @override
  final String text;

  @override
  String toString() => text;
}

/// Represents a [url] found in some text with its [startIndex], [endIndex] in
/// that text
class LinkifyLink {
  LinkifyLink({
    required this.url,
    required this.startIndex,
    required this.endIndex,
  });

  final String url;
  final int startIndex;
  final int endIndex;
}
