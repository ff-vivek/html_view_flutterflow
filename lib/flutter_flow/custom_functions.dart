import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/schema/structs/index.dart';

List<DropdownItemStruct> combineDropDownOptions(
  List<String> dropdownLabels,
  List<String> dropdownValues,
) {
  return List.generate(
    dropdownLabels.length,
    (index) => DropdownItemStruct(
      label: dropdownLabels[index],
      value: dropdownValues[index],
    ),
  );
}
