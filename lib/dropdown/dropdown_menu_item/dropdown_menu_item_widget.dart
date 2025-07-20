import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dropdown_menu_item_model.dart';
export 'dropdown_menu_item_model.dart';

class DropdownMenuItemWidget extends StatefulWidget {
  const DropdownMenuItemWidget({
    super.key,
    required this.itemLabel,
    bool? isSelected,
  }) : this.isSelected = isSelected ?? false;

  final String? itemLabel;
  final bool isSelected;

  @override
  State<DropdownMenuItemWidget> createState() => _DropdownMenuItemWidgetState();
}

class _DropdownMenuItemWidgetState extends State<DropdownMenuItemWidget> {
  late DropdownMenuItemModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DropdownMenuItemModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget!.itemLabel != null && widget!.itemLabel != '',
      child: MouseRegion(
        opaque: false,
        cursor: MouseCursor.defer ?? MouseCursor.defer,
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: 45.0,
          ),
          decoration: BoxDecoration(
            color: () {
              if (widget!.isSelected) {
                return FlutterFlowTheme.of(context).primary;
              } else if (_model.mouseRegionHovered!) {
                return FlutterFlowTheme.of(context).secondary;
              } else {
                return Color(0x00000000);
              }
            }(),
            border: Border.all(
              color: Colors.black,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              widget!.itemLabel!,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.inter(
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    color: widget!.isSelected
                        ? FlutterFlowTheme.of(context).primary
                        : FlutterFlowTheme.of(context).primaryText,
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
            ),
          ),
        ),
        onEnter: ((event) async {
          safeSetState(() => _model.mouseRegionHovered = true);
        }),
        onExit: ((event) async {
          safeSetState(() => _model.mouseRegionHovered = false);
        }),
      ),
    );
  }
}
