import 'dart:async';

import 'package:flutter/services.dart';
import 'package:native_linkify/native_linkify.dart';
import 'package:native_linkify/src/internal.dart';

class NativeLinkify {
  static const MethodChannel _channel = MethodChannel('native_linkify');

  static Future<List<LinkifyEntry>> findLinks(String text) async {
    final res = await _channel.invokeMethod('findLinks', text);
    final resList = List<Map>.from(res as List);
    final dtoList = resList
        .map((e) => LinkifyDto.fromMap(Map<String, dynamic>.from(e)))
        .toList();
    return _convertDtosToEntries(text, dtoList);
  }

  static List<LinkifyEntry> _convertDtosToEntries(
      String text, List<LinkifyDto> dtoList) {
    final resList = <LinkifyEntry>[];

    if (dtoList.isEmpty) {
      if (text.isNotEmpty) return [LinkifyText(text)];
      return [];
    }

    for (var i = 0; i < dtoList.length; i++) {
      final previousDtoEndIndex = i == 0 ? 0 : dtoList[i - 1].endIndex;

      final textBeforeDto =
          text.substring(previousDtoEndIndex, dtoList[i].startIndex);
      if (textBeforeDto.isNotEmpty) {
        resList.add(
          LinkifyText(
              text.substring(previousDtoEndIndex, dtoList[i].startIndex)),
        );
      }

      resList.add(
        LinkifyUrl(
          dtoList[i].url,
          text.substring(dtoList[i].startIndex, dtoList[i].endIndex),
        ),
      );
    }

    final textAfterLastDto = text.substring(dtoList.last.endIndex);
    if (textAfterLastDto.isNotEmpty) {
      resList.add(LinkifyText(textAfterLastDto));
    }

    return resList;
  }
}
