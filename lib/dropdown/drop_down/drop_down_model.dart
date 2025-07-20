import '/backend/schema/structs/index.dart';
import '/dropdown/dropdown_menu/dropdown_menu_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'drop_down_widget.dart' show DropDownWidget;
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DropDownModel extends FlutterFlowModel<DropDownWidget> {
  ///  Local state fields for this component.

  DropdownItemStruct? selectedOption;
  void updateSelectedOptionStruct(Function(DropdownItemStruct) updateFn) {
    updateFn(selectedOption ??= DropdownItemStruct());
  }

  bool isMenuOpen = false;

  List<DropdownItemStruct> dropdownOptions = [];
  void addToDropdownOptions(DropdownItemStruct item) =>
      dropdownOptions.add(item);
  void removeFromDropdownOptions(DropdownItemStruct item) =>
      dropdownOptions.remove(item);
  void removeAtIndexFromDropdownOptions(int index) =>
      dropdownOptions.removeAt(index);
  void insertAtIndexInDropdownOptions(int index, DropdownItemStruct item) =>
      dropdownOptions.insert(index, item);
  void updateDropdownOptionsAtIndex(
          int index, Function(DropdownItemStruct) updateFn) =>
      dropdownOptions[index] = updateFn(dropdownOptions[index]);

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Alert Dialog - Custom Dialog] action in Container widget.
  DropdownItemStruct? menuSelectedOption;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
