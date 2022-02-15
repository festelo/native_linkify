// Example from readme file

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:native_linkify/native_linkify.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final entries = await NativeLinkify.linkify(
      'text link.com some@mail.com and +79990000000');
  // Note that this method is asynchronous because the plugin works with native
  // functions via MethodChannel and MethodChannel works only in asynchronous way
  // in real app it's better to linkify text at the place where you load it from
  // your data source
  runApp(
    MyApp(
      entries: entries,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.entries}) : super(key: key);

  final List<LinkifyEntry> entries;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Text.rich(
            TextSpan(
              children: [
                for (final l in entries)
                  if (l is LinkifyText)
                    // Regular text, text without links
                    TextSpan(
                      text: l.text,
                    )
                  else if (l is LinkifyUrl)
                    // Link
                    TextSpan(
                      text: l.text,
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => launch(l.url),
                    )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
