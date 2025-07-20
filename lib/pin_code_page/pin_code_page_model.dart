import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'pin_code_page_widget.dart' show PinCodePageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PinCodePageModel extends FlutterFlowModel<PinCodePageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for PinCode widget.
  TextEditingController? pinCodeController;
  FocusNode? pinCodeFocusNode;
  String? Function(BuildContext, String?)? pinCodeControllerValidator;
  // State field(s) for Timer widget.
  final timerInitialTimeMs = 300000;
  int timerMilliseconds = 300000;
  String timerValue = StopWatchTimer.getDisplayTime(
    300000,
    hours: false,
    milliSecond: false,
  );
  FlutterFlowTimerController timerController =
      FlutterFlowTimerController(StopWatchTimer(mode: StopWatchMode.countDown));

  @override
  void initState(BuildContext context) {
    pinCodeController = TextEditingController();
  }

  @override
  void dispose() {
    pinCodeFocusNode?.dispose();
    pinCodeController?.dispose();

    timerController.dispose();
  }
}
