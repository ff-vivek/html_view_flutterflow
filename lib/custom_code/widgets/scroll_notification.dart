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

class ScrollNotification extends StatefulWidget {
  const ScrollNotification(
      {super.key,
      this.width,
      this.height,
      required this.widgetBuilder,
      this.onPageStart,
      this.onPageEnd,
      this.onScrollStart,
      this.onScrollEnd});

  final double? width;
  final double? height;
  final Widget Function() widgetBuilder;
  final Future Function()? onPageStart;
  final Future Function()? onPageEnd;
  final Future Function()? onScrollStart;
  final Future Function()? onScrollEnd;

  @override
  State<ScrollNotification> createState() => _ScrollNotificationState();
}

class _ScrollNotificationState extends State<ScrollNotification> {
  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollStartNotification) {
          widget.onScrollStart?.call();
        }
        if (notification is ScrollEndNotification) {
          print('Scroll end: ${notification.metrics.pixels}');
          if (notification.metrics.pixels ==
              notification.metrics.maxScrollExtent) {
            print('At List end: ${notification.metrics.maxScrollExtent}');
            widget.onPageEnd?.call();
            // at Page end
          } else if (notification.metrics.pixels == 0) {
            print('At List start: ${notification.metrics.maxScrollExtent}');
            widget.onPageStart?.call();
            // at Page start
          }
          widget.onScrollEnd?.call();
        }
        return false;
      },
      child: widget.widgetBuilder(),
    );
  }
}
