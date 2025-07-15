// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:dropdown_button2/dropdown_button2.dart';

class DropdownButton extends StatefulWidget {
  const DropdownButton({
    super.key,
    this.width,
    this.height,
    this.initialOption,
    required this.dropDownList,
    this.isDropdownDisable,
    this.errorMessage,
    required this.showErrorMessage,
    required this.labelText,
    required this.toolTipMessage,
    required this.showExternalErrorMessage,
    required this.dropdownMaxWidth,
    required this.dropdownMenuMaxHeight,
    required this.onDropDownSelection,
    required this.onMenuStateChange,
    required this.dropdownValues,
    this.maxWidth,
    this.hintText,
  });

  final double? width;
  final double? height;
  final String? initialOption;
  final List<String> dropDownList;
  final bool? isDropdownDisable;
  final String? errorMessage;
  final bool showErrorMessage;
  final String labelText;
  final bool toolTipMessage;
  final bool showExternalErrorMessage;
  final double dropdownMaxWidth;
  final double dropdownMenuMaxHeight;
  final Future Function(String selectedValue) onDropDownSelection;
  final Future Function(bool? isOpen) onMenuStateChange;
  final List<String> dropdownValues;
  final double? maxWidth;
  final String? hintText;

  @override
  State<DropdownButton> createState() => _DropdownButtonState();
}

class _DropdownButtonState extends State<DropdownButton> {
  String? selectedValue;
  bool hasTapped = false;
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _isMenuOpen = false;
  bool _hasOpenedAndClosedMenu = false;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialOption;
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: widget.maxWidth ?? 406.0),
      decoration: const BoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDropdownField(context),
        ].divide(SizedBox(height: 8.0)),
      ),
    );
  }

  Widget _buildDropdownField(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: widget.maxWidth ?? 406.0),
      decoration: BoxDecoration(),
      child: Semantics(
        label: 'This is the dropdown.',
        button: false,
        container: false,
        image: false,
        header: false,
        explicitChildNodes: false,
        excludeSemantics: false,
        liveRegion: false,
        child: DropdownButtonFormField2<String>(
          focusNode: _focusNode,
          value: selectedValue,
          isExpanded: true,
          customButton: _buildCustomButton(context),
          menuItemStyleData: MenuItemStyleData(
            padding: EdgeInsets.symmetric(horizontal: 0.0),
            customHeights: widget.dropdownValues!
                .map((value) => _getOptionHeight(value))
                .toList(),
          ),
          dropdownStyleData: DropdownStyleData(
            width: widget.dropdownMaxWidth,
            maxHeight: widget.dropdownMenuMaxHeight,
            offset: const Offset(0, -8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x26000000), // 15% opacity black
                  offset: Offset(0, 0),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ],
            ),
            elevation: 0, // Only use the custom shadow
          ),
          decoration: const InputDecoration.collapsed(hintText: ''),
          items: widget.dropdownValues!.asMap().entries.map((entry) {
            int index = entry.key;
            String value = entry.value;
            String label = widget.dropDownList![index];
            bool isSelected = selectedValue == value;
            return DropdownMenuItem<String>(
              value: value,
              child: Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    vertical: 14.0, horizontal: 16.0),
                constraints: const BoxConstraints(minHeight: 48.0),
                color: isSelected ? Colors.blue : null,
                child: Text(
                  label,
                  softWrap: true,
                  maxLines: null,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) async {
            setState(() {
              selectedValue = newValue;
              hasTapped = true;
            });
            if (newValue != null) {
              await widget.onDropDownSelection?.call(newValue);
            }
          },
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            height: 1.0,
          ),
          onMenuStateChange: (isOpen) async {
            setState(() {
              _isMenuOpen = isOpen;
              if (!isOpen &&
                  (selectedValue == null || selectedValue!.isEmpty)) {
                _hasOpenedAndClosedMenu = true;
              }
            });
            // Call the custom action callback if provided
            await widget.onMenuStateChange?.call(isOpen);
          },
        ),
      ),
    );
  }

  // Custom button for the dropdown field
  Widget _buildCustomButton(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 37.0),
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: (_isFocused || _isMenuOpen) ? Colors.blue : _getBorderColor(),
          width: (_isFocused || _isMenuOpen) ? 2.0 : 1.0,
        ),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              selectedValue != null && selectedValue!.isNotEmpty
                  ? widget.dropDownList![
                      widget.dropdownValues!.indexOf(selectedValue!)]
                  : (widget.hintText ?? ''),
              style: selectedValue != null && selectedValue!.isNotEmpty
                  ? TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      height: 1.0,
                    )
                  : TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                      height: 1.0,
                    ),
              softWrap: true,
              maxLines: null,
              overflow: TextOverflow.visible,
            ),
          ),
          Icon(
            (_isMenuOpen)
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
            color: Colors.black,
            size: 20.0,
          ),
        ],
      ),
    );
  }

  double _getOptionHeight(String value) {
    // Find the label for this value
    final int index = widget.dropdownValues?.indexOf(value) ?? 0;
    final String label = (widget.dropDownList != null &&
            index >= 0 &&
            index < widget.dropDownList!.length)
        ? widget.dropDownList![index]
        : value;

    // Use the same style as the dropdown items
    final TextStyle style = TextStyle(
      fontSize:
          16, // You can adjust this if your dropdown uses a different size
      fontWeight: FontWeight.w400,
      color: FlutterFlowTheme.of(context).secondaryText,
    );

    // Use the dropdown's max width minus padding
    final double maxWidth =
        widget.dropdownMaxWidth! - 32.0; // 16px padding left+right

    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: label, style: style),
      maxLines: null,
    )..layout(maxWidth: maxWidth);

    // Add vertical padding (14 top + 14 bottom)
    final double height = textPainter.height + 28.0;
    return height < 48.0 ? 48.0 : height;
  }

  Color _getBorderColor() {
    if ((widget.showErrorMessage &&
            (selectedValue == null || selectedValue == '')) ||
        widget.showExternalErrorMessage) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }
}
