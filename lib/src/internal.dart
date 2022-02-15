import 'package:native_linkify/native_linkify.dart';

/// DTO object which is used to represent data sent by native code
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

extension LinkifyDtoToLinkConverter on LinkifyDto {
  LinkifyLink toLink() => LinkifyLink(
        url: url,
        endIndex: endIndex,
        startIndex: startIndex,
      );
}

extension LinkifyDtoListToEntriesConverter on List<LinkifyDto> {
  List<LinkifyEntry> toEntries(String originalText) {
    final resList = <LinkifyEntry>[];
    final dtoList = this;

    if (dtoList.isEmpty) {
      if (originalText.isNotEmpty) return [LinkifyText(originalText)];
      return [];
    }

    for (var i = 0; i < dtoList.length; i++) {
      final previousDtoEndIndex = i == 0 ? 0 : dtoList[i - 1].endIndex;

      final textBeforeDto =
          originalText.substring(previousDtoEndIndex, dtoList[i].startIndex);
      if (textBeforeDto.isNotEmpty) {
        resList.add(
          LinkifyText(
            originalText.substring(
              previousDtoEndIndex,
              dtoList[i].startIndex,
            ),
          ),
        );
      }

      resList.add(
        LinkifyUrl(
          dtoList[i].url,
          originalText.substring(dtoList[i].startIndex, dtoList[i].endIndex),
        ),
      );
    }

    final textAfterLastDto = originalText.substring(dtoList.last.endIndex);
    if (textAfterLastDto.isNotEmpty) {
      resList.add(LinkifyText(textAfterLastDto));
    }

    return resList;
  }
}
