import '/backend/schema/structs/index.dart';
import '/dropdown/dropdown_menu_item/dropdown_menu_item_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dropdown_menu_model.dart';
export 'dropdown_menu_model.dart';

class DropdownMenuWidget extends StatefulWidget {
  const DropdownMenuWidget({
    super.key,
    required this.dropdownOptions,
    required this.menuMaxHeigh,
    required this.menuMaxWidth,
    this.selectedOption,
  });

  final List<DropdownItemStruct>? dropdownOptions;
  final double? menuMaxHeigh;
  final double? menuMaxWidth;
  final String? selectedOption;

  @override
  State<DropdownMenuWidget> createState() => _DropdownMenuWidgetState();
}

class _DropdownMenuWidgetState extends State<DropdownMenuWidget> {
  late DropdownMenuModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DropdownMenuModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: widget!.menuMaxWidth!,
        maxHeight: widget!.menuMaxHeigh!,
      ),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Builder(
        builder: (context) {
          final options = widget!.dropdownOptions!.toList();

          return ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            itemCount: options.length,
            itemBuilder: (context, optionsIndex) {
              final optionsItem = options[optionsIndex];
              return FFFocusIndicator(
                onTap: () async {
                  // close and return value
                  Navigator.pop(context, optionsItem);
                },
                border: Border.all(
                  color: FlutterFlowTheme.of(context).primary,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(2.0),
                child: DropdownMenuItemWidget(
                  key: Key('Key01w_${optionsIndex}_of_${options.length}'),
                  itemLabel: optionsItem.label,
                  isSelected: widget!.selectedOption == optionsItem.label,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
