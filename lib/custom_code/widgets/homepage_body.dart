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

class HomepageBody extends StatefulWidget {
  const HomepageBody({
    super.key,
    this.width,
    this.height,
    required this.bodyWidget,
    this.onPageStart,
    this.onPageScrolled,
  });

  final double? width;
  final double? height;
  final Widget Function() bodyWidget;
  final Future Function()? onPageStart;
  final Future Function()? onPageScrolled;

  @override
  State<HomepageBody> createState() => _HomepageBodyState();
}

class _HomepageBodyState extends State<HomepageBody> {
  bool _isScrolling = false;
  bool _isAnimating = false;
  double pendingScroll = 0;
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollStartNotification) {
          _isScrolling = true;
        }
        if (notification is ScrollEndNotification) {
          _isScrolling = false;
          if (notification.metrics.pixels == 0) {
            widget.onPageStart?.call();
            // at Page start
          } else {
            widget.onPageScrolled?.call();
          }
        }
        return false;
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            widget.bodyWidget(),
            HtmlFooter(
              onScroll: (scroll) async {
                if (_isScrolling || _isAnimating) {
                  pendingScroll = pendingScroll + scroll;
                  return;
                }
                _isAnimating = true;
                final currentPending = pendingScroll;
                _scrollController.animateTo(
                  _scrollController.offset + scroll + currentPending,
                  duration: Duration(milliseconds: 16),
                  curve: Curves.easeInOut,
                );
                _isAnimating = false;
                pendingScroll -= currentPending;
              },
            )
          ],
        ),
      ),
    );
  }
}
