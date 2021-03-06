<p>
<a href="https://github.com/festelo/native_linkify/actions"><img src="https://github.com/festelo/native_linkify/actions/workflows/tests.yml/badge.svg" alt="Build & Test"></a>
<a href="https://codecov.io/gh/festelo/native_linkify"><img src="https://codecov.io/gh/festelo/native_linkify/branch/master/graph/badge.svg" alt="codecov"></a>
<a href="https://opensource.org/licenses/Apache-2.0"><img src="https://img.shields.io/badge/License-Apache_2.0-blue.svg" alt="License: Apache 2.0"></a>
</p>

# Flutter's Native Linkify
![Example screenshot](resources/screenshot.png)

`native_linkify` is a Flutter plugin. Use it to find links in plain-text. 

The plugin uses [NSDataDetector](https://developer.apple.com/documentation/foundation/nsdatadetector) for iOS and macOS; [Linkify](https://developer.android.com/reference/android/text/util/Linkify) for Android. This means the plugin finds links in the same way most native apps do, giving much more accurate results than existing pure dart packages.

This plugin doesn't have any widgets to show inline links out of the box, but it has everything you need to create them in a way you like.

Here's example which shows how to implement widget that's turns text URLs, E-Mails and phones into clickable links:
```dart

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
```