import 'dart:async';

import 'package:flutter/services.dart';
import 'package:native_linkify/native_linkify.dart';
import 'package:native_linkify/src/internal.dart';

/// [NativeLinkify] class contains static methods which can help you with finding
/// links in text
class NativeLinkify {
  NativeLinkify._();

  static const MethodChannel _channel = MethodChannel('native_linkify');

  /// Parses [text] into [LinkifyEntry] sequence
  ///
  /// Returned list supposed to contain entries of type [LinkifyLink] and [LinkifyText].
  ///
  /// ```dart
  /// final entries = NativeLinkify.linkify('some text link.com regular text')
  /// // [
  /// //    LinkifyText('some text '),
  /// //    LinkifyLink('https://link.com', 'link.com'),
  /// //    LinkifyLink(' regular text'),
  /// // ]
  /// ```
  ///
  /// The method is useful when you want to show links in UI with the rest of
  /// the text:
  ///
  /// ```dart
  /// class TextWithLinks extends StatefulWidget {
  ///   const TextWithLinks({Key? key}) : super(key: key);
  ///
  ///   @override
  ///   _TextWithLinksState createState() => _TextWithLinksState();
  /// }
  ///
  /// class _TextWithLinksState extends State<TextWithLinks> {
  ///   late final Future<List<LinkifyEntry>> loadTextFuture;
  ///
  ///   @override
  ///   void initState() {
  ///     super.initState();
  ///     loadTextFuture = loadText();
  ///   }
  ///
  ///   Future<List<LinkifyEntry>> loadText() async {
  ///     final text = 'text from data source';
  ///     final entries = NativeLinkify.linkify(text);
  ///     return entries;
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return FutureBuilder<List<LinkifyEntry>>(
  ///       future: loadTextFuture,
  ///       builder: (ctx, snap) {
  ///         if (!snap.hasData) return const CircularProgressIndicator();
  ///         return Text.rich(
  ///           TextSpan(
  ///             children: [
  ///               for (final l in snap.data!)
  ///                 if (l is LinkifyText)
  ///                   TextSpan(
  ///                     text: l.text,
  ///                   )
  ///                 else if (l is LinkifyUrl)
  ///                   TextSpan(
  ///                     text: l.text,
  ///                     style: const TextStyle(color: Colors.blue),
  ///                     recognizer: TapGestureRecognizer()
  ///                       ..onTap = () => launch(l.url),
  ///                   )
  ///             ],
  ///           ),
  ///         );
  ///       },
  ///     );
  ///   }
  /// }
  /// ```
  static Future<List<LinkifyEntry>> linkify(String text) async {
    final res = await _channel.invokeMethod('findLinks', text);
    final resList = List<Map>.from(res as List);
    return resList
        .map((e) => LinkifyDto.fromMap(Map<String, dynamic>.from(e)))
        .toList()
        .toEntries(text);
  }

  /// Finds links in given [text] and returns them as [LinkifyLink] list
  static Future<List<LinkifyLink>> find(String text) async {
    final res = await _channel.invokeMethod('findLinks', text);
    final resList = List<Map>.from(res as List);
    return resList
        .map((e) => LinkifyDto.fromMap(Map<String, dynamic>.from(e)).toLink())
        .toList();
  }
}
