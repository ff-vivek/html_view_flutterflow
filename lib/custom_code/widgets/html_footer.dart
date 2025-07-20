// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart'; // Imports other custom widgets

//
import 'dart:ui_web' as ui_web;
import 'package:web/web.dart' as web;
import 'package:http/http.dart' as http;
import 'dart:js_interop';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class HtmlFooter extends StatefulWidget {
  const HtmlFooter({
    super.key,
    this.width,
    this.height,
    required this.onScroll,
  });

  final double? width;
  final double? height;
  final Future Function(double scroll) onScroll;

  @override
  State<HtmlFooter> createState() => _HtmlFooterState();
}

class _HtmlFooterState extends State<HtmlFooter> {
  bool hasDownloaded = false;

  @override
  void initState() {
    super.initState();
    downloadFooter();
    initScrollListener();
  }

  void downloadFooter() {
    http
        .get(
      Uri.parse(
        'https://origin-navigation-latest-dev.americanexpress.com/partials/en-in/axp-footer/v0',
      ),
    )
        .then((response) {
      setState(() {
        hasDownloaded = true;
      });
      registerFooterFactory(response.body);
    });
  }

  final scrollScript = '''

      <script>
        // 1. Add an event listener to the window's scroll event.
        window.addEventListener('scroll', (event) => {
          // 2. When a scroll occurs, get the vertical scroll position.
          const scrollPosition = window.scrollY;
          // 3. Post a message back to the parent Flutter app.
          window.parent.postMessage('User scrolled to: ' + scrollPosition.toFixed(2), '*');
        });

        window.addEventListener('wheel', (event) => {
      // 2. IMPORTANT: Prevent the browser's default scroll action for this frame.
      event.preventDefault();

      // 3. Send the scroll delta (event.deltaY) to Flutter.
      //    deltaY is positive for scrolling down, negative for up.
      window.parent.postMessage(event.deltaY, '*');
    }, { passive: false });
      </script>
    `;
''';

  void registerFooterFactory(String html) {
    ui_web.platformViewRegistry.registerViewFactory('footer', (
      int viewId, {
      Object? params,
    }) {
      web.HTMLDivElement iframe = web.HTMLDivElement();
      iframe.style.width = '100%';
      iframe.style.height = '100%';
      iframe.style.backgroundColor = 'red';
      // Insert the script before the closing body tag if it exists, otherwise append
      if (html.contains('</body>')) {
        html = html.replaceFirst('</body>', '$scrollScript </body>');
      } else {
        html += scrollScript;
      }
      iframe.innerHTML = html.toJS;
      return iframe;
    });
  }

  void initScrollListener() {
    web.window.onMessage.listen((web.MessageEvent event) {
      widget.onScroll(double.parse(event.data.toString()));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (hasDownloaded) {
      return SizedBox(
        height: 500,
        width: double.infinity,
        child: ExcludeSemantics(
          excluding: true,
          child: IgnorePointer(
            ignoring: true,
            child: HtmlElementView(
              viewType: 'footer',
              onPlatformViewCreated: (int viewId) {},
            ),
          ),
        ),
      );
    }
    return const Center(child: CircularProgressIndicator());
  }
}
