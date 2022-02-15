import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:url_launcher/url_launcher.dart';
import 'package:native_linkify/native_linkify.dart';

void main() {
  runApp(const MyApp());
}

const String defaultText = '''
regular text => regular text
link without https:// => google.com
link with https:// => https://google.com
link with subdomain => mail.google.com
e-mail => mail@gmail.com
phone number => +79990000000
cyrillic link => москва.рф
localhost link => https://localhost/
link with non-existing top-level domain => link.cet
link with rare top-level domain => map.yandex
(at the time of writing the example it's recognized well in Android, but not recognized in iOS)
''';

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
    final links = await NativeLinkify.linkify(text);

    if (!mounted) return;

    setState(() {
      _links = links;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Native Linkify',
      home: Scaffold(
        body: SafeArea(
          child: ListView(
            children: [
              TextFormField(
                initialValue: defaultText,
                maxLines: null,
                onChanged: linkify,
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Text.rich(
                  TextSpan(
                    children: [
                      for (final l in _links)
                        if (l is LinkifyText) // Regular text
                          TextSpan(
                            text: l.text,
                          )
                        else if (l is LinkifyUrl) // Link
                          TextSpan(
                            text: l.text,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => launch(l.url),
                            style: const TextStyle(color: Colors.blue),
                          )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
