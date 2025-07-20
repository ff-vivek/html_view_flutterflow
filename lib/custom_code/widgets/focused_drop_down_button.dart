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

//Automatic FlutterFlow imports

class FocusedDropDownButton extends StatefulWidget {
  const FocusedDropDownButton(
      {super.key,
      this.width,
      this.height,
      this.hintText,
      this.initialOption,
      required this.dropdownList,
      this.errorMessage,
      this.labelText,
      required this.onSelection,
      this.bgColor});

  final double? width;
  final double? height;
  final String? hintText;
  final String? initialOption;
  final List<String> dropdownList;
  final String? errorMessage;
  final String? labelText;
  final Future Function(String selectedValue) onSelection;
  final Color? bgColor;

  @override
  State<FocusedDropDownButton> createState() => _FocusedDropDownButtonState();
}

class _FocusedDropDownButtonState extends State<FocusedDropDownButton> {
  final FocusNode _buttonFocusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isOpen = false;
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _buttonFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _buttonFocusNode.removeListener(_onFocusChange);
    _buttonFocusNode.dispose();
    _overlayEntry?.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    // Open dropdown when the button gets focus
    if (_buttonFocusNode.hasFocus && !_isOpen) {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _isOpen = true;
  }

  void _closeDropdown() {
    // Check if the menu is still open before trying to close
    if (_isOpen) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
    Future.delayed(Duration(milliseconds: 100), () {
      _isOpen = false;
    });
  }

  void _onItemSelected(String value) {
    setState(() {
      _selectedValue = value;
    });
    widget.onSelection(value);
    _closeDropdown();
    FocusScope.of(context).nextFocus();
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height),
          child: _DropdownMenu(
            options: widget.dropdownList,
            onItemSelected: _onItemSelected,
            onFocusLost: _closeDropdown,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(widget.labelText!),
          ),
        CompositedTransformTarget(
          link: _layerLink,
          child: InkWell(
            focusNode: _buttonFocusNode,
            onTap: () {
              if (_isOpen) {
                _closeDropdown();
              } else {
                _openDropdown();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: FlutterFlowTheme.of(context).primary,
                  width: 1.0,
                ),
                color: widget.bgColor ?? Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_selectedValue ?? widget.hintText ?? ''),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DropdownMenu extends StatefulWidget {
  const _DropdownMenu({
    required this.options,
    required this.onItemSelected,
    required this.onFocusLost,
  });

  final List<String> options;
  final ValueChanged<String> onItemSelected;
  final VoidCallback onFocusLost;

  @override
  State<_DropdownMenu> createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<_DropdownMenu> {
  final FocusNode _firstItemFocusNode = FocusNode();
  final FocusScopeNode _menuScopeNode = FocusScopeNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FocusScope.of(context).requestFocus(_firstItemFocusNode);
      }
    });
  }

  @override
  void dispose() {
    _firstItemFocusNode.dispose();
    _menuScopeNode.unfocus();
    _menuScopeNode.dispose(); // ✨ DISPOSE THE SCOPE NODE
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // WRAP THE ENTIRE MENU IN A FOCUS WIDGET
    return FocusScope(
      node: _menuScopeNode,
      // This is the magic! It fires when focus enters or leaves the scope.
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          // If the entire menu scope loses focus, call the callback to close.
          widget.onFocusLost();
        }
      },
      child: Material(
        elevation: 4.0,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: widget.options.length,
          itemBuilder: (context, index) {
            return InkWell(
              focusNode: index == 0 ? _firstItemFocusNode : null,
              onTap: () {
                widget.onItemSelected(widget.options[index]);
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(widget.options[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}
