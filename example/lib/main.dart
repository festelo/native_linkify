import 'package:flutter/material.dart';
import 'dart:async';

import 'package:native_linkify/native_linkify.dart';

void main() {
  runApp(const MyApp());
}

const String defaultText =
    'someText yandex.ru someTextAgain https://yandex.ru +79990000000 яндекс.рф festeloqq@gmail.com';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<LinkifyEntry> _links = [];

  @override
  void initState() {
    super.initState();
    linkify(defaultText);
  }

  Future<void> linkify(String text) async {
    final links = await NativeLinkify.findLinks(
      text,
    );

    if (!mounted) return;

    setState(() {
      _links = links;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Linkify example app'),
        ),
        body: ListView(
          children: [
            TextFormField(
              initialValue: defaultText,
              maxLines: null,
              onChanged: linkify,
            ),
            Text.rich(
              TextSpan(
                children: [
                  for (final l in _links)
                    if (l is LinkifyText)
                      TextSpan(
                        text: l.text,
                      )
                    else if (l is LinkifyUrl)
                      TextSpan(
                        text: l.text,
                        style: const TextStyle(color: Colors.blue),
                      )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
