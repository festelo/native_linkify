class LinkifyDto {
  LinkifyDto({
    required this.url,
    required this.startIndex,
    required this.endIndex,
  });

  final String url;
  final int startIndex;
  final int endIndex;

  factory LinkifyDto.fromMap(Map<String, dynamic> map) {
    return LinkifyDto(
      url: map['url']!,
      startIndex: map['startIndex']!.toInt(),
      endIndex: map['endIndex']!.toInt(),
    );
  }
}
