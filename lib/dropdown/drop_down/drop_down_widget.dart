import '/backend/schema/structs/index.dart';
import '/dropdown/dropdown_menu/dropdown_menu_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'drop_down_model.dart';
export 'drop_down_model.dart';

class DropDownWidget extends StatefulWidget {
  const DropDownWidget({
    super.key,
    required this.hintText,
    required this.dropdownLabels,
    required this.dropdownValues,
    this.initialOption,
    required this.maxWidth,
    required this.isDisabled,
    required this.dropdownMaxHeight,
    required this.menuMaxHeight,
    required this.onSelect,
    required this.showError,
    required this.onClickDropdown,
  });

  final String? hintText;
  final List<String>? dropdownLabels;
  final List<String>? dropdownValues;
  final String? initialOption;
  final double? maxWidth;
  final bool? isDisabled;
  final double? dropdownMaxHeight;
  final double? menuMaxHeight;
  final Future Function(DropdownItemStruct onSelect)? onSelect;
  final bool? showError;
  final Future Function(bool onMenuOpened)? onClickDropdown;

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget>
    with TickerProviderStateMixin {
  late DropDownModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DropDownModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.dropdownOptions = functions
          .combineDropDownOptions(widget!.dropdownLabels!.toList(),
              widget!.dropdownValues!.toList())
          .toList()
          .cast<DropdownItemStruct>();
      safeSetState(() {});
      if (widget!.initialOption != null && widget!.initialOption != '') {
        _model.selectedOption = DropdownItemStruct(
          label: widget!.initialOption,
          value: _model.dropdownOptions
              .where((e) => e.label == widget!.initialOption)
              .toList()
              .firstOrNull
              ?.value,
        );
        safeSetState(() {});
      }
    });

    animationsMap.addAll({
      'iconOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          RotateEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 150.0.ms,
            begin: 0.0,
            end: -0.5,
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          var _shouldSetState = false;
          if (widget!.isDisabled!) {
            if (_shouldSetState) safeSetState(() {});
            return;
          }

          // flip dropdown icon
          if (animationsMap['iconOnActionTriggerAnimation'] != null) {
            animationsMap['iconOnActionTriggerAnimation']!
                .controller
                .forward(from: 0.0);
          }
          // menu open state update
          _model.isMenuOpen = true;
          safeSetState(() {});
          // Show Dropdown Menu
          await showAlignedDialog(
            barrierColor: Color(0x00FFFFFF),
            context: context,
            isGlobal: false,
            avoidOverflow: true,
            targetAnchor: AlignmentDirectional(-1.0, 1.0)
                .resolve(Directionality.of(context)),
            followerAnchor: AlignmentDirectional(-1.0, -1.0)
                .resolve(Directionality.of(context)),
            builder: (dialogContext) {
              return Material(
                color: Colors.transparent,
                child: DropdownMenuWidget(
                  dropdownOptions: _model.dropdownOptions,
                  menuMaxHeigh: widget!.menuMaxHeight!,
                  menuMaxWidth: widget!.maxWidth!,
                  selectedOption: _model.selectedOption?.label,
                ),
              );
            },
          ).then(
              (value) => safeSetState(() => _model.menuSelectedOption = value));

          _shouldSetState = true;
          // flip icon back
          if (animationsMap['iconOnActionTriggerAnimation'] != null) {
            animationsMap['iconOnActionTriggerAnimation']!.controller.reverse();
          }
          await widget.onClickDropdown?.call(
            true,
          );
          // menu close state update
          _model.isMenuOpen = false;
          safeSetState(() {});
          // update selected option
          _model.selectedOption = _model.menuSelectedOption != null
              ? _model.menuSelectedOption
              : _model.selectedOption;
          safeSetState(() {});
          // onSelection Callback
          await widget.onSelect?.call(
            _model.selectedOption!,
          );
          if (_shouldSetState) safeSetState(() {});
          return;
          if (_shouldSetState) safeSetState(() {});
        },
        child: Container(
          constraints: BoxConstraints(
            maxWidth: widget!.maxWidth!,
            maxHeight: widget!.dropdownMaxHeight!,
          ),
          decoration: BoxDecoration(
            color: widget!.isDisabled!
                ? FlutterFlowTheme.of(context).alternate
                : Colors.white,
            border: Border.all(
              color: () {
                if (_model.isMenuOpen) {
                  return FlutterFlowTheme.of(context).accent2;
                } else if (widget!.showError!) {
                  return FlutterFlowTheme.of(context).error;
                } else {
                  return FlutterFlowTheme.of(context).primaryBackground;
                }
              }(),
            ),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    valueOrDefault<String>(
                      _model.selectedOption?.label != null &&
                              _model.selectedOption?.label != ''
                          ? _model.selectedOption?.label
                          : widget!.hintText,
                      'Please Select',
                    ),
                    style: FlutterFlowTheme.of(context).labelLarge.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .labelLarge
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .labelLarge
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .labelLarge
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).labelLarge.fontStyle,
                        ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: widget!.isDisabled!
                      ? FlutterFlowTheme.of(context).alternate
                      : FlutterFlowTheme.of(context).primaryText,
                  size: 20.0,
                ).animateOnActionTrigger(
                  animationsMap['iconOnActionTriggerAnimation']!,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
