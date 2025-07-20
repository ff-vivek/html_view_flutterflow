// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DropdownItemStruct extends BaseStruct {
  DropdownItemStruct({
    String? label,
    String? value,
  })  : _label = label,
        _value = value;

  // "label" field.
  String? _label;
  String get label => _label ?? '';
  set label(String? val) => _label = val;

  bool hasLabel() => _label != null;

  // "value" field.
  String? _value;
  String get value => _value ?? '';
  set value(String? val) => _value = val;

  bool hasValue() => _value != null;

  static DropdownItemStruct fromMap(Map<String, dynamic> data) =>
      DropdownItemStruct(
        label: data['label'] as String?,
        value: data['value'] as String?,
      );

  static DropdownItemStruct? maybeFromMap(dynamic data) => data is Map
      ? DropdownItemStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'label': _label,
        'value': _value,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'label': serializeParam(
          _label,
          ParamType.String,
        ),
        'value': serializeParam(
          _value,
          ParamType.String,
        ),
      }.withoutNulls;

  static DropdownItemStruct fromSerializableMap(Map<String, dynamic> data) =>
      DropdownItemStruct(
        label: deserializeParam(
          data['label'],
          ParamType.String,
          false,
        ),
        value: deserializeParam(
          data['value'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'DropdownItemStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DropdownItemStruct &&
        label == other.label &&
        value == other.value;
  }

  @override
  int get hashCode => const ListEquality().hash([label, value]);
}

DropdownItemStruct createDropdownItemStruct({
  String? label,
  String? value,
}) =>
    DropdownItemStruct(
      label: label,
      value: value,
    );
